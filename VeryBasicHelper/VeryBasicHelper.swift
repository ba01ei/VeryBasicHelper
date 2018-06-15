//
//  VeryBasicHelper
//
//  Created by Bao Lei on 6/14/18.
//  Copyright © 2018 Bao. All rights reserved.
//

import UIKit

open class VeryBasicHelper: NSObject {
    open class func shortNumberDisplay(_ number: Int) -> String {
        if number < 1000 {
            return "\(number)"
        }
        else if number  < 1000000 {
            return "\(Float(number/100)/10)K"
        }
        else if number  < 1000000000 {
            return "\(Float(number/100000)/10)M"
        }
        return ">1B"
    }
    
    open class func osVersion() -> Float {
        return (UIDevice.current.systemVersion as NSString).floatValue
    }
    
    open class func reversedString(_ str: String) -> String {
        let reversedChars = str.reversed()
        return String(reversedChars)
    }

    open class func appendString(_ mutableStr:NSMutableAttributedString?, text:String, fontName:String, size:CGFloat, lineHeight:CGFloat? = nil, centerAlign:Bool = false, showEllipsis:Bool = true, dict:[NSAttributedString.Key: AnyObject]? = nil) -> NSMutableAttributedString {
        var newAttributedStr : NSAttributedString
        var attributes : [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.font: UIFont(name:fontName, size:size) ?? UIFont.systemFont(ofSize: size)]
        let p = NSMutableParagraphStyle()
        if let l = lineHeight {
            if l > 0 {
                p.minimumLineHeight = l
            }
        }
        if centerAlign {
            p.alignment = .center
        }
        if showEllipsis {
            p.lineBreakMode = NSLineBreakMode.byTruncatingTail
        }
        attributes[NSAttributedString.Key.paragraphStyle] = p
        if let d = dict {
            for (k, v) in d {
                attributes[k] = v
            }
        }
        
        newAttributedStr = NSAttributedString(string: text, attributes:attributes)
        
        var astr : NSMutableAttributedString
        if mutableStr != nil {
            astr = mutableStr!
        }
        else {
            astr = NSMutableAttributedString()
        }
        astr.append(newAttributedStr)
        
        return astr
    }
    
    open class func textSize(_ str: String, font:UIFont, maxWidth:CGFloat) -> CGSize {
        return str.boundingRect(with: CGSize(width: maxWidth, height: 1000), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    open class func jpgNamed(_ name: String) -> UIImage? {
        let scale = Int(UIScreen.main.scale)
        var fullName : String
        if scale > 1 {
            fullName = "\(name)@\(scale)x.jpg"
        }
        else {
            fullName = "\(name).jpg"
        }
        var image = UIImage(named: fullName)
        if image == nil {
            image = UIImage(named: "\(name).jpg")
        }
        return image
    }
    
    /// Caution: this is not reliable for multiline
    open class func sizeOfAttributeString(_ str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let size = str.boundingRect(with: CGSize(width: maxWidth, height: 1000), options:[.usesLineFragmentOrigin, .usesFontLeading], context:nil).size
        return size
    }

    open class func imageFromText(_ text:String, font:UIFont, maxWidth:CGFloat, color:UIColor, alignment: NSTextAlignment, xMargin:CGFloat=0, yMargin:CGFloat=0, shadow: NSShadow? = nil) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = alignment
        
        // single word can't wrap!
        let words = text.components(separatedBy: " ")
        var maxLengthOfWords : CGFloat = 0
        for word in words {
            let wordAString = NSAttributedString(string: word, attributes: [NSAttributedString.Key.font: font])
            let size = VeryBasicHelper.sizeOfAttributeString(wordAString, maxWidth: 1000)
            if size.width > maxLengthOfWords {
                maxLengthOfWords = size.width
            }
        }
        
        var dict = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.paragraphStyle: paragraph]
        if let shadow = shadow {
            dict[NSAttributedString.Key.shadow] = shadow
        }
        let attributedString = NSAttributedString(string: text, attributes: dict)
        
        let size = VeryBasicHelper.sizeOfAttributeString(attributedString, maxWidth: max(maxLengthOfWords, maxWidth))
        let fullSize = CGSize(width: size.width + 2 * xMargin, height: size.height + 2 * yMargin)
        UIGraphicsBeginImageContextWithOptions(fullSize, false , 0.0)
        attributedString.draw(in: CGRect(x: xMargin, y: yMargin, width: size.width, height: size.height))
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if image == nil {
            image = UIImage()
        }
        return image!
    }
    
    open class func stringContains(_ str: String, substring:String) -> Bool {
        return (str as NSString).range(of: substring).location != NSNotFound
    }
    
    /// input string is in yyyy-MM-dd format
    open class func ageFromBirthday(_ string:String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let bd = formatter.date(from: string) {
            let age = Int(round(-bd.timeIntervalSinceNow / 3600 / 24 / 365))
            return age
        }
        return -1
    }
    
