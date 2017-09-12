// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

extension Generated {
	open class SetIntegerInput {
		open var key: String

		open var value: Int32

		open var ttl: InputValue<Date>

		open var negate: InputValue<Bool>

		public init(
			key: String,

			value: Int32,

			ttl: InputValue<Date> = .undefined,

			negate: InputValue<Bool> = .undefined
		) {
			self.key = key

			self.value = value

			self.ttl = ttl

			self.negate = negate
		}

		func serialize() -> String {
			var fields: [String] = []

			fields.append("key:\(GraphQL.quoteString(input: key))")

			fields.append("value:\(value)")

			switch ttl {
				case .defined(let ttl):
				if let ttl = ttl {
					fields.append("ttl:\(GraphQL.quoteString(input: "\(iso8601DateParser.string(from: ttl))"))")
				} else {
					fields.append("ttl:null")
				}
				case .undefined: break
			}

			switch negate {
				case .defined(let negate):
				if let negate = negate {
					fields.append("negate:\(negate)")
				} else {
					fields.append("negate:null")
				}
				case .undefined: break
			}

			return "{\(fields.joined(separator: ","))}"
		}
	}
}
