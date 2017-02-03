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
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"version\":\"1.2.3\"}}"))
        XCTAssertEqual(response.version, "1.2.3")
    }

    func testStringListResponse() {
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"keys\":[\"one\", \"two\"]}}"))
        XCTAssertEqual(response.keys, ["one", "two"])
    }

    func testEnumFieldResponse() {
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"type\":\"STRING\"}}"))
        XCTAssertEqual(response.type, .string)
    }

    func testUnknownEnumResponse() {
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"type\":\"FUTURE\"}}"))
        XCTAssertEqual(response.type, .unknownValue)
    }

    func testScalarFieldResponse() {
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"ttl\":\"2017-01-31T10:09:48Z\"}}"))
        XCTAssertEqual(response.ttl, date(year: 2017, month: 1, day: 31, hour: 10, minute: 9, second: 48))
    }

    func testInterfaceResponse() {
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"entry\":{\"__typename\":\"IntegerEntry\",\"value\":42}}}"))
        let entry = response.entry!
        XCTAssertEqual(entry.typeName, "IntegerEntry")
        let intEntry = entry as! Generated.IntegerEntry
        XCTAssertEqual(intEntry.value, 42)
    }

    func testInterfaceUnknownTypeResponse() {
        let response = try! Generated.QueryRoot(fields: parse(json: "{\"data\":{\"entry\":{\"__typename\":\"FutureEntry\",\"key\":\"foo\"}}}"))
        let entry = response.entry!
        XCTAssertEqual(entry.typeName, "FutureEntry")
        XCTAssertEqual(entry.key, "foo")
    }

    func testMutationResponse() {
        let response = try! Generated.Mutation(fields: parse(json: "{\"data\":{\"set_string\":true}}"))
        XCTAssertEqual(response.setString, true)
    }

    private func parse(json: String) -> [String: AnyObject] {
        let responseObj = try! JSONSerialization.jsonObject(with: json.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions(rawValue: 0))
        return (responseObj as! [String: AnyObject])["data"] as! [String: AnyObject]
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
