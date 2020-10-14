

import UIKit
import Foundation
import AVFoundation


//MARK: -UIViewController
extension UIViewController {
    
    func showAlert(title:String?,msg:String,onDismiss:(()->Void)!) {
        let alertControler = UIAlertController.init(title:title, message: msg, preferredStyle:.alert)
        alertControler.addAction(UIAlertAction.init(title:"OK", style:.destructive, handler: { (action) in
            onDismiss()
        }))
        self.present(alertControler,animated:true, completion:nil)
    }
}

//MARK: -CALayer
extension CALayer {
    
    @IBInspectable var uiBorderColor:UIColor? {
        set {
            borderColor = newValue?.cgColor
        }
        get {
            return UIColor(cgColor: borderColor!)
        }
    }
}

//MARK: CGPoint
extension CGPoint {
    
    func distance(_ point: CGPoint) -> CGFloat {
        let xDist = self.x - point.x
        let yDist = self.y - point.y
        return CGFloat(sqrt((xDist * xDist) + (yDist * yDist)))
    }
}

extension UINavigationController {
    func pop(animated: Bool) {
        _ = self.popViewController(animated: animated)
    }
    func popToRoot(animated: Bool) {
        _ = self.popToRootViewController(animated: animated)
    }
}

// ----------------------------------
// MARK: - Convenience -
//
public extension UITableView {
    func register<C>(_ cellType: C.Type) where C: UITableViewCell {
        let name = String(describing: cellType.self)
        self.register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
    func reloadWithAnimation() {
        self.reloadData()
        let tableViewHeight = self.bounds.size.height
        let cells = self.visibleCells
        var delayCounter = 0
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 0.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    func deque<C>(_ cellType: C.Type, at indexPath: IndexPath) -> C where  C: UITableViewCell{
        let name = String(describing: cellType.self)
        let cell = self.dequeueReusableCell(withIdentifier: name, for: indexPath) as! C
        return cell
    }
}


extension UIApplication {
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
}

extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}

extension Character {
    @available(iOS 10.2, *)
    var isSimpleEmoji: Bool {
        guard let firstProperties = unicodeScalars.first?.properties else {
            return false
        }
        return unicodeScalars.count == 1 &&
            (firstProperties.isEmojiPresentation ||
                firstProperties.generalCategory == .otherSymbol)
    }
    
    var isCombinedIntoEmoji: Bool {
        if #available(iOS 10.2, *) {
            return (unicodeScalars.count > 1 &&
                unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector })
                || unicodeScalars.allSatisfy({ $0.properties.isEmojiPresentation })
        } else {
            return (unicodeScalars.count > 1 &&
                unicodeScalars.contains { $0.properties.isJoinControl || $0.properties.isVariationSelector })
        }
    }
    
    var isEmoji: Bool {
        if #available(iOS 10.2, *) {
            return isSimpleEmoji || isCombinedIntoEmoji
        } else {
            return isCombinedIntoEmoji
        }
    }
}

extension String {
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    var isSingleEmoji: Bool {
        return count == 1 && containsEmoji
    }

    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }

    var containsOnlyEmoji: Bool {
        return !isEmpty && !contains { !$0.isEmoji }
    }

    var emojiString: String {
        return emojis.map { String($0) }.reduce("", +)
    }

    var emojis: [Character] {
        return filter { $0.isEmoji }
    }

    var emojiScalars: [UnicodeScalar] {
        return filter{ $0.isEmoji }.flatMap { $0.unicodeScalars }
    }
}

extension UIScreen {
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhoneX = 2436.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
}


extension Date {
    func toString(formaterStyle:String) -> String {
          let dateFormater = DateFormatter.init()
          dateFormater.dateFormat = formaterStyle
          return dateFormater.string(from: self)
      }
    
    var daysInMonth:Int{
          let calendar = Calendar.current
          
          let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
          let date = calendar.date(from: dateComponents)!
          
          let range = calendar.range(of: .day, in: .month, for: date)!
          let numDays = range.count
          
          return numDays
      }
}

//MARK: -UIImageView
extension UIImageView {
    func loadImageFromUrl(strUrl : String, imgPlaceHolder : String) {
        self.kf.setImage(with: URL.init(string: strUrl), options: [.transition(.fade(0.15))]) { result in
            switch result {
            case .success(let _):
                break
            case .failure(let error):
                print(error)
                self.image = UIImage.init(named: imgPlaceHolder)
            }
        }
    }
}

extension UIView {
    func showLoadingIndicator() {
        ProgressIndicator.shared().show( at: self)
    }
    
    func hideLoadingIndicator () {
        if let indicator:ProgressIndicator = self.viewWithTag(19518) as? ProgressIndicator {
            indicator.hide()
        }
    }
    
