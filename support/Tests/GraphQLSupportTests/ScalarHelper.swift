import Foundation

let iso8601DateParser: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    formatter.timeZone = TimeZone(abbreviation: "UTC")
    return formatter
}()
