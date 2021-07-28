//
//  BehaviorRelayExtension.swift
//  ccn
//
//  Created by Phong Nguyen on 12/9/19.
//  Copyright © 2019 Paditech, Inc. All rights reserved.
//

import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func acceptAppending(_ elements: [Element.Element]) {
        accept(value + elements)
    }
    
    public func insert(_ subElement: Element.Element, at index: Element.Index? = nil) {
        var newValue = value
        if let index = index {
            newValue.insert(subElement, at: index)
        } else {
            newValue.append(subElement)
        }
        accept(newValue)
    }

    public func insert(contentsOf newSubelements: Element, at index: Element.Index? = nil) {
        var newValue = value
        if let index = index {
            newValue.insert(contentsOf: newSubelements, at: index)
        } else {
            newValue.append(contentsOf: newSubelements)
        }
        accept(newValue)
    }

    public func removeIndex(at index: Element.Index) {
        var newValue = value
        newValue.remove(at: index)
        accept(newValue)
    }
    
    public func removeLast() {
        var newValue = value
        
        let lastIndex = newValue.count - 1
        if lastIndex >= 0 {
            newValue.removeFirst(lastIndex)
        }
        accept(newValue)
    }
    
}
