import XCTest
@testable import GraphQLSupport

class GraphQLSupportTests: XCTestCase {
    func testQuoteString() {
        let escaped = GraphQL.quoteString(input: "\0 \r \n \\ \" c ꝏ")
        XCTAssertEqual(escaped, "\"\\u0000 \\r \\n \\\\ \\\" c ꝏ\"")
    }

    func testGraphQLResponseInvalidJson() {
        let jsonData = "{".data(using: String.Encoding.utf8)!
        do {
            let _ = try GraphQLResponse<GraphQL.AbstractResponse>(jsonData: jsonData)
            XCTFail("no exception thrown for invalid response")
        } catch {
            XCTAssertTrue(error is GraphQL.JsonParsingError)
        }
    }

    func testInvalidResponses() {
        let invalidJsonStrings = [
            "[]",
            "{}",
            "{ \"data\": \"invalid\" }",
            "{ \"errors\": \"invalid\" }",
            "{ \"errors\": [{}] }",
        ]
        for jsonString in invalidJsonStrings {
            let jsonData = jsonString.data(using: String.Encoding.utf8)!
            do {
                let _ = try GraphQLResponse<GraphQL.AbstractResponse>(jsonData: jsonData)
                XCTFail("no exception thrown for invalid response")
            } catch {
                XCTAssertTrue(error is GraphQL.ViolationError)
            }
        }

    }
}
