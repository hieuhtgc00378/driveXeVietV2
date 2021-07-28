//
//  ArrayExtension.swift
//  DocEye
//
//  Created by Mac Mini on 4/10/19.
//  Copyright © 2019 Mac Mini. All rights reserved.
//

import UIKit

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
