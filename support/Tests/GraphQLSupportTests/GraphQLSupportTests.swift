import XCTest
@testable import GraphQLSupport

class GraphQLSupportTests: XCTestCase {
    func testQuoteString() {
        let escaped = GraphQL.quoteString(input: "\0 \r \n \\ \" c ꝏ")
        XCTAssertEqual(escaped, "\"\\u0000 \\r \\n \\\\ \\\" c ꝏ\"")
    }
}
