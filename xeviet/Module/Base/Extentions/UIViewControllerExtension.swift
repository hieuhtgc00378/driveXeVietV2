//
//  UIViewControllerExtension.swift
//  Supership
//
//  Created by Mac on 8/8/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topVC(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topVC(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topVC(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topVC(controller: presented)
        }
        return controller
    }
}

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var isVisible: Bool {
        return self.isViewLoaded && self.view.window != nil
    }
    
    func fixEdgesView() {
        // fix error that tabbar covers the view
        self.edgesForExtendedLayout = []
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func createLeftBarButtonWithName(_ buttonName: String, target: AnyObject, sel: Selector, titleColor: UIColor? = nil) {
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.setTitle(buttonName, for: .normal)
        leftButton.setTitleColor(UIColor.gray, for: .highlighted)
//        leftButton.titleLabel?.font = PDefined.fontBold(size: 16)
        if titleColor != nil {
            leftButton.setTitleColor(titleColor, for: .normal)
        }
        let size = 16 + buttonName.evaluateStringWidth((leftButton.titleLabel?.font)!)
        leftButton.frame = CGRect(x: 0, y: 0, width: max(44, size), height: 44)
        leftButton.addTarget(target, action: sel, for: .touchUpInside)
        leftButton.isExclusiveTouch = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    }
    
    func createLeftBarButtonWithImage(_ image: UIImage, target: AnyObject, sel: Selector) -> UIButton {
        let leftButton = UIButton(type: UIButton.ButtonType.custom)
        leftButton.frame = CGRect(x: 0, y: 0, width: max(44, image.size.width), height: 44)
        leftButton.setImage(image, for: .normal)
        leftButton.addTarget(target, action: sel, for: .touchUpInside)
        leftButton.isExclusiveTouch = true
        leftButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -24, bottom: 0, right: 0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        return leftButton
    }
    
    func createRightBarButtonWithName(_ buttonName: String, target: AnyObject, sel: Selector, titleColor: UIColor? = nil) {
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.setTitle(buttonName, for: .normal)
        rightButton.setTitleColor(UIColor.gray, for: .highlighted)
//        rightButton.titleLabel?.font = PDefined.fontBold(size: 16)
        if titleColor != nil {
            rightButton.setTitleColor(titleColor, for: .normal)
        }
        let size = 16 + buttonName.evaluateStringWidth((rightButton.titleLabel?.font)!)
        rightButton.frame = CGRect(x: 0, y: 0, width: max(44, size), height: 44)
        rightButton.addTarget(target, action: sel, for: .touchUpInside)
        rightButton.isExclusiveTouch = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func createRightBarButtonWithImage(_ image: UIImage, target: AnyObject, sel: Selector) {
        let rightButton = UIButton(type: UIButton.ButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: max(44, image.size.width), height: 44)
        rightButton.setImage(image, for: .normal)
        rightButton.addTarget(target, action: sel, for: .touchUpInside)
        rightButton.isExclusiveTouch = true
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -24)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    func createBarButtonItem(title: String, target: AnyObject, sel: Selector, titleColor: UIColor? = nil) -> UIBarButtonItem {
        let itemButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        itemButton.setTitle(title, for: .normal)
        itemButton.setTitleColor(UIColor.gray, for: .highlighted)
//        itemButton.titleLabel?.font = PDefined.fontBold(size: 16)
        if titleColor != nil {
            itemButton.setTitleColor(titleColor, for: .normal)
        }
        let size = 16 + title.evaluateStringWidth((itemButton.titleLabel?.font)!)
        itemButton.frame = CGRect(x: 0, y: 0, width: max(44, size), height: 44)
        itemButton.addTarget(target, action: sel, for: .touchUpInside)
        itemButton.isExclusiveTouch = true
        
        return UIBarButtonItem(customView: itemButton)
    }
    
    func createBarButtonItem(image: UIImage, target: AnyObject, sel: Selector) -> UIBarButtonItem {
        let itemButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
        itemButton.frame = CGRect(x: 0, y: 0, width: max(44, image.size.width), height: 44)
        itemButton.setImage(image, for: .normal)
        itemButton.addTarget(target, action: sel, for: .touchUpInside)
        itemButton.isExclusiveTouch = true
        
        return UIBarButtonItem(customView: itemButton)
    }
    
    func addCustomTitle(title: String, color: UIColor = UIColor.white, font: UIFont = UIFont(name: "Nunito-Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)) {
        let titleLabel = PPaddingLabel(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: 44))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = color
        titleLabel.font = font
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.16
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.navigationItem.titleView = titleLabel
    }
    
    class func loadFromNib<T: UIViewController>() -> T {
         return T(nibName: String(describing: self), bundle: nil)
    }
    
}








