import Foundation

public enum ResponseValue: Equatable {
    case bool(Bool)
    case choice(Choice)
    case choices([Choice])
    case date(Date)
    case int(Int)
    case string(String)
}
