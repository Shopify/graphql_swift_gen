// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

extension Generated {
	open class IntegerEntryQuery: GraphQL.AbstractQuery, GraphQLQuery {
		public typealias Response = IntegerEntry

		@discardableResult
		open func key(aliasSuffix: String? = nil) -> IntegerEntryQuery {
			addField(field: "key", aliasSuffix: aliasSuffix)
			return self
		}

		@discardableResult
		open func ttl(aliasSuffix: String? = nil) -> IntegerEntryQuery {
			addField(field: "ttl", aliasSuffix: aliasSuffix)
			return self
		}

		@discardableResult
		open func value(aliasSuffix: String? = nil) -> IntegerEntryQuery {
			addField(field: "value", aliasSuffix: aliasSuffix)
			return self
		}
	}

	open class IntegerEntry: GraphQL.AbstractResponse, GraphQLObject, Entry, EntryUnion {
		public typealias Query = IntegerEntryQuery

		open override func deserializeValue(fieldName: String, value: Any) throws -> Any? {
			let fieldValue = value
			switch fieldName {
				case "key":
				guard let value = value as? String else {
					throw SchemaViolationError(type: IntegerEntry.self, field: fieldName, value: fieldValue)
				}
				return value

				case "ttl":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: IntegerEntry.self, field: fieldName, value: fieldValue)
				}
				return iso8601DateParser.date(from: value)!

				case "value":
				guard let value = value as? Int else {
					throw SchemaViolationError(type: IntegerEntry.self, field: fieldName, value: fieldValue)
				}
				return Int32(value)

				default:
				throw SchemaViolationError(type: IntegerEntry.self, field: fieldName, value: fieldValue)
			}
		}

		open var typeName: String { return "IntegerEntry" }

		open var key: String {
			return internalGetKey()
		}

		func internalGetKey(aliasSuffix: String? = nil) -> String {
			return field(field: "key", aliasSuffix: aliasSuffix) as! String
		}

		open var ttl: Date? {
			return internalGetTtl()
		}

		func internalGetTtl(aliasSuffix: String? = nil) -> Date? {
			return field(field: "ttl", aliasSuffix: aliasSuffix) as! Date?
		}

		open var value: Int32 {
			return internalGetValue()
		}

		func internalGetValue(aliasSuffix: String? = nil) -> Int32 {
			return field(field: "value", aliasSuffix: aliasSuffix) as! Int32
		}

		override open func childObjectType(key: String) -> GraphQL.ChildObjectType {
			switch(key) {
				case "key":

				return .scalar

				case "ttl":

				return .scalar

				case "value":

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
