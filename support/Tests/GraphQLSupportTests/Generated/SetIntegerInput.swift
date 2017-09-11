// Generated from graphql_swift_gen gem
import Foundation

import GraphQLSupport

extension Generated {
	open class SetIntegerInput {
		open var key: String

		open var value: Int32

		open var ttl: Date? {
			didSet {
				ttlSeen = true
			}
		}
		private var ttlSeen: Bool = false

		open var negate: Bool? {
			didSet {
				negateSeen = true
			}
		}
		private var negateSeen: Bool = false

		public init(
			key: String,

			value: Int32,

			ttl: Date?? = nil,

			negate: Bool?? = nil
		) {
			self.key = key

			self.value = value

			if let ttl = ttl {
				self.ttlSeen = true
				self.ttl = ttl
			}

			if let negate = negate {
				self.negateSeen = true
				self.negate = negate
			}
		}

		func serialize() -> String {
			var fields: [String] = []

			fields.append("key:\(GraphQL.quoteString(input: key))")

			fields.append("value:\(value)")

			if ttlSeen {
				if let ttl = ttl {
					fields.append("ttl:\(GraphQL.quoteString(input: "\(iso8601DateParser.string(from: ttl))"))")
				} else {
					fields.append("ttl:null")
				}
			}

			if negateSeen {
				if let negate = negate {
					fields.append("negate:\(negate)")
				} else {
					fields.append("negate:null")
				}
			}

			return "{\(fields.joined(separator: ","))}"
		}
	}
}
