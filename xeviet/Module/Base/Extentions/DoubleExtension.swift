//
//  DoubleExtension.swift
//  LaleTore
//
//  Created by Paditech Inc on 11/11/16.
//  Copyright © 2016 Paditech. All rights reserved.
//

import UIKit

extension Double {
    
    struct Number {
        static let formatterBYR: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.positiveFormat = "#,##0 ¤"
            formatter.negativeFormat = "-#,##0 ¤"
            formatter.currencySymbol = "Руб"
            
            return formatter
        }()
        
        static let formatterJP: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.numberStyle = .currency
            return formatter
        }()
        
        static let formatterEUR: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "pt_PT")
            formatter.numberStyle = .currency
            
            return formatter
        }()
        
        static let formatterUSD: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .currency
            
            return formatter
        }()
        
        static let formatterRUB: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ru_RU")
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            
            return formatter
        }()
        
        static let formatterVN: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "vi-VN") // "en-VN" uses character "," and "vn-VN" uses character "."
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 0
            
            return formatter
        }()
        
        static let formatterLocale: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            
            return formatter
        }()
        
        static let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.numberStyle = .currency
            formatter.currencySymbol = ""
            formatter.maximumFractionDigits = 0
            
            return formatter
        }()
        
        static let formatterPoint: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "ja_JP")
            formatter.numberStyle = .currency
            formatter.currencySymbol = ""
            formatter.maximumFractionDigits = 0
            formatter.roundingMode = .down
            
            return formatter
        }()
    }
    
    func stringDistance() -> String {
        if self < 1000 {
            return NSNumber(value: Int(self) as Int).stringValue + "m"
        } else if self < 100000 {
            return  "\(Int(self/1000))," + "\(Int(self.truncatingRemainder(dividingBy: 1000))/100)km"
        } else {
            return "\(Int(self/1000))km"
        }
    }
    
    func customCurrencyJP(isDevide: Bool = true) -> String {
        let suffix1 = "円"
        let suffix2 = "万円"
        if Int(self) % 10000 == 0, isDevide, self != 0 {
            let currentString = (self/10000).currencyJP
            let resultString = currentString.substring(from: 1)
            return resultString + suffix2
        } else {
            let currentString = self.currencyJP
            let resultString = currentString.substring(from: 1)
            return resultString + suffix1
        }
    }
    
    var currencyLocale: String { return Number.formatterLocale.string(from: NSNumber(value: self)) ?? "" }
    var currencyJP: String { return Number.formatterJP.string(from: NSNumber(value: self)) ?? "¥0" }
    var currencyVN: String { return Number.formatterVN.string(from: NSNumber(value: self)) ?? "₫ 0" }
    var currency: String { return Number.formatter.string(from: NSNumber(value: self)) ?? "0" }
    var currencyPoint: String {
        let result = Number.formatterPoint.string(from: NSNumber(value: self)) ?? "0"
        return result + "P"
    }
    var currencyJPText: String {
        if self >= 10000 && Int(self) % 10000 == 0 {
            let result = Number.formatterPoint.string(from: NSNumber(value: self / 10000)) ?? "0"
            return result + "万円"
        } else {
            let result = Number.formatterPoint.string(from: NSNumber(value: self)) ?? "0"
            return result + "円"
        }
    }
}


extension Int {
    var currencyVN: String { return "\(self) ₫" }
}

