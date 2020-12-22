//
//  RequestHelper.swift
//  Pods
//
//  Created by Bao Lei on 6/14/18.
//
//

import UIKit

/// Helper to make network request to a REST endpoint
open class RequestHelper: NSObject {
    open class func dataFromJSON(_ object: Any?) -> Data? {
        if let object = object {
            let data = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0))
            return data
        } else {
            return nil
        }
    }

    open class func JSONFromData(_ data:Data?) -> Any? {
        guard let data = data else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
    }

    open class func stringFromJSON(_ object: Any?) -> String? {
        if let data = dataFromJSON(object) {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil
    }
    
    open class func JSONFromString(_ string:String?) -> Any? {
        if let data = string?.data(using: String.Encoding.utf8) {
            return JSONFromData(data)
        }
        return nil
    }
    
    /// Make network GET or POST request to a REST endpoint
    /// - parameter urlStr is the url
    /// - parameter timeout is the timeout in seconds, defaulting to 10
    /// - parameter body is the POST body, if null it's a GET request. It can be a Data or a dictionary or a string.
    /// - parameter header is the request header
    /// - parameter sharedSession indicates whether sharedSession should be used, defaulting to true
    /// - parameter parseJsonResponse indicates whether response should be parsed into a dictionary (e.g. for debugging)
    /// - parameter parseStringResponse indicates whether response should be parsed into a string (e.g. for debugging)
    /// - parameter completionHandler provides results as (responseData, error, statusCode, responseHeader, responseJsonObject, responseString). The last two will only be available if parseJsonResponse or parseStringResponse are set to true.
    open class func request(urlStr:String, timeout : TimeInterval = 10, body: Any? = nil, header:[String:String]? = nil, sharedSession:Bool = true, parseJsonResponse: Bool = false, parseStringResponse:Bool = false, completionHandler:((_ data: Data?, _ error: Error?, _ statusCode: Int, _ responseHeader:[String:AnyObject]?, _ parsedJsonObject: Any?, _ parsedResponseString:String?) -> Void)?) {
        if let url = NSURL(string: urlStr) {
            let request = NSMutableURLRequest(url: url as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
            
            // flexibly handle body
            var bodyData : Data?
            if let body = body as? Data {
                bodyData = body
            }
            else if let body = body as? String {
                bodyData = body.data(using: String.Encoding.utf8)
            }
            else if let body = body, body is [String:AnyObject] || body is [AnyObject] {
                bodyData = dataFromJSON(body)
                request.setValue("application/JSON", forHTTPHeaderField: "Content-Type")
            }
            if let bodyData = bodyData {
                request.httpBody = bodyData as Data
                request.httpMethod = "POST"
            }
            
            // extra header
            if let header = header {
                for (key, value) in header {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            let session = sharedSession ? URLSession.shared : URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let responseHeader = (response as? HTTPURLResponse)?.allHeaderFields as? [String : AnyObject]

                // extra parsing if asked
                var responseJson: Any? = nil
                var responseString: String? = nil
                if let data = data, parseJsonResponse {
                    responseJson = JSONFromData(data)
                }
                if let data = data, parseStringResponse {
                    responseString = String(data: data, encoding: String.Encoding.utf8)
                }
                
                completionHandler?(data, error, statusCode, responseHeader, responseJson, responseString)
            }).resume()
        }
    }
}
