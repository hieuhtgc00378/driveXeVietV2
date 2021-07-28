//
//  SizeUI.swift
//  Tenchi-Front-Panel
//
//  Created by Admin on 7/8/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

import Foundation
import UIKit
import Device

// for label
extension UILabel {

    open override func awakeFromNib() {
        super.awakeFromNib()
          switch Device.size() {
          case .screen4Inch:  self.font = self.font?.withSize(self.font!.pointSize)
          case .screen4_7Inch:  self.font = self.font?.withSize(self.font!.pointSize + 1)
          case .screen5_5Inch: self.font = self.font?.withSize(self.font!.pointSize + 2)
          case .screen5_8Inch: self.font = self.font?.withSize(self.font!.pointSize + 3)
          case .screen6_1Inch: self.font = self.font?.withSize(self.font!.pointSize + 4)
          default:              print("Unknown size")
        }
    }
}

//for textfield
extension UITextField {

    open override func awakeFromNib() {
        super.awakeFromNib()
        switch Device.size() {
           case .screen4Inch:  self.font = self.font?.withSize(self.font!.pointSize)
           case .screen4_7Inch:  self.font = self.font?.withSize(self.font!.pointSize + 1)
           case .screen5_5Inch: self.font = self.font?.withSize(self.font!.pointSize + 2)
           case .screen5_8Inch: self.font = self.font?.withSize(self.font!.pointSize + 3)
           case .screen6_1Inch: self.font = self.font?.withSize(self.font!.pointSize + 4)
           default:              print("Unknown size")
        }
    }
}

//for button
extension UIButton {

    open override func awakeFromNib() {
        super.awakeFromNib()
        switch Device.size() {
            case .screen4Inch:  self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font!.pointSize)!)
            case .screen4_7Inch:  self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font!.pointSize)! + 1)
            case .screen5_5Inch: self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font!.pointSize)! + 2)
            case .screen5_8Inch: self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font!.pointSize)! + 3)
            case .screen6_1Inch: self.titleLabel?.font = self.titleLabel?.font?.withSize((self.titleLabel?.font!.pointSize)! + 4)
            default:              print("Unknown size")
        }
    }
}

// for textView
extension UITextView {

    open override func awakeFromNib() {
        super.awakeFromNib()
        switch Device.size() {
           case .screen4Inch:  self.font = self.font?.withSize(self.font!.pointSize)
           case .screen4_7Inch:  self.font = self.font?.withSize(self.font!.pointSize + 1)
           case .screen5_5Inch: self.font = self.font?.withSize(self.font!.pointSize + 2)
           case .screen5_8Inch: self.font = self.font?.withSize(self.font!.pointSize + 3)
           case .screen6_1Inch: self.font = self.font?.withSize(self.font!.pointSize + 4)
           default:              print("Unknown size")
        }
    }
}

////for custom value returning
//class ClassUIDeviceTypeReturn {
//
//     static let shared = ClassUIDeviceTypeReturn()
//
//     func returnFloatValue(iPhone5: CGFloat, iPhone6: CGFloat, iPhone6Plus: CGFloat, iPhoneX: CGFloat, iPadDefault: CGFloat) -> CGFloat {
//         switch Device.size() {
//                case .screen7_9Inch:  self.font = self.font?.withSize(self.font!.pointSize)
//                case .screen9_7Inch:  self.font = self.font?.withSize(self.font!.pointSize + 1)
//                case .screen10_5Inch: self.font = self.font?.withSize(self.font!.pointSize + 2)
//                case .screen12_9Inch: self.font = self.font?.withSize(self.font!.pointSize + 4)
//                default:              print("Unknown size")
//              }
//     }
//}
