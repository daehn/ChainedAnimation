//
//  ViewController.swift
//  Chain
//
//  Created by Silvan Dähn on 06/20/2015.
//  Copyright (c) 06/20/2015 Silvan Dähn. All rights reserved.
//

import UIKit
import Chain

extension UIView {
    func outline(color: UIColor = .blackColor(), borderWidth: CGFloat = 1) {
        backgroundColor = .clearColor()
        layer.borderColor = color.CGColor
        layer.borderWidth = borderWidth
    }
}

class ViewController: UIViewController {

    var displayImageView = UIImageView()
    var phone = UIView()
    var subheader = UILabel()
    var headline = UILabel()
    var firstSection = UIView()
    var secondSection = UIView()
    var thirdSection = UIView()
    var fourthSection = UIView()
    let sectionOffset: CGFloat = 40

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.startAnimation()
        }
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        layoutPhoneAndDisplay()
        layoutSections()
        layoutSubheader()
        layoutHeadline()
        super.viewDidLayoutSubviews()
    }

    func layoutPhoneAndDisplay() {
        phone.frame = CGRectInset(view.bounds, 60, 60)
        phone.outline()
        phone.layer.cornerRadius = 40
        phone.y = 700

        displayImageView.frame = CGRectInset(phone.bounds, 10, 60)
        displayImageView.image = UIImage(named: "screen")
        displayImageView.outline()
        displayImageView.backgroundColor = .groupTableViewBackgroundColor()
        phone.addSubview(displayImageView)
        view.addSubview(phone)
    }

    func layoutSections() {
        let sectionPadding: CGFloat = 15.0
        let sectionHeight = ((displayImageView.height  - sectionPadding * 5) / 4.0)
        var currentY = sectionPadding

        for view in [firstSection, secondSection, thirdSection, fourthSection] {
            view.frame = CGRectInset(displayImageView.bounds, sectionPadding, displayImageView.height / 2.5)
            view.y = currentY + sectionOffset
            view.backgroundColor = .whiteColor()
            currentY += sectionHeight + sectionPadding
            view.alpha = 0
            view.transform = CGAffineTransformMakeScale(0.8, 0.8)
            displayImageView.addSubview(view)
        }
    }

    func layoutSubheader() {
        subheader.text = "This is an awesome application."
        subheader.font = UIFont(name: "Avenir Next", size: 18)
        subheader.textColor = .blackColor()
        subheader.sizeToFit()
        subheader.center = view.center
        subheader.y = 0
        subheader.alpha = 0
        view.addSubview(subheader)
    }

    func layoutHeadline() {
        headline.text = "Welcome!"
        headline.font = UIFont(name: "AvenirNext-UltraLight", size: 42)
        headline.textColor = .blackColor()
        headline.sizeToFit()
        headline.center = view.center
        headline.y = 0
        headline.alpha = 0
        view.addSubview(headline)
    }

    // MARK: - Animation

    func startAnimation() {
        UIView.beginAnimationChain(0.6, options: .CurveEaseInOut) {
            self.phone.y = 170
            }.thenAfter(0.1) {
                self.subheader.y = 105
                self.firstSection.alpha = 1
                self.firstSection.y -= self.sectionOffset
                self.firstSection.transform = CGAffineTransformIdentity
            }.thenAfter(0.15) {
                self.secondSection.alpha = 1
                self.secondSection.y -= self.sectionOffset
                self.secondSection.transform = CGAffineTransformIdentity
                self.subheader.alpha = 1
                self.headline.y = 45
            }.thenAfter(0.1) {
                self.thirdSection.alpha = 1
                self.thirdSection.y -= self.sectionOffset
                self.thirdSection.transform = CGAffineTransformIdentity
                self.headline.alpha = 1
            }.thenAfter(0.1) {
                self.fourthSection.alpha = 1
                self.fourthSection.y -= self.sectionOffset
                self.fourthSection.transform = CGAffineTransformIdentity
            }.completion { _ in
                // Do something on completion
            }.animate()
    }
}
