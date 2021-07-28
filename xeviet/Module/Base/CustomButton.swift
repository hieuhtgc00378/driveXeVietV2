

import UIKit

@IBDesignable

class FButton: UIButton {

    let bottomLineHeight: CGFloat = 1.0
    var bottomLine: CALayer?
    var imageArrowLeft: UIImageView?
    var imageArrowRight: UIImageView?
    var imageArrowDown: UIImageView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateButtomLineLayout()
        
        if self.cornerCircle {
            layer.cornerRadius = self.frame.height * 0.5
        }
        
        if self.arrowLeft {
            if let image = self.imageArrowLeft {
                image.center = CGPoint(x: 15, y: self.frame.height * 0.5)
            }
        }
        
        if self.arrowRight {
            if let image = self.imageArrowRight {
                image.center = CGPoint(x: self.frame.width - 15, y: self.frame.height * 0.5)
            }
        }
        
        if self.arrowDown {
            if let image = self.imageArrowDown {
                image.center = CGPoint(x: self.frame.width - 15, y: self.frame.height * 0.5)
            }
        }
    }

    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = self.frame.height * 0.5
            layer.masksToBounds = cornerCircle
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomLine == nil) {
                self.bottomLine = CALayer()
//                self.bottomLine?.borderColor = DQDefined.lightBlueColor().cgColor
                self.bottomLine?.borderWidth = bottomLineHeight
                self.layer.addSublayer(self.bottomLine!)
            }
            
            self.updateButtomLineLayout()
        }
    }
    
    func updateButtomLineLayout() {
        if let line = self.bottomLine {
            let lineHeight = bottomLineHeight
            line.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight)
        }
    }
    
    @IBInspectable var arrowLeft: Bool = false {
        didSet {
            if (self.imageArrowLeft == nil) {
                self.imageArrowLeft = UIImageView(image: UIImage(named: "arrow-small-white-left"))
            }
            self.addSubview(self.imageArrowLeft!)
        }
    }
    
    @IBInspectable var arrowRight: Bool = false {
        didSet {
            if (self.imageArrowRight == nil) {
                self.imageArrowRight = UIImageView(image: UIImage(named: "arrow-small-white-right"))
            }
            self.addSubview(self.imageArrowRight!)
        }
    }
    
    @IBInspectable var arrowDown: Bool = false {
        didSet {
            if (self.imageArrowDown == nil) {
                self.imageArrowDown = UIImageView(image: UIImage(named: "arrow_down"))
            }
            self.addSubview(self.imageArrowDown!)
        }
    }
}



extension UIButton {
    
    typealias UIButtonTargetClosure = (UIButton) -> ()
    
    class ClosureWrapper: NSObject {
        let closure: UIButtonTargetClosure
        init(_ closure: @escaping UIButtonTargetClosure) {
            self.closure = closure
        }
    }
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: UIButtonTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping UIButtonTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }

}
