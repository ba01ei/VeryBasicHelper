//
//  ModelUtils.swift
//

protocol DictConvertible {
    static func from(_ dict: [String: Any]?) -> Self
}

class ModelUtils {
    static func value<T>(_ dict: [String: Any]?, key: String, or defaultValue: T) ->  T {
        return dict?[key] as? T ?? defaultValue
    }
    
    static func listValue<T: DictConvertible>(_ dict: [String: Any]?, key: String, or defaultValue: [T] = []) -> [T] {
        return (dict?[key] as? [[String: Any]])?.map({T.from($0)}) ?? defaultValue
    }
}