    func roundViewTopEdges(radius : CGFloat) {
        //        self.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            self.roundCorners(corners: [.topLeft, .topRight], radius: radius)
        }
    }
    
    func roundViewBottomEdges(radius : CGFloat) {
        //        self.layer.masksToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            self.roundCorners(corners: [.topLeft, .topRight], radius: radius)
        }
    }
    
    func roundCorners(corners : UIRectCorner, radius : CGFloat) {
        let rect = self.bounds
        let maskPath = UIBezierPath.init(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize.init(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = rect
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    func addRoundedViewCorners(width:CGFloat,colorBorder: UIColor) {
        layer.cornerRadius = width
        layer.borderWidth = 1.0
        layer.borderColor = colorBorder.cgColor
        layer.masksToBounds = true
    }
    
    func addDropShadow() {
        if self.tag == 999 { return } else { self.tag = 999 }
        layer.masksToBounds = false
        layer.shadowOffset = CGSize.init(width:1, height:1)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3.0
        layer.shadowColor =  UIColor.lightGray.withAlphaComponent(0.5).cgColor
    }
    
}

//MARK: -String
extension String {
    
    //MARK: -Validation Regex
    static let Regex_NameLimit = "^.{3,20}$"
    static let Regex_UserName = "^.{5,20}$"
    static let Regex_Req = "^.{1,}$"
    static let Regex_Email = "[A-Z0-9a-z._%+-]{1,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let Regex_URL = "[A-Za-z0-9.-://]+\\.[A-Za-z]{2,}"
    static let Regex_Phone = "^[0-9]{10}$"
    static let Regex_Pasword = "^.{7,30}$"
    static let Regex_UnsignedInteger = "[0-9]{1,}"
    static let Regex_Year = "[0-9]{4}"
    static let Regex_FloatingNumber = "^[0-9]+(?:\\.[0-9]{1,})?$"
    static let Regex_Currency = "^[0-9]+(?:\\.[0-9]{1,})?$"
    static let Regex_PromoCode = "[a-zA-z0-9]{3,20}"
    static let Regex_NA = "na"
    static let Regex_Required = "required"
    
    var optionalRegex:String {
        set{}
        get {
            return "^$|\(self)"
        }
    }
    
    var xmlEscaped: String {
        return replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "<", with: "&lt;")
    }
    
    var xmlUnEscaped: String {
        return replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&#39;", with: "'")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&lt;", with: "<")
    }
    
    func isValidEmail() -> Bool {
        let strText = self.trimmingCharacters(in: .whitespaces)
        return strText.validate(withRegex: String.Regex_Email)
    }
    
    func isValidPhone() -> Bool {
        let strText = self.trimmingCharacters(in: .whitespaces)
        return strText.validate(withRegex: String.Regex_Phone)
    }
    
    func validate(withRegex regex:String) -> Bool {
        let predicateRegex = NSPredicate.init(format: "SELF MATCHES %@", regex)
        return predicateRegex.evaluate(with:self)
    }
    
    static var appVersion:String {
        set {}
        get {
            return (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? "-"
        }
    }
    
    func numberString() -> String {
        return self.components(separatedBy: CharacterSet.init(charactersIn: "01234567890").inverted).joined(separator: "")
    }
    
    func toDate(formaterStyle:String) -> Date {
        let dateFormater = DateFormatter.init()
        dateFormater.timeZone = Calendar.current.timeZone
        dateFormater.locale  = Calendar.current.locale
        dateFormater.dateFormat = formaterStyle
        return dateFormater.date(from: self)!
    }
    
    func fileURLPath() -> String {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return directoryPath!.appending(self)
    }
    
    func downloadPath() -> URL {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        return URL.init(fileURLWithPath: directoryPath!.appending("/\(self)"))
    }
    
    static func deviceTokenToString(token:Data) -> String {
        var strToken = ""
        for i in 0..<token.count {
            strToken = strToken + String(format:"%02.2hhx", arguments:[token[i]])
        }
        return strToken
    }
    
    func containsCaseSensitive(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    //Returns words at specified index in a string.
    func wordAt(index:Int)-> String {
        let arySepratedStrs = self.components(separatedBy: CharacterSet.init(charactersIn:" "))
        if index < arySepratedStrs.count {
            return arySepratedStrs[index]
        }
        return ""
    }
    
    func localize() -> String {
        return NSLocalizedString(self, comment:"")
    }
    
    static func fromFloat(num:Float) -> String {
        return (num.truncatingRemainder(dividingBy:1) == 0) ? String(format: "%.0f", num) : String.init(format:"%0.1f",num)
    }
    
    func isDateFromThisStringIsOfPast() -> Bool {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd HH:mm"
        let startTimeStamp = dateFormatter1.date(from: self)?.timeIntervalSince1970
        if Date().timeIntervalSince1970 - startTimeStamp! < 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func isDateFromThisStringIsOfFutureWithString(strDate : String) -> Bool {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd HH:mm"
        let startTimeStamp = dateFormatter1.date(from: self)?.timeIntervalSince1970
        let compareTimeStamp = dateFormatter1.date(from: strDate)?.timeIntervalSince1970
        
        if compareTimeStamp! - startTimeStamp! > 0 { return true }
        else { return false }
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func trimNewLine() -> String {
        return String(self.filter { !"\n".contains($0) })
    }
    
//    func toDouble() -> Double? {
//        return NumberFormatter().number(from: self)?.doubleValue
//    }
    
    public func toDouble() -> Double?{
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
        

    //Config file methods
    func sliceString(strXmlTag: String) -> String? {
        let strFrom = strXmlTag.xmlStartTag()
        let strTo = strXmlTag.xmlEndTag()
        return (range(of: strFrom)?.upperBound).flatMap { substringFrom in
            (range(of: strTo, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
    
    func xmlStartTag() -> String {
        return "<\(self)>"
    }
    
    func xmlEndTag() -> String {
        return "</\(self)>"
    }
    
    
    func sliceLayoutString(strFrom : String, strTo : String) -> String {
        return (range(of: strFrom)?.upperBound).flatMap { substringFrom in
            (range(of: strTo, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
            } ?? ""
    }
    
    func removeTagFromString(_ strTag : String) -> String {
        
        let strFrom = "<\(strTag)"
        let strTo = "\(strTag)>"
        
        let strSlice = (range(of: strFrom)?.upperBound).flatMap { substringFrom in
            (range(of: strTo, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
            } ?? ""
        
        return self.replacingOccurrences(of: strSlice, with:"")
    }

    
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
        
    
    func utcDateFromString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        var strDate = self.replacingOccurrences(of: "T", with: " ")
        strDate = strDate.replacingOccurrences(of: "Z", with: "")
        if let crDate = dateFormatter.date(from: strDate) {
            return crDate
        }
        
        return nil
    }
    
    
    func localDateFromString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.current
        
        var strDate = self.replacingOccurrences(of: "T", with: " ")
        strDate = strDate.replacingOccurrences(of: "Z", with: "")
        if let crDate = dateFormatter.date(from: strDate) {
            return crDate
        }
        
        return nil
    }
    
}


//MARK: -UITextField
extension UITextField {
    func isNoTextExists() -> Bool {
        if self.text?.startIndex == self.text?.endIndex {
            return true
        }
        else {
            return false
        }
    }
}

//MARK: -UIButton
extension UIButton {
    func setTitle(title:String) {
        self.setTitle(title, for:.normal)
        self.setTitle(title, for:.focused)
        self.setTitle(title, for:.highlighted)
    }
    
    func setImage(imgName:String) {
        self.setImage(UIImage.init(named:imgName), for:.normal)
        self.setImage(UIImage.init(named:imgName), for:.focused)
        self.setImage(UIImage.init(named:imgName), for:.highlighted)
    }
    
    func setCornerRadius(radius:CGFloat,colorBorder: UIColor) {
        layer.cornerRadius = radius
        layer.borderWidth = 1.0
        layer.borderColor = colorBorder.cgColor
        clipsToBounds = true
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }

}

//MARK: UIStoryboard
extension UIStoryboard {
    
    func instantiateViewController<T: UIViewController>() -> T {
        let viewController = self.instantiateViewController(withIdentifier: T.className)
        guard let typedViewController = viewController as? T else {
            fatalError("Unable to cast view controller of type (\(type(of: viewController))) to (\(T.className))")
        }
        return typedViewController
    }
}


extension NSObject {
    
    static var className: String {
        return String(describing: self)
    }
}


//MARK: -UIColor
extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage))
    }
    
    /// Adjusts a colour by a `percentage`.
    ///
    /// Lightening → positive percentage
    ///
    /// Darkening → negative percentage
    func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0
        var white:CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        }
        else if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: min(hue + percentage/100, 1.0),
                           saturation: min(saturation + percentage/100, 1.0),
                           brightness: min(brightness + percentage/100, 1.0),
                           alpha: alpha)
        }
        else if self.getWhite(&white, alpha: &alpha) {
            return UIColor.init(white:min(white + percentage/100, 1.0), alpha: alpha)
        }
        else {
            return UIColor.init(white: 0.2, alpha: 0.6)
        }
    }
    
    class func withHex(hex:String,alpha:CGFloat) -> UIColor {
        var cString:String = hex.trimmingCharacters(in:.whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
