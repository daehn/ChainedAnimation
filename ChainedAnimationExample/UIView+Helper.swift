//
//  UIView+Helper.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 10/09/2016.
//  Copyright © 2016 Silvan Dähn. All rights reserved.
//


import UIKit


extension UIView {

    func outline(_ color: UIColor = .black, borderWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        backgroundColor = .clear
        layer.borderColor = color.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
    }

}


extension UIView {

    var y: CGFloat {
        get { return frame.origin.y }
        set(value) { frame.origin.y = value }
    }

    var x: CGFloat {
        get { return frame.origin.x }
        set(value) { frame.origin.x = value }
    }

    var width: CGFloat {
        get { return frame.width }
        set(value) { frame.size.width = value }
    }

    var height: CGFloat {
        get { return frame.height }
        set(value) { frame.size.height = value }
    }

}
