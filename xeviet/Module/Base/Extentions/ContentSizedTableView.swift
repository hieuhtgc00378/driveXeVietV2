//
//  ContentSizedTableView.swift
//  bosty-ios
//
//  Created by quanarmy on 3/12/20.
//  Copyright © 2020 Paditech, Inc. All rights reserved.
//

import UIKit

final class ContentSizedTableView: UITableView {
    override var contentSize:CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
