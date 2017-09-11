// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

extension Generated {
	open class QueryRootQuery: GraphQL.AbstractQuery, GraphQLQuery {
		public typealias Response = QueryRoot

		@discardableResult
		open func entries(aliasSuffix: String? = nil, first: Int32, after: String? = nil, _ subfields: (EntryQuery) -> Void) -> QueryRootQuery {
			var args: [String] = []

			args.append("first:\(first)")

			if let after = after {
				args.append("after:\(GraphQL.quoteString(input: after))")
			}

			let argsString: String? = args.isEmpty ? nil : "(\(args.joined(separator: ",")))"

			let subquery = EntryQuery()
			subfields(subquery)

			addField(field: "entries", aliasSuffix: aliasSuffix, args: argsString, subfields: subquery)
			return self
		}

		@discardableResult
		open func entry(aliasSuffix: String? = nil, key: String, _ subfields: (EntryQuery) -> Void) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			let subquery = EntryQuery()
			subfields(subquery)

			addField(field: "entry", aliasSuffix: aliasSuffix, args: argsString, subfields: subquery)
			return self
		}

		@discardableResult
		open func entryUnion(aliasSuffix: String? = nil, key: String, _ subfields: (EntryUnionQuery) -> Void) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			let subquery = EntryUnionQuery()
			subfields(subquery)

