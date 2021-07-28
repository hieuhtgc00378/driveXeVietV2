//
//  UIViewExtension.swift
//  Supership
//
//  Created by Mac on 8/8/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import SnapKit
import UIKit

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last! as String
    }
    
    // reuseidentifier for obtaining the cell
    class var identifier: String {
        return String(format: "%@_identifier", self.nameOfClass)
    }
}

extension UIView {
    /**
     Cell is used to acquire the object of Xib for registerNib
     */
    class func NibObject() -> UINib {
        let hasNib: Bool = Bundle.main.path(forResource: self.nameOfClass, ofType: "nib") != nil
        guard hasNib else {
            assert(!hasNib, "Invalid parameter") // assert
            return UINib()
        }
        return UINib(nibName: self.nameOfClass, bundle: nil)
    }
    
    class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil) -> T {
        let v: T? = self.fromNib(nibNameOrNil)
        return v!
    }
    
    class func fromNib<T: UIView>(_ nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = "\(T.self)".components(separatedBy: ".").last!
        }
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
    
    var width: CGFloat {
        get { return self.frame.size.width }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var height: CGFloat {
        get { return self.frame.size.height }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var size: CGSize {
        get { return self.frame.size }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var origin: CGPoint {
        get { return self.frame.origin }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var x: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var centerX: CGFloat {
        get { return self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var centerY: CGFloat {
        get { return self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var top: CGFloat {
        get { return self.frame.origin.y }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var bottom: CGFloat {
        get { return frame.origin.y + frame.size.height }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var right: CGFloat {
        get { return self.frame.origin.x + self.frame.size.width }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    var left: CGFloat {
        get { return self.frame.origin.x }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    func addDashedBorder(_ strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [5, 5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
    func fadeIn(duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                completion: @escaping ((Bool) -> Void) = { (_: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                           self.isHidden = false
                           self.alpha = 1.0
      }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: @escaping (Bool) -> Void = { (_: Bool) -> Void in }) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                           self.alpha = 0.0
                           self.isHidden = true
      }, completion: completion)
    }
    
    func blurView(style: UIBlurEffect.Style) {
        var blurEffectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        addSubview(blurEffectView)
    }
    
    func removeBlur() {
        for view in self.subviews {
            if let view = view as? UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }
}

private extension UIView {
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
//    func setView(view: UIView, hidden: Bool) {
//        UIView.self.transition(with: view, duration: 0.4, options: .transitionCrossDissolve, animations: {
//            isHidden = hidden
//        })
//    }
}

// MARK: - IndicatorView & NoResultView

public let kTagIndicatorView = 9999
public let kTagLabel = 10000

public let kTagNoResultImage = 99999
public let kTagNoResultTitle = 100000

extension UIView {
    func addGradientWithColor(color: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.locations = [0.05 as NSNumber, 0.95 as NSNumber]
        gradient.colors = [UIColor.clear.cgColor, color.cgColor]
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func showIndicatorView(isShow: Bool = true, style: UIActivityIndicatorView.Style = .gray, title: String = "", yPosition: CGFloat = 0) {
        if isShow {
            let activityIndicatorView = UIActivityIndicatorView(style: style)
            activityIndicatorView.center = self.center
            activityIndicatorView.tag = kTagIndicatorView
            activityIndicatorView.startAnimating()
            self.addSubview(activityIndicatorView)
            self.bringSubviewToFront(activityIndicatorView)
            activityIndicatorView.snp.makeConstraints { [weak self] make in
                guard let `self` = self else { return }
                make.center.equalTo(self.snp.center).priority(750)
                make.centerY.equalTo(self.snp.centerY).offset(yPosition)
            }
            
            if title.count > 0 {
                let font = UIFont.systemFont(ofSize: 14)
                let height = title.stringHeightWithMaxWidth(self.width, font: font)
                let label = UILabel(frame: CGRect(x: 15, y: yPosition, width: UIScreen.main.bounds.size.width - 30, height: height + 10))
                label.tag = kTagLabel
                label.backgroundColor = UIColor.clear
                label.textColor = UIColor.colorFromHexString(hex: "#b5b5b5")
                label.text = title
                label.font = font
                label.numberOfLines = 0
                label.textAlignment = .center
                self.addSubview(label)
                label.snp.makeConstraints { [weak self] make in
                    guard let `self` = self else { return }
                    make.height.equalTo(height + 10).priority(1000)
                    make.left.equalTo(self).offset(15.0)
                    make.centerX.equalTo(self.snp.centerX)
                    make.top.equalTo(self).offset(yPosition)
                }
                activityIndicatorView.snp.makeConstraints { make in
                    make.centerY.equalTo(yPosition + height + 30).priority(1000)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 60) { [weak self] in
                self?.removeIndicatorView()
            }
        } else {
            self.removeIndicatorView()
        }
    }
    
    func removeIndicatorView() {
        self.subviews.forEach {
            $0.viewWithTag(kTagIndicatorView)?.removeFromSuperview()
            $0.viewWithTag(kTagLabel)?.removeFromSuperview()
        }
    }
    
//    func showNoResultView(isShow: Bool = true, title: String? = nil, image: UIImage? = nil, yPosition: CGFloat = 20) {
//        if title == nil, image == nil {
//            return
//        }
//
//        if isShow {
//            var existImage = false
//            if let image = image {
//                existImage = true
//                let imageView = UIImageView(image: image)
//                imageView.contentMode = .scaleAspectFit
//                imageView.tag = kTagNoResultImage
//                self.addSubview(imageView)
//                imageView.snp.makeConstraints { [weak self] make in
//                    guard let `self` = self else { return }
//                    make.centerX.equalTo(self.snp.centerX)
//                    make.top.equalTo(self.snp.top).offset(yPosition)
//                }
//            }
//            if let title = title {
//                let height = title.stringHeightWithMaxWidth(self.width - 40, font: PDefined.fontRegular(size: 14))
//                let titleLabel = UILabel(frame: CGRect(x: 20, y: 30, width: self.width - 40, height: height + 10))
//                titleLabel.text = title
//                titleLabel.tag = kTagNoResultTitle
//                titleLabel.numberOfLines = 0
//                titleLabel.textAlignment = .center
//                titleLabel.textColor = UIColor.colorFromHexString(hex: "6F7179")
//                titleLabel.font = PDefined.fontRegular(size: 14)
//                // titleLabel.backgroundColor = UIColor.yellow
//                self.addSubview(titleLabel)
//                titleLabel.snp.makeConstraints { [weak self] make in
//                    guard let `self` = self else { return }
//                    make.left.equalTo(self.snp.left).offset(20)
//                    make.centerX.equalTo(self.snp.centerX)
//                    if existImage {
//                        for subView in self.subviews {
//                            if let imageView = subView.viewWithTag(kTagNoResultImage) as? UIImageView {
//                                make.top.equalTo(imageView.snp.bottom).offset(10)
//                                break
//                            }
//                        }
//                    } else {
//                        make.top.equalTo(self.snp.top).offset(yPosition)
//                    }
//                }
//            }
//        } else {
//            self.removeNoResultView()
//        }
//    }
    
    func removeNoResultView() {
        self.subviews.forEach {
            $0.viewWithTag(kTagNoResultImage)?.removeFromSuperview()
            $0.viewWithTag(kTagNoResultTitle)?.removeFromSuperview()
        }
    }
}

extension UIView {
    internal func makeCorner(radius: CGFloat, borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
        self.layer.masksToBounds = radius > 0
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    internal func makeRound(borderWidth: CGFloat = 0.0, borderColor: UIColor? = nil) {
        self.makeCorner(radius: 0.5 * self.frame.height, borderWidth: borderWidth, borderColor: borderColor)
    }
    
    func imageSnap() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIView {
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1.5)
        layer.shadowRadius = 2
        
        //        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow2(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 2
        
        //        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        //        layer.shouldRasterize = true
        //        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

// MARK: - Animate view

extension UIView {
    func pulsate(scaleX: CGFloat = 0.8, scaleY: CGFloat = 0.8) {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }
    
    func flash() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 3
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.05
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: "position")
    }
    
    func rotate(angle: CGFloat?) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseInOut], animations: {
            if let angle = angle {
                self.transform = CGAffineTransform(rotationAngle: angle)
            } else {
                self.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
}

// MARK: - PGradientView

@IBDesignable
class PGradientView: PView {
    @IBInspectable var startColor: UIColor = .black { didSet { self.updateColors() } }
    @IBInspectable var endColor: UIColor = .white { didSet { self.updateColors() } }
    @IBInspectable var startLocation: Double = 0.05 { didSet { updateLocations() } }
    @IBInspectable var endLocation: Double = 0.95 { didSet { updateLocations() } }
    @IBInspectable var horizontalMode: Bool = false { didSet { self.updatePoints() } }
    @IBInspectable var diagonalMode: Bool = false { didSet { updatePoints() } }
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if self.horizontalMode {
            self.gradientLayer.startPoint = self.diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            self.gradientLayer.endPoint = self.diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            self.gradientLayer.startPoint = self.diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            self.gradientLayer.endPoint = self.diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }
    
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updatePoints()
        self.updateLocations()
        self.updateColors()
    }
}

extension UITableView {
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection: self.numberOfSections - 1) - 1, section: self.numberOfSections - 1)
            print(indexPath)
            if (indexPath.row < 0 || indexPath.row < 0) { return }
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
