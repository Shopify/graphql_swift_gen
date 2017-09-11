// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

public protocol EntryUnion {
	var typeName: String { get }

	func childResponseObjectMap() -> [GraphQL.AbstractResponse]

	func responseObject() -> GraphQL.AbstractResponse
}

extension Generated {
	open class EntryUnionQuery: GraphQL.AbstractQuery, GraphQLQuery {
		public typealias Response = EntryUnion

		override init() {
			super.init()
			addField(field: "__typename")
		}

		@discardableResult
		open func onIntegerEntry(subfields: (IntegerEntryQuery) -> Void) -> EntryUnionQuery {
			let subquery = IntegerEntryQuery()
			subfields(subquery)
			addInlineFragment(on: "IntegerEntry", subfields: subquery)
			return self
		}

		@discardableResult
		open func onStringEntry(subfields: (StringEntryQuery) -> Void) -> EntryUnionQuery {
			let subquery = StringEntryQuery()
			subfields(subquery)
			addInlineFragment(on: "StringEntry", subfields: subquery)
			return self
		}
	}

	open class UnknownEntryUnion: GraphQL.AbstractResponse, GraphQLObject, EntryUnion {
		public typealias Query = EntryUnionQuery

		open override func deserializeValue(fieldName: String, value: Any) throws -> Any? {
			let fieldValue = value
			switch fieldName {
				default:
				throw SchemaViolationError(type: UnknownEntryUnion.self, field: fieldName, value: fieldValue)
			}
		}

		open var typeName: String { return field(field: "__typename") as! String }

		open static func create(fields: [String: Any]) throws -> EntryUnion {
			guard let typeName = fields["__typename"] as? String else {
				throw SchemaViolationError(type: UnknownEntryUnion.self, field: "__typename", value: fields["__typename"] ?? NSNull())
			}
			switch typeName {
				case "IntegerEntry":
				return try IntegerEntry.init(fields: fields)

				case "StringEntry":
				return try StringEntry.init(fields: fields)

				default:
				return try UnknownEntryUnion.init(fields: fields)
			}
		}

		override open func childObjectType(key: String) -> GraphQL.ChildObjectType {
			switch(key) {
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
