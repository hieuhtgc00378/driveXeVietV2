//
//  UIScreenExtension.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

public extension UIScreen {
    
    class var size: CGSize {
        return UIScreen.main.bounds.size
    }
    
    class var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    class var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    class var orientationSize: CGSize {
        let systemVersion = (UIDevice.current.systemVersion as NSString).floatValue
        let isLand: Bool = UIApplication.shared.statusBarOrientation.isLandscape
        return (systemVersion > 8.0 && isLand) ? UIScreen.SwapSize(self.size) : self.size
    }
    
    class var orientationWidth: CGFloat {
        return self.orientationSize.width
    }
    
    class var orientationHeight: CGFloat {
        return self.orientationSize.height
    }
    
    class func SwapSize(_ size: CGSize) -> CGSize {
        return CGSize(width: size.height, height: size.width)
    }
    
    class func isWideScreen() -> Bool {
        return UIScreen.height >= 568.0
    }
}






