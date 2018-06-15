//
//  HelperFunctions.swift
//  Pods
//
//  Created by Bao Lei on 6/14/18.
//
//

import UIKit

public func i18n(_ str: String) -> String {
    return NSLocalizedString(str, comment: "")
}

public func i18n(_ number:Int, singular:String, plural:String) -> String {
    return number == 1 ? NSLocalizedString(singular, comment: "") : NSLocalizedString(plural, comment: "")
}