			addField(field: "entry_union", aliasSuffix: aliasSuffix, args: argsString, subfields: subquery)
			return self
		}

		@available(*, deprecated, message:"Ambiguous, use string instead")
		@discardableResult
		open func `get`(aliasSuffix: String? = nil, key: String) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "get", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func integer(aliasSuffix: String? = nil, key: String) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "integer", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func keys(aliasSuffix: String? = nil, first: Int32, after: String? = nil, type: KeyType? = nil) -> QueryRootQuery {
			var args: [String] = []

			args.append("first:\(first)")

			if let after = after {
				args.append("after:\(GraphQL.quoteString(input: after))")
			}

			if let type = type {
				args.append("type:\(type.rawValue)")
			}

			let argsString: String? = args.isEmpty ? nil : "(\(args.joined(separator: ",")))"

			addField(field: "keys", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func mget(aliasSuffix: String? = nil, keys: [String]) -> QueryRootQuery {
			var args: [String] = []

			args.append("keys:[\(keys.map{ "\(GraphQL.quoteString(input: $0))" }.joined(separator: ","))]")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "mget", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func string(aliasSuffix: String? = nil, key: String) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "string", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func ttl(aliasSuffix: String? = nil, key: String) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "ttl", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func type(aliasSuffix: String? = nil, key: String) -> QueryRootQuery {
			var args: [String] = []

			args.append("key:\(GraphQL.quoteString(input: key))")

			let argsString = "(\(args.joined(separator: ",")))"

			addField(field: "type", aliasSuffix: aliasSuffix, args: argsString)
			return self
		}

		@discardableResult
		open func version(aliasSuffix: String? = nil) -> QueryRootQuery {
			addField(field: "version", aliasSuffix: aliasSuffix)
			return self
		}
	}

	open class QueryRoot: GraphQL.AbstractResponse, GraphQLObject {
		public typealias Query = QueryRootQuery

		open override func deserializeValue(fieldName: String, value: Any) throws -> Any? {
			let fieldValue = value
			switch fieldName {
				case "entries":
				guard let value = value as? [[String: Any]] else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return try value.map { return try UnknownEntry.create(fields: $0) }

				case "entry":
				if value is NSNull { return nil }
				guard let value = value as? [String: Any] else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return try UnknownEntry.create(fields: value)

				case "entry_union":
				if value is NSNull { return nil }
				guard let value = value as? [String: Any] else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return try UnknownEntryUnion.create(fields: value)

				case "get":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return value

				case "integer":
				if value is NSNull { return nil }
				guard let value = value as? Int else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return Int32(value)

				case "keys":
				guard let value = value as? [String] else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return value.map { return $0 }

				case "mget":
				guard let value = value as? [Any] else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return try value.map { if $0 is NSNull { return nil }
				guard let value = $0 as? String else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return value } as [Any?]

				case "string":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return value

				case "ttl":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return iso8601DateParser.date(from: value)!

				case "type":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return KeyType(rawValue: value) ?? .unknownValue

				case "version":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
				}
				return value

				default:
				throw SchemaViolationError(type: QueryRoot.self, field: fieldName, value: fieldValue)
			}
		}

		open var typeName: String { return "QueryRoot" }

		open var entries: [Entry] {
			return internalGetEntries()
		}

		open func aliasedEntries(aliasSuffix: String) -> [Entry] {
			return internalGetEntries(aliasSuffix: aliasSuffix)
		}

		func internalGetEntries(aliasSuffix: String? = nil) -> [Entry] {
			return field(field: "entries", aliasSuffix: aliasSuffix) as! [Entry]
		}

		open var entry: Entry? {
			return internalGetEntry()
		}

		open func aliasedEntry(aliasSuffix: String) -> Entry? {
			return internalGetEntry(aliasSuffix: aliasSuffix)
		}

		func internalGetEntry(aliasSuffix: String? = nil) -> Entry? {
			return field(field: "entry", aliasSuffix: aliasSuffix) as! Entry?
		}

		open var entryUnion: EntryUnion? {
			return internalGetEntryUnion()
		}

		open func aliasedEntryUnion(aliasSuffix: String) -> EntryUnion? {
			return internalGetEntryUnion(aliasSuffix: aliasSuffix)
		}

		func internalGetEntryUnion(aliasSuffix: String? = nil) -> EntryUnion? {
			return field(field: "entry_union", aliasSuffix: aliasSuffix) as! EntryUnion?
		}

		@available(*, deprecated, message:"Ambiguous, use string instead")
		open var `get`: String? {
			return internalGetGet()
		}

		@available(*, deprecated, message:"Ambiguous, use string instead")
		open func aliasedGet(aliasSuffix: String) -> String? {
			return internalGetGet(aliasSuffix: aliasSuffix)
		}

		func internalGetGet(aliasSuffix: String? = nil) -> String? {
			return field(field: "get", aliasSuffix: aliasSuffix) as! String?
		}

		open var integer: Int32? {
			return internalGetInteger()
		}

		open func aliasedInteger(aliasSuffix: String) -> Int32? {
			return internalGetInteger(aliasSuffix: aliasSuffix)
		}

		func internalGetInteger(aliasSuffix: String? = nil) -> Int32? {
			return field(field: "integer", aliasSuffix: aliasSuffix) as! Int32?
		}

		open var keys: [String] {
			return internalGetKeys()
		}

		open func aliasedKeys(aliasSuffix: String) -> [String] {
			return internalGetKeys(aliasSuffix: aliasSuffix)
		}

		func internalGetKeys(aliasSuffix: String? = nil) -> [String] {
			return field(field: "keys", aliasSuffix: aliasSuffix) as! [String]
		}

		open var mget: [String?] {
			return internalGetMget()
		}

		open func aliasedMget(aliasSuffix: String) -> [String?] {
			return internalGetMget(aliasSuffix: aliasSuffix)
		}

		func internalGetMget(aliasSuffix: String? = nil) -> [String?] {
			return field(field: "mget", aliasSuffix: aliasSuffix) as! [String?]
		}

		open var string: String? {
			return internalGetString()
		}

		open func aliasedString(aliasSuffix: String) -> String? {
			return internalGetString(aliasSuffix: aliasSuffix)
		}

		func internalGetString(aliasSuffix: String? = nil) -> String? {
			return field(field: "string", aliasSuffix: aliasSuffix) as! String?
		}

		open var ttl: Date? {
			return internalGetTtl()
		}

		open func aliasedTtl(aliasSuffix: String) -> Date? {
			return internalGetTtl(aliasSuffix: aliasSuffix)
		}

		func internalGetTtl(aliasSuffix: String? = nil) -> Date? {
			return field(field: "ttl", aliasSuffix: aliasSuffix) as! Date?
		}

		open var type: Generated.KeyType? {
			return internalGetType()
		}

		open func aliasedType(aliasSuffix: String) -> Generated.KeyType? {
			return internalGetType(aliasSuffix: aliasSuffix)
		}

		func internalGetType(aliasSuffix: String? = nil) -> Generated.KeyType? {
			return field(field: "type", aliasSuffix: aliasSuffix) as! Generated.KeyType?
		}

		open var version: String? {
			return internalGetVersion()
		}

		func internalGetVersion(aliasSuffix: String? = nil) -> String? {
			return field(field: "version", aliasSuffix: aliasSuffix) as! String?
		}

		override open func childObjectType(key: String) -> GraphQL.ChildObjectType {
			switch(key) {
				case "entries":

				return .objectList

				case "entry":

				return .object

				case "entry_union":

				return .scalar

				case "get":

				return .scalar

				case "integer":

				return .scalar

				case "keys":

				return .scalarList

				case "mget":

				return .scalarList

				case "string":

				return .scalar

				case "ttl":

				return .scalar

				case "type":

				return .scalar

				case "version":

				return .scalar

				default:
				return .scalar
			}
		}

		override open func fetchChildObject(key: String) -> GraphQL.AbstractResponse? {
			switch(key) {
				case "entry":
				return internalGetEntry()?.responseObject()

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
			var response: [GraphQL.AbstractResponse] = []
			objectMap.keys.forEach({
				key in
				switch(key) {
					case "entries":
					internalGetEntries().forEach {
						response.append($0 as! GraphQL.AbstractResponse)
						response.append(contentsOf: $0.childResponseObjectMap())
					}

					case "entry":
					if let value = internalGetEntry() {
						response.append(value as! GraphQL.AbstractResponse)
						response.append(contentsOf: value.childResponseObjectMap())
					}

					case "entry_union":
					if let value = internalGetEntryUnion() {
						response.append(value as! GraphQL.AbstractResponse)
						response.append(contentsOf: value.childResponseObjectMap())
					}

					default:
					break
				}
			})
			return response
		}

		open func responseObject() -> GraphQL.AbstractResponse {
			return self as GraphQL.AbstractResponse
		}
	}
}
