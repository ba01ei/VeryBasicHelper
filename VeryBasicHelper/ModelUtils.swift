//
//  ModelUtils.swift
//

/// Convert json data to Codable object
public class ModelUtils {
    let jsonDecoder = JSONDecoder()
    public init() {}

    /// decode the data to a Codable object
    /// - parameter data the input data
    /// - returns the Codable object
    /// - note Use it together with RequestHelper, e.g.
    /// RequestHelper.request(urlStr: url) { (data, error, _, _, _, _) in
    ///   let response: SomeCodableType? = ModelUtils().decode(data)
    /// }
    public func decode<T: Codable>(_ data: Data?) -> T? {
        if let data = data {
            return try? jsonDecoder.decode(T.self, from: data)
        } else {
            return nil
        }
    }
}
