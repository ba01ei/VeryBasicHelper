//
//  RequestHelper.swift
//  Pods
//
//  Created by Bao Lei on 6/14/18.
//
//

import UIKit

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
    
    open class func request(urlStr:String, timeout : TimeInterval = 10, body: Any? = nil, header:[String:String]? = nil, sharedSession:Bool = true, json:Bool = true, stringResponse:Bool = false, completionHandler:((_ object : Any?, _ statusCode: Int, _ data: Data?, _ responseHeader:[String:AnyObject]?, _ responseString:String?, _ error: Error?) -> Void)?) {
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
                var obj : Any? = nil
                var responseString : String? = nil
                if let data = data, json {
                    obj = JSONFromData(data)
                }
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                let responseHeader = (response as? HTTPURLResponse)?.allHeaderFields as? [String : AnyObject]
                if let data = data, stringResponse {
                    responseString = String(data: data, encoding: String.Encoding.utf8)
                }
                completionHandler?(obj, statusCode, data, responseHeader, responseString, error)
            }).resume()
        }
    }
}
