require 'graphql_swift_gen/reformatter'
require 'graphql_swift_gen/scalar'

require 'erb'

class GraphQLSwiftGen
  attr_reader :schema, :scalars, :script_name, :schema_name, :import_graphql_support

  def initialize(schema, custom_scalars: [], nest_under:, script_name: 'graphql_swift_gen gem', import_graphql_support: false)
    @schema = schema
    @schema_name = nest_under
    @script_name = script_name
    @scalars = (BUILTIN_SCALARS + custom_scalars).reduce({}) { |hash, scalar| hash[scalar.type_name] = scalar; hash }
    @scalars.default_proc = ->(hash, key) { DEFAULT_SCALAR }
    @import_graphql_support = import_graphql_support
  end

  def save(path)
    output = generate
    begin
      Dir.mkdir("#{path}/#{schema_name}")
    rescue Errno::EEXIST
    end
    output.each do |relative_path, file_contents|
      File.write("#{path}/#{relative_path}", file_contents)
    end
  end

  def generate
    output = {}
    output["#{schema_name}.swift"] = generate_schema_file
    schema.types.reject{ |type| type.name.start_with?('__') || type.scalar? }.each do |type|
      output["#{schema_name}/#{type.name}.swift"] = generate_type(type)
    end
    output
  end

  private

  class << self
    private

    def erb_for(template_filename)
      path = File.expand_path("../graphql_swift_gen/templates/#{template_filename}", __FILE__)
      erb = ERB.new(File.read(path))
      erb.filename = path
      erb
    end
  end

  SCHEMA_ERB = erb_for("ApiSchema.swift.erb")
  TYPE_ERB = erb_for("type.swift.erb")
  private_constant :SCHEMA_ERB, :TYPE_ERB

  DEFAULT_SCALAR = Scalar.new(type_name: nil, swift_type: 'String', json_type: 'String')
  private_constant :DEFAULT_SCALAR

  BUILTIN_SCALARS = [
    Scalar.new(
      type_name: 'Int',
      swift_type: 'Int32',
      json_type: 'Int',
      deserialize_expr: ->(expr) { "Int32(#{expr})" },
    ),
    Scalar.new(
      type_name: 'Float',
      swift_type: 'Double',
      json_type: 'Double',
    ),
    Scalar.new(
      type_name: 'String',
      swift_type: 'String',
      json_type: 'String',
    ),
    Scalar.new(
      type_name: 'Boolean',
      swift_type: 'Bool',
      json_type: 'Bool',
    ),
    Scalar.new(
      type_name: 'ID',
      swift_type: 'GraphQL.ID',
      json_type: 'String',
      serialize_expr: ->(expr) { "#{expr}.rawValue" },
      deserialize_expr: ->(expr) { "GraphQL.ID(rawValue: #{expr})" },
    ),
  ]
  private_constant :BUILTIN_SCALARS

  # From: https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/LexicalStructure.html
  RESERVED_WORDS = [
    "associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "protocol", "public", "static", "struct", "subscript", "typealias", "var",
    "break", "case", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "return", "switch", "where", "while",
    "as", "Any", "catch", "false", "is", "nil", "rethrows", "super", "self", "Self", "throw", "throws", "true", "try",
    "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "Type", "unowned", "weak", "willSet"
  ]
  private_constant :RESERVED_WORDS

  def escape_reserved_word(word)
    return word unless RESERVED_WORDS.include?(word)
    return "`#{word}`"
  end

  def generate_schema_file
    reformat(SCHEMA_ERB.result(binding))
  end

  def generate_type(type)
    reformat(TYPE_ERB.result(binding))
  end

  def reformat(code)
    Reformatter.new(indent: "\t").reformat(code)
  end

  def swift_input_type(type, non_null: false)
    code = case type.kind
    when 'NON_NULL'
      return swift_input_type(type.of_type, non_null: true)
    when 'SCALAR'
      scalars[type.name].swift_type
    when 'LIST'
      "[#{swift_input_type(type.of_type, non_null: true)}]"
    when 'INPUT_OBJECT', 'ENUM'
      type.name
    else
      raise NotImplementedError, "Unhandled #{type.kind} input type"
    end
    code += "?" unless non_null
    code
  end

  def swift_json_type(type, non_null: false)
    if !non_null && !type.non_null?
      return 'Any'
    end
    case type.kind
    when "NON_NULL"
      swift_json_type(type.of_type, non_null: true)
    when 'SCALAR'
      scalars[type.name].json_type
    when 'OBJECT', 'INTERFACE', 'UNION'
      "[String: Any]"
    when 'LIST'
      "[#{swift_json_type(type.of_type)}]"
    when 'ENUM'
      'String'
    else
      raise NotImplementedError, "Unexpected #{type.kind} response type"
    end
  end

  def swift_output_type(type, non_null: false)
    code = case type.kind
    when 'NON_NULL'
      return swift_output_type(type.of_type, non_null: true)
    when 'SCALAR'
      scalars[type.name].swift_type
    when 'LIST'
      "[#{swift_output_type(type.of_type)}]"
    when 'OBJECT', 'ENUM'
      "#{schema_name}.#{type.name}"
    when 'INTERFACE', 'UNION'
      type.name
    else
      raise NotImplementedError, "Unhandled #{type.kind} response type"
    end
    code += "?" unless non_null
    code
  end

  def generate_build_input_code(expr, type, wrap: true)
    case type.kind
    when 'SCALAR'
      scalars[type.name].serialize_expr(expr)
    when 'ENUM'
      "\\(#{expr}.rawValue)"
    when 'LIST'
      map_block = generate_build_input_code('$0', type.of_type.unwrap_non_null)
      map_code = map_block == '$0' ? expr : "#{expr}.map{ \"#{map_block}\" }"
      elements = "#{map_code}.joined(separator: \",\")"
      "[\\(#{elements})]"
    when 'INPUT_OBJECT'
      "\\(#{expr}.serialize())"
    else
      raise NotImplementedError, "Unexpected #{type.kind} argument type"
    end
  end

  def deserialize_value_code(field_name, expr, type, untyped: true)
    statements = ""

    if untyped
      json_type = swift_json_type(type.unwrap_non_null, non_null: true)
      statements << "if #{expr} is NSNull { return nil }\n" unless type.non_null?
      statements << <<-SWIFT
        guard let value = #{expr} as? #{json_type} else {
          throw SchemaViolationError(type: type(of: self), field: fieldName, value: fieldValue)
        }
      SWIFT
      expr = 'value'
    end
    type = type.unwrap_non_null

    statements << "return " + case type.kind
    when 'SCALAR'
      scalars[type.name].deserialize_expr(expr)
    when 'LIST'
      untyped = !type.of_type.non_null?
      rethrow = "try " if %w(OBJECT INTERFACE UNION).include?(type.unwrap.kind) || untyped
      sub_statements = "#{rethrow}#{expr}.map { #{deserialize_value_code(field_name, '$0', type.of_type, untyped: untyped)} }"
      sub_statements += " as [Any?]" if untyped
      sub_statements
    when 'OBJECT'
      "try #{type.name}(fields: #{expr})"
    when 'INTERFACE', 'UNION'
      "try Unknown#{type.name}.create(fields: #{expr})"
    when 'ENUM'
      "#{escape_reserved_word(type.name)}(rawValue: #{expr}) ?? .unknownValue"
    else
      raise NotImplementedError, "Unexpected #{type.kind} argument type"
    end
  end

  def swift_arg_defs(field)
    defs = ["aliasSuffix: String? = nil"]
    field.args.each do |arg|
      arg_def = "#{escape_reserved_word(arg.name)}: #{swift_input_type(arg.type)}"
      arg_def << " = nil" unless arg.type.non_null?
      defs << arg_def
    end
    if field.subfields?
      defs << "_ subfields: (#{field.type.unwrap.name}Query) -> Void"
    end
    defs.join(', ')
  end

  def generate_append_objects_code(expr, type, non_null: false)
    if type.non_null?
      non_null = true
      type = type.of_type
    end
    unless non_null
      return "if let value = #{expr} {\n#{generate_append_objects_code('value', type, non_null: true)}\n}"
    end
    return "#{expr}.forEach {\n#{generate_append_objects_code('$0', type.of_type)}\n}" if type.list?

    abstract_response = type.object? ? expr : "#{expr} as! GraphQL.AbstractResponse"
    "response.append(#{abstract_response})\n" \
      "response.append(contentsOf: #{expr}.childResponseObjectMap())"
  end

  def swift_attributes(deprecatable)
    return unless deprecatable.deprecated?
    if deprecatable.deprecation_reason
      message_argument = ", message:#{deprecatable.deprecation_reason.inspect}"
    end
    "@available(*, deprecated#{message_argument})"
  end
end
