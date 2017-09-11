// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

extension Generated {
	open class MutationQuery: GraphQL.AbstractQuery, GraphQLQuery {
		public typealias Response = Mutation

		open override var description: String {
			return "mutation" + super.description
		}

		@available(*, deprecated, message:"Ambiguous, use set_string instead")
		@discardableResult
		open func `set`(aliasSuffix: String? = nil, key: String) -> MutationQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "set", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func setInteger(aliasSuffix: String? = nil, input: SetIntegerInput) -> MutationQuery {
			var args: [String] = []

			args.append("input:\(input.serialize())")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "set_integer", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func setString(aliasSuffix: String? = nil, key: String, value: String) -> MutationQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			args.append("value:\(GraphQL.quoteString(input: value))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "set_string", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func setStringWithDefault(aliasSuffix: String? = nil, key: String, value: String? = nil) -> MutationQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			if let value = value {
				args.append("value:\(GraphQL.quoteString(input: value))")
			}

			let argsString: String? = args.isEmpty ? nil : "(\(args.joined(separator: ",")))"

			addField(field: "set_string_with_default", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}
	}

	open class Mutation: GraphQL.AbstractResponse, GraphQLObject {
		public typealias Query = MutationQuery

		open override func deserializeValue(fieldName: String, value: Any) throws -> Any? {
			let fieldValue = value
			switch fieldName {
				case "set":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: Mutation.self, field: fieldName, value: fieldValue)
				}
				return value

				case "set_integer":
				guard let value = value as? Bool else {
					throw SchemaViolationError(type: Mutation.self, field: fieldName, value: fieldValue)
				}
				return value

				case "set_string":
				guard let value = value as? Bool else {
					throw SchemaViolationError(type: Mutation.self, field: fieldName, value: fieldValue)
				}
				return value

				case "set_string_with_default":
				guard let value = value as? Bool else {
					throw SchemaViolationError(type: Mutation.self, field: fieldName, value: fieldValue)
				}
				return value

				default:
				throw SchemaViolationError(type: Mutation.self, field: fieldName, value: fieldValue)
			}
		}

		open var typeName: String { return "Mutation" }

		@available(*, deprecated, message:"Ambiguous, use set_string instead")
		open var `set`: String? {
			return internalGetSet()
		}

		@available(*, deprecated, message:"Ambiguous, use set_string instead")
		open func aliasedSet(aliasSuffix: String) -> String? {
			return internalGetSet(aliasSuffix: aliasSuffix)
		}

		func internalGetSet(aliasSuffix: String? = nil) -> String? {
			return field(field: "set", aliasSuffix: aliasSuffix) as! String?
		}

		open var setInteger: Bool {
			return internalGetSetInteger()
		}

		open func aliasedSetInteger(aliasSuffix: String) -> Bool {
			return internalGetSetInteger(aliasSuffix: aliasSuffix)
		}

		func internalGetSetInteger(aliasSuffix: String? = nil) -> Bool {
			return field(field: "set_integer", aliasSuffix: aliasSuffix) as! Bool
		}

		open var setString: Bool {
			return internalGetSetString()
		}

		open func aliasedSetString(aliasSuffix: String) -> Bool {
			return internalGetSetString(aliasSuffix: aliasSuffix)
		}

		func internalGetSetString(aliasSuffix: String? = nil) -> Bool {
			return field(field: "set_string", aliasSuffix: aliasSuffix) as! Bool
		}

		open var setStringWithDefault: Bool {
			return internalGetSetStringWithDefault()
		}

		open func aliasedSetStringWithDefault(aliasSuffix: String) -> Bool {
			return internalGetSetStringWithDefault(aliasSuffix: aliasSuffix)
		}

		func internalGetSetStringWithDefault(aliasSuffix: String? = nil) -> Bool {
			return field(field: "set_string_with_default", aliasSuffix: aliasSuffix) as! Bool
		}

		override open func childObjectType(key: String) -> GraphQL.ChildObjectType {
			switch(key) {
				case "set":

				return .scalar

				case "set_integer":

				return .scalar

				case "set_string":

				return .scalar

				case "set_string_with_default":

				return .scalar

				default:
				return .scalar
			}
		}

		override open func fetchChildObject(key: String) -> GraphQL.AbstractResponse? {
			switch(key) {
				default:
				break
			}
			return nil
		}

		override open func fetchChildObjectList(key: String) -> [GraphQL.AbstractResponse] {
			switch(key) {
				default:
				return []
			}
		}

		open func childResponseObjectMap() -> [GraphQL.AbstractResponse]  {
			return []
		}

		open func responseObject() -> GraphQL.AbstractResponse {
			return self as GraphQL.AbstractResponse
		}
	}
}
