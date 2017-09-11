// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

public protocol Entry {
	var typeName: String { get }

	var key: String { get }

	var ttl: Date? { get }

	func childResponseObjectMap() -> [GraphQL.AbstractResponse]

	func responseObject() -> GraphQL.AbstractResponse
}

extension Generated {
	open class EntryQuery: GraphQL.AbstractQuery, GraphQLQuery {
		public typealias Response = Entry

		@discardableResult
		open func key(aliasSuffix: String? = nil) -> EntryQuery {
			addField(field: "key", aliasSuffix: aliasSuffix)
			return self
		}

		@discardableResult
		open func ttl(aliasSuffix: String? = nil) -> EntryQuery {
			addField(field: "ttl", aliasSuffix: aliasSuffix)
			return self
		}

		override init() {
			super.init()
			addField(field: "__typename")
		}

		@discardableResult
		open func onIntegerEntry(subfields: (IntegerEntryQuery) -> Void) -> EntryQuery {
			let subquery = IntegerEntryQuery()
			subfields(subquery)
			addInlineFragment(on: "IntegerEntry", subfields: subquery)
			return self
		}

		@discardableResult
		open func onStringEntry(subfields: (StringEntryQuery) -> Void) -> EntryQuery {
			let subquery = StringEntryQuery()
			subfields(subquery)
			addInlineFragment(on: "StringEntry", subfields: subquery)
			return self
		}
	}

	open class UnknownEntry: GraphQL.AbstractResponse, GraphQLObject, Entry {
		public typealias Query = EntryQuery

		open override func deserializeValue(fieldName: String, value: Any) throws -> Any? {
			let fieldValue = value
			switch fieldName {
				case "key":
				guard let value = value as? String else {
					throw SchemaViolationError(type: UnknownEntry.self, field: fieldName, value: fieldValue)
				}
				return value

				case "ttl":
				if value is NSNull { return nil }
				guard let value = value as? String else {
					throw SchemaViolationError(type: UnknownEntry.self, field: fieldName, value: fieldValue)
				}
				return iso8601DateParser.date(from: value)!

				default:
				throw SchemaViolationError(type: UnknownEntry.self, field: fieldName, value: fieldValue)
			}
		}

		open var typeName: String { return field(field: "__typename") as! String }

		open static func create(fields: [String: Any]) throws -> Entry {
			guard let typeName = fields["__typename"] as? String else {
				throw SchemaViolationError(type: UnknownEntry.self, field: "__typename", value: fields["__typename"] ?? NSNull())
			}
			switch typeName {
				case "IntegerEntry":
				return try IntegerEntry.init(fields: fields)

				case "StringEntry":
				return try StringEntry.init(fields: fields)

				default:
				return try UnknownEntry.init(fields: fields)
			}
		}

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

		override open func childObjectType(key: String) -> GraphQL.ChildObjectType {
			switch(key) {
				case "key":

				return .scalar

				case "ttl":

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
