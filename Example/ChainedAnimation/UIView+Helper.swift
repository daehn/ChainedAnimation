//
//  UIView+Helper.swift
//  chain-animate
//
//  Created by Silvan Dähn on 17.06.15.
//  Copyright (c) 2015 Silvan Dähn. All rights reserved.
//

import UIKit

extension UIView {
    func outline(color: UIColor = .blackColor(), borderWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        backgroundColor = .clearColor()
        layer.borderColor = color.CGColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }
}

extension UIView {
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set (value) {
            self.frame.origin.y = value
        }
    }

    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set (value) {
            self.frame.origin.x = value
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set (value) {
            self.frame.size.width = value
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (value) {
            self.frame.size.height = value
        }
    }
}