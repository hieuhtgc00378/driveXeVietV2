//
//  DictionaryExtension.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import UIKit

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
