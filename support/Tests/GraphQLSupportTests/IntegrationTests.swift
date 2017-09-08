import XCTest
import GraphQLSupport

class IntegrationTests: XCTestCase {
    func testStringFieldQuery() {
        let query = Generated.buildQuery { $0.version() }
        XCTAssertEqual(String(describing: query), "{version}")
    }

    func testRequiredArgQuery() {
        let query = Generated.buildQuery { $0.string(key: "user:1:name") }
        XCTAssertEqual(String(describing: query), "{string(key:\"user:1:name\")}")
    }

    func testOptionalArgQuery() {
        let query = Generated.buildQuery { $0.keys(first: 10, after: "cursor") }
        XCTAssertEqual(String(describing: query), "{keys(first:10,after:\"cursor\")}")
    }

    func testArrayArgQuery() {
        let query = Generated.buildQuery { $0.mget(keys: ["one", "two"]) }
        XCTAssertEqual(String(describing: query), "{mget(keys:[\"one\",\"two\"])}")
    }

    func testInterfaceQuery() {
        let query = Generated.buildQuery { $0
            .entry(key: "user:1") { $0
                .ttl()
                .onStringEntry { $0
                    .value()
                }
            }
        }
        let queryString = String(describing: query)
        XCTAssertEqual(queryString, "{entry(key:\"user:1\"){__typename,ttl,... on StringEntry{value}}}")
    }

    func testUnionQuery() {
        let query = Generated.buildQuery { $0
            .entryUnion(key: "user:1") { $0
                .onStringEntry { $0
                    .value()
                }
            }
        }
        let queryString = String(describing: query)
        XCTAssertEqual(queryString, "{entry_union(key:\"user:1\"){__typename,... on StringEntry{value}}}")
    }

    func testEnumInput() {
        let query = Generated.buildQuery { $0
            .keys(first: 10, type: .integer)
        }
        let queryString = String(describing: query)
        XCTAssertEqual(queryString, "{keys(first:10,type:INTEGER)}")
    }

    func testMutation() {
        let query = Generated.buildMutation { $0.setString(key: "foo", value: "bar") }
        XCTAssertEqual(String(describing: query), "mutation{set_string(key:\"foo\",value:\"bar\")}")
    }

    func testInputObject() {
        let query = Generated.buildMutation { $0
            .setInteger(input: Generated.SetIntegerInput(key: "answer", value: 42, negate: true))
        }
        let queryString = String(describing: query)
        XCTAssertEqual(queryString, "mutation{set_integer(input:{key:\"answer\",value:42,negate:true})}")
    }

    func testScalarInput() {
        let ttl = date(year: 2017, month: 1, day: 31, hour: 10, minute: 9, second: 48)
        let query = Generated.buildMutation { $0
            .setInteger(input: Generated.SetIntegerInput(key: "answer", value: 42, ttl: ttl))
        }
        let queryString = String(describing: query)
        XCTAssertEqual(queryString, "mutation{set_integer(input:{key:\"answer\",value:42,ttl:\"2017-01-31T10:09:48Z\"})}")
    }

    func testStringFieldResponse() {
        let data = queryData(json: "{\"data\":{\"version\":\"1.2.3\"}}")
        XCTAssertEqual(data.version, "1.2.3")
    }

    func testOptionalArrayResponse() {
        let data = queryData(json: "{\"data\":{\"mget\":[\"one\", null]}}")
        XCTAssertEqual(data.mget[0], "one")
        XCTAssertNil(data.mget[1])
    }

    func testStringListResponse() {
        let data = queryData(json: "{\"data\":{\"keys\":[\"one\", \"two\"]}}")
        XCTAssertEqual(data.keys, ["one", "two"])
    }

    func testEnumFieldResponse() {
        let data = queryData(json: "{\"data\":{\"type\":\"STRING\"}}")
        XCTAssertEqual(data.type, .string)
    }

    func testUnknownEnumResponse() {
        let data = queryData(json: "{\"data\":{\"type\":\"FUTURE\"}}")
        XCTAssertEqual(data.type, .unknownValue)
    }

    func testScalarFieldResponse() {
        let data = queryData(json: "{\"data\":{\"ttl\":\"2017-01-31T10:09:48Z\"}}")
        XCTAssertEqual(data.ttl, date(year: 2017, month: 1, day: 31, hour: 10, minute: 9, second: 48))
    }

    func testInterfaceResponse() {
        let data = queryData(json: "{\"data\":{\"entry\":{\"__typename\":\"IntegerEntry\",\"value\":42}}}")
        let entry = data.entry!
        XCTAssertEqual(entry.typeName, "IntegerEntry")
        let intEntry = entry as! Generated.IntegerEntry
        XCTAssertEqual(intEntry.value, 42)
    }

    func testInterfaceUnknownTypeResponse() {
        let data = queryData(json: "{\"data\":{\"entry\":{\"__typename\":\"FutureEntry\",\"key\":\"foo\"}}}")
        let entry = data.entry!
        XCTAssertEqual(entry.typeName, "FutureEntry")
        XCTAssertEqual(entry.key, "foo")
    }

    func testUnionResponse() {
        let data = queryData(json: "{\"data\":{\"entry_union\":{\"__typename\":\"IntegerEntry\",\"value\":42}}}")
        let entry = data.entryUnion!
        XCTAssertEqual(entry.typeName, "IntegerEntry")
        let intEntry = entry as! Generated.IntegerEntry
        XCTAssertEqual(intEntry.value, 42)
    }

    func testUnionUnknownTypeResponse() {
        let data = queryData(json: "{\"data\":{\"entry_union\":{\"__typename\":\"FutureEntry\"}}}")
        let entry = data.entryUnion!
        XCTAssertEqual(entry.typeName, "FutureEntry")
    }

    func testMutationResponse() {
        let json = "{\"data\":{\"set_string\":true}}"
        let data = try! GraphQLResponse<Generated.Mutation>(jsonData: json.data(using: String.Encoding.utf8)!).data!
        XCTAssertEqual(data.setString, true)
    }

    private func queryData(json: String) -> Generated.QueryRoot {
        let jsonData = json.data(using: String.Encoding.utf8)!
        let response = try! GraphQLResponse<Generated.QueryRoot>(jsonData: jsonData)
        return response.data!
    }

    private func date(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(abbreviation: "UTC")
        return components.date!
    }
}