    open class func rotateDevice() {
        if UIDevice.current.orientation.isLandscape {
            goToPortrait()
        }
        else {
            goToLandscape()
        }
    }
    
    open class func goToLandscape() {
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    open class func goToPortrait() {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    open class func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    open class func imageFromColor(_ color:UIColor, size:CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    open class func colorWithAdjustedBrightness(_ color:UIColor, ratio:CGFloat) -> UIColor {
        return adjustedColor(color, brightnessRatio: ratio)
    }
    
    open class func adjustedColor(_ color:UIColor, brightnessRatio:CGFloat = 1, saturationRatio:CGFloat = 1, hueRatio:CGFloat = 1) -> UIColor {
        var h : CGFloat = 0
        var s : CGFloat = 0
        var b : CGFloat = 0
        var a : CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let brightness = max(0, b * brightnessRatio)
        let saturation = max(0, s * saturationRatio)
        let hue = max(0, h * hueRatio)
        return UIColor(hue: min(hue, 1), saturation: min(saturation, 1), brightness: min(brightness, 1), alpha:a)
    }
    
    open class func floatOSVersion() -> Float {
        return (UIDevice.current.systemVersion as NSString).floatValue
    }
    
    open class func laterDate(_ date1:Date?, date2:Date?) -> Date? {
        if date1 == nil {
            return date2
        }
        if date2 == nil {
            return date1
        }
        if -date1!.timeIntervalSinceNow > -date2!.timeIntervalSinceNow {
            return date2
        }
        else {
            return date1
        }
    }
    
    open class func earlierDate(_ date1:Date?, date2:Date?) -> Date? {
        if date1 == nil {
            return date2
        }
        if date2 == nil {
            return date1
        }
        if -date1!.timeIntervalSinceNow > -date2!.timeIntervalSinceNow {
            return date1
        }
        else {
            return date2
        }
    }

    open class func numberForVersion(_ version:String) -> Int {
        let parts = version.components(separatedBy: ".")
        let digits = [1000000, 1000, 1]
        var num = 0
        for i in 0 ..< digits.count {
            if i < parts.count {
                num += digits[i] * (parts[i] as NSString).integerValue
            }
        }
        return num
    }
    
    open class func parsedDate(_ string: String?) -> Date? {
        if let string = string {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            var d = formatter.date(from: string)
            if d != nil {
                return d
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
            d = formatter.date(from: string)
            if d != nil {
                return d
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S"
            d = formatter.date(from: string)
            return d
        }
        return nil
    }
    
    open class func trim(_ str : String?) -> String {
        return str?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
    }
    
    open class func utcHourOffset() -> Float {
        return Float(NSTimeZone.local.secondsFromGMT()) / 3600
    }
    
    open class func rgb255(_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat=1) -> UIColor {
        return UIColor(red:r/255.0, green:g/255.0, blue:b/255.0, alpha:a)
    }
    
    open class func fillView(_ view:UIView, superview:UIView) {
        view.frame = superview.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        superview.addSubview(view)
    }
    
    open class func observeNotification(_ action: Selector, target: Any, notificationName: String? = nil) {
        if let name = notificationName ?? "\(action)".components(separatedBy: ":").first, name.count > 0 {
            NotificationCenter.default.addObserver(target, selector: action, name: NSNotification.Name(rawValue: name), object: nil)
        }
    }
    
    open class func postMainThreadNotification(_ notificationName:String, object:Any?, dict:[String:AnyObject]? = nil) {
        if !Thread.isMainThread {
            DispatchQueue.main.async(execute: { () -> Void in
                self.postMainThreadNotification(notificationName, object:object, dict:dict)
            })
            return
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationName), object: object, userInfo:dict)
    }

    open class func alphanumericString(_ str:String?) -> String {
        if let str = str {
            let set = CharacterSet.alphanumerics.inverted
            return str.components(separatedBy: set).joined(separator: "")
        }
        return ""
    }
    
    open class func fitViewWithWidth(_ label:UIView, width:CGFloat, extraW:CGFloat? = nil, extraH:CGFloat? = nil) {
        label.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        label.sizeToFit()
        if extraW != nil || extraH != nil {
            label.frame.size.width += (extraW ?? 0)
            label.frame.size.height += (extraH ?? 0)
        }
    }
    
    open class func durationMin(_ seconds: Int) -> String {
        if seconds < 60 {
            return seconds > 1 ? (String(format: i18n("%d\u{00a0}secs"), seconds) as String) : i18n("1\u{00a0}sec")
        }
        let mins = seconds / 60
        return mins > 1 ? (String(format: i18n("%d\u{00a0}min"), mins) as String) : i18n("1\u{00a0}min")
    }
    
    open class func durationMMSS(_ seconds: Int) -> String {
        let hours = seconds / 3600
        var secondsLeft = seconds % 3600
        let mins = secondsLeft / 60
        secondsLeft = secondsLeft % 60
        if hours > 0 {
            return NSString(format:"%d:%02d:%02d", hours, mins, secondsLeft) as String
        }
        else {
            return NSString(format:"%02d:%02d", mins, secondsLeft) as String
        }
    }
    
    open class func URLAppendParam(_ urlStr:String, paramStr:String) -> String {
        let connector = (urlStr as NSString).range(of: "?").location != NSNotFound ? "&" : "?"
        return "\(urlStr)\(connector)\(paramStr)"
    }
    
    open class func leftAlignButtonLabel(_ button:UIButton, x:CGFloat) {
        if let font = button.titleLabel?.font {
            let textW = button.currentAttributedTitle != nil ? sizeOfAttributeString(button.currentAttributedTitle!, maxWidth: 1000).width : textSize(button.currentTitle != nil ? button.currentTitle! : "", font: font, maxWidth: 1000).width
            let right = button.frame.size.width - x - textW
            //Log("w:\(textW), buttonW:\(button.frame.size.width), x:\(textW), right:\(right)")
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: x, bottom: 0, right: right)
        }
    }
    
    open class func leftOffsetButtonLabel(_ button:UIButton, x:CGFloat) {
        if let font = button.titleLabel?.font {
            let textW = textSize(button.currentTitle != nil ? button.currentTitle! : "", font: font, maxWidth: 1000).width
            let margin = (button.bounds.size.width - x - textW) / 2
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: x+margin, bottom: 0, right: margin)
        }
    }
    
    open class func parsedNumberOnlyDate(_ string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: string)
    }
    
