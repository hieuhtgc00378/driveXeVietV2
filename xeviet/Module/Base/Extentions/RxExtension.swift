//
//  RxExtension.swift
//  Supership
//
//  Created by Mac on 8/10/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

// Button
extension Reactive where Base : UIButton {
    public var backgroundColor : Binder<UIColor> {
        return Binder(self.base) { button, backgroundColor in
            button.backgroundColor = backgroundColor
        }
    }
}

extension Reactive where Base: UIButton {
    public var onOffState: Binder<(UIColor, Bool)> {
        return Binder(self.base) { button, state in
            button.backgroundColor = state.0
            button.isEnabled =  state.1
        }
    }
}

public extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func insert(_ subElement: Element.Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(subElement, at: index)
        accept(newValue)
    }
    
    func insert(contentsOf newSubelements: Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(contentsOf: newSubelements, at: index)
        accept(newValue)
    }
    
    func remove(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
}









