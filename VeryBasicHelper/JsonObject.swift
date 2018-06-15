//
//  JsonModel.swift
//  Pods
//
//  Created by Bao Lei on 6/14/18.
//
//

import Foundation

open class JsonObject : NSObject {
    public required init(dict:[String: Any]?) {
        super.init()
        self.hydrate(dict)
    }
    
    open func hydrate(_ dict: Any?, arraySetter:((_ name:String, _ array:[[String: Any]]) -> Void)? = nil) {
        if let dict = dict as? [String: Any] {
            
            // get a list of the propery names, so we don't care about anything else
            var propertyNames = [String]()
            var count = UInt32()
            let properties = class_copyPropertyList(type(of: self), &count)
            let intCount = Int(count)
            for i in 0 ..< intCount {
                if let property : objc_property_t = properties?[i] {
                    guard let propertyName = String(utf8String: property_getName(property)) else {
                        debugPrint("Couldn't unwrap property name for \(property)")
                        break
                    }
                    debugPrint("propertyName: \(propertyName)")
                    propertyNames.append(propertyName)
                }
            }
            
            // go through all the property names in the dict
            for (key, value) in dict {
                if let value = value as? [[String: Any]] {
                    // it's hard to get array working for now
                    // defer this to the subclass
                    arraySetter?(key, value)
                }
                else if !propertyNames.contains(key) {
                    continue
                }
                else if let item = self.value(forKey: key) {
                    if value as AnyObject === NSNull() {
                        continue
                    }
                    if let item = item as? JsonObject {
                        item.hydrate(value)
                    }
                    else {
                        self.setValue(value, forKey: key)
                    }
                }
            }
        }
    }
}