    open class func estimatedHeightOfAtrributedString(_ astr:NSAttributedString, maxWidth: CGFloat, maxFontName:String, maxFontSize:CGFloat, lineHeightMultiplier : CGFloat = 1.1) -> CGFloat {
        guard let font = UIFont(name:maxFontName, size: maxFontSize) else {
            return 0
        }
        return textSize(astr.string, font: font, maxWidth: maxWidth).height * lineHeightMultiplier
    }

    open class func encodedURL(_ str: String) -> String {
        let characterSet = NSMutableCharacterSet.alphanumeric()
        characterSet.addCharacters(in: "-._~")
        return str.addingPercentEncoding(withAllowedCharacters: characterSet as CharacterSet)!
    }
    
    open class func confineSize(_ h : inout CGFloat, w : inout CGFloat, aspectRatio:CGFloat, maxW:CGFloat) {
        w = h * aspectRatio
        if (w > maxW) {
            w = maxW
            h = w / aspectRatio
        }
    }

    /// @param if index is -1 then do append
    open class func arrayByAddingDedupedItems<T1, T2:Hashable>(_ targetArray:[T1]?, sourceArray:[T1]?, atIndex:Int, idField:((T1)->T2)) -> [T1] {
        var set = Set<T2>()
        var result : [T1] = []
        if let targetArray = targetArray {
            for item in targetArray {
                let id = idField(item)
                if !set.contains(id) {
                    set.insert(id)
                    result.append(item)
                }
            }
        }
        if let sourceArray = sourceArray {
            var currentIndex = atIndex
            for item in sourceArray {
                let id = idField(item)
                if !set.contains(id) {
                    set.insert(id)
                    if atIndex < 0 {
                        result.append(item)
                    }
                    else {
                        result.insert(item, at: currentIndex)
                        currentIndex += 1
                    }
                }
            }
        }
        return result
    }

    open class func arrayByDividingIntoChunks<T>(_ array:[T], chunkSize: Int) -> [[T]] {
        var idx = 0
        var itemsInBatches : [[T]] = []
        while idx < array.count {
            var currentBatch : [T] = []
            while idx < array.count && currentBatch.count < chunkSize {
                currentBatch.append(array[idx])
                idx += 1
            }
            itemsInBatches.append(currentBatch)
        }
        return itemsInBatches
    }
    
    open class func imageFromView(_ view:UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        var screenshot : UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return screenshot
    }
    
    open class func documentPath(_ file:String?) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let path = paths.first {
            if let file = file {
                return path + "/" + file
            }
            return path
        }
        return nil
    }
    
    open class func writeText(_ text:String, toFile:String) {
        if let path = documentPath(toFile) {
            do {
                try text.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {
                print("caught: \(error)")
            }
        }
    }
    
    open class func textFromFile(_ file: String) -> String {
        if let path = documentPath(file) {
            return (try? String(contentsOfFile: path, encoding: String.Encoding.utf8)) ?? ""
        }
        return ""
    }
    
    open class func documentFiles() -> [String] {
        if let path = documentPath(nil),
            let contents = try? FileManager.default.contentsOfDirectory(atPath: path)
        {
            return contents.map({$0.components(separatedBy: "/").last ?? ""})
        }
        return []
    }
}
