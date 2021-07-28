//
//  StringExtension.swift
//  Supership
//
//  Created by Mac on 8/8/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

extension Int {
    func convertToVND() -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.init(identifier: "vi_VN")
        return "\(numberFormatter.string(from: NSNumber(value: self))!)"
    }
}

extension String {
    
    func convertToVND() -> Int? {
         let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .currency
         numberFormatter.locale = Locale.init(identifier: "vi_VN")
         return numberFormatter.number(from: self)?.intValue
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        
        return String(self[start..<end])
    }
    
    func substring(from: Int) -> String {
        return from < self.count ? self[from..<self.count] : ""
    }
    
    func substring(to: Int) -> String {
        return self[0..<(to + 1)]
    }
    
    func removeAllAfter(char: String) -> String {
        if let index = self.range(of: char)?.lowerBound {
            let substring = self[..<index]
            let string = String(substring)
            print("string before: \(self) \n string after: \(string)")
            return string
        }
        return self
    }
    
    func stringHeightWithMaxWidth(_ maxWidth: CGFloat, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font : font]
        let size: CGSize = self.boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
            ).size
        
        return size.height
    }
    
    func evaluateStringWidth(_ font: UIFont) -> CGFloat {
        //let font = UIFont.systemFontOfSize(15)
        let attributes = NSDictionary(object: font, forKey:NSAttributedString.Key.font as NSCopying)
        let sizeOfText = self.size(withAttributes: (attributes as! [NSAttributedString.Key : Any]))
        
        return sizeOfText.width
    }
    
    func intValue() -> Int {
        if let value = Int(self) {
            return value
        }
        
        return 0
    }
    
    func floatValue() -> Float {
        if let value = Float(self) {
            return value
        }
        
        return 0.0
    }
    
    func doubleValue() -> Double {
        if let value = Double(self) {
            return value
        }
        
        return 0.0
    }
    
    func trimSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func numbersOnly() -> String {
        return self.components(separatedBy: NSCharacterSet(charactersIn: "0123456789").inverted).joined(separator: "")
    }
    
    func isValidUsername() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "([一-龯]+|[ぁ-んァ-ン]+|[a-zA-Z0-9]+|[ａ-ｚＡ-Ｚ０-９]+)$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidBankAccount() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "([ァ-ン]+|[a-zA-Z0-9]+|[ａ-ｚＡ-Ｚ０-９]+|\\(|\\)|\\.|\\-|\\/| |¥|,|「|」)$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    func isValidPassword() -> Bool {
        //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,12}"
        let stricterFilterString = "^.{6,12}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", stricterFilterString)
        
        return passwordTest.evaluate(with: self)
    }
    
    func isValidPhoneNumber() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        guard let detector = try? NSDataDetector(types: types.rawValue) else { return false }
        
        if let match = detector.matches(in: self, options: [], range: NSMakeRange(0, count)).first?.phoneNumber {
            return match == self
        } else {
            return false
        }
    }
    
    func group(by groupSize:Int = 2, separator:String = " ") -> String {
        if self.count < groupSize * 2 {
            return self
        }
        
        let splitSize  = min(max(2,self.count-1) , groupSize)
        let splitIndex = index(startIndex, offsetBy:splitSize)
        
        return self.substring(to: splitIndex)
            + separator
            + self.substring(from: splitIndex).group(by: groupSize, separator: separator)
    }
    
    func toDateFull() -> Date? {
        
        if self.isEmpty { return nil }
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return fmt.date(from: self) ?? Date()
    }
    
    func toDateOnly() -> Date? {
         
         if self.isEmpty { return nil }
         let fmt = DateFormatter()
         fmt.dateFormat = "yyyy-MM-dd"
         return fmt.date(from: self) ?? Date()
     }
    
    func toDateServer() -> Date? {
          if self.isEmpty { return nil }
         return Date.iso8601Formatter.date(from: self) ?? Date()
      }
    
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        if self.isEmpty { return nil }
        let fmt = DateFormatter()
        fmt.dateFormat = format
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = TimeZone(abbreviation: "JST")
        
        return fmt.date(from: self) ?? Date()
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
}

// MARK: - HTML attribute

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func formatHTML() -> String {
        let modifiedFont = String(format:"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html xmlns=\"w3.org/1999/xhtml\" lang=\"it\" dir=\"ltr\"><html><head><title>Receigo</title></head><body><style type='text/css'>img {width:100%@ %@important;height: auto !important;}</style>%@</body></html>", "%", "!", self)
        
        return modifiedFont
    }

    /// Encode URI, escape for special characters
    func encodeURIComponent() -> String? {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-_.!~*'()")
        return self.addingPercentEncoding(withAllowedCharacters: characterSet)
    }
    
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}

extension String {
    func encodeUrl() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
    }
    
    func decodeUrl() -> String? {
        return self.removingPercentEncoding
    }
}

extension String {
    
    func convertToIntString() -> String {
        guard self.count > 0 else { return "" }
        
        switch self.lowercased() {
        case "0", "khong", "không", "khồng", "khống", "khon", "khôn", "zero":
            return "0"
        case "1", "mot", "một", "mốt", "one":
            return "1"
        case "2", "hai", "hải", "hài", "hại", "two":
            return "2"
        case "3", "ba", "bà", "bá", "bả", "three":
            return "3"
        case "4", "bốn", "bôn", "bộn", "four":
            return "4"
        case "5", "năm", "nam", "nắm", "nám", "nàm", "nâm", "five":
            return "5"
        case "6", "sau", "sáu", "sàu", "sâu", "six":
            return "6"
        case "7", "bay", "bảy", "bẩy", "bây", "bầy", "seven":
            return "7"
        case "8", "tam", "tám", "tàm", "tấm", "eight":
            return "8"
        case "9", "chin", "chín", "chìn", "nine":
            return "9"
        default:
            if let number = Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                return String(number.description.prefix(1))
            }
            return ""
        }
    }
}


extension StringProtocol {
    
    func index(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    func endIndex(of string: Self, options: String.CompareOptions = []) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    func indexes(of string: Self, options: String.CompareOptions = []) -> [Index] {
        var result: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range.lowerBound)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
    func ranges(of string: Self, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
            let range = self[startIndex...].range(of: string, options: options) {
                result.append(range)
                startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                    index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}



// MARK: - URL
extension String {
    var urlEncoded: URL? {
        //let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
        //return URL(string: encoded)
        return URL(string: self)
    }
}
