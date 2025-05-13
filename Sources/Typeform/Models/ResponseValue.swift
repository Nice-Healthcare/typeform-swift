import Foundation

public enum ResponseValue: Hashable {
    case bool(Bool)
    case choice(Choice)
    case choices([Choice])
    case date(Date)
    case int(Int)
    case string(String)
    case upload(Upload)
}
