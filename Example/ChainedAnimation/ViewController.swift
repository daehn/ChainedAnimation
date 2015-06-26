//
//  ViewController.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 06/21/2015.
//  Copyright (c) 06/21/2015 Silvan Dähn. All rights reserved.
//

import UIKit
import ChainedAnimation

extension UIView {
    func outline(color: UIColor = .blackColor(), borderWidth: CGFloat = 1, cornerRadius: CGFloat = 0) {
        backgroundColor = .clearColor()
        layer.borderColor = color.CGColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
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
        phone.outline(cornerRadius: 40)
        phone.y = view.height

        displayImageView.frame = CGRectInset(phone.bounds, 10, 60)
        displayImageView.image = UIImage(named: "screen")
        displayImageView.outline()
        displayImageView.backgroundColor = .groupTableViewBackgroundColor()
        phone.addSubview(displayImageView)
        view.addSubview(phone)
    }

    func layoutSections() {
        let sectionPadding: CGFloat = 15.0
        let sectionHeight = (displayImageView.height  - sectionPadding * 5) / 4.0
        let sectionFrame = CGRectInset(displayImageView.bounds, sectionPadding, displayImageView.height / 2.5)
        var currentY = sectionPadding

        for view in [firstSection, secondSection, thirdSection, fourthSection] {
            view.frame = sectionFrame
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
        subheader.transform = CGAffineTransformIdentity
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
        headline.transform = CGAffineTransformIdentity
        view.addSubview(headline)
    }

    // MARK: - Animation

    func startAnimation() {
        let moveAndScaleSection: UIView -> () = { section in
            section.alpha = 1
            section.y -= self.sectionOffset
            section.transform = CGAffineTransformIdentity
        }

        let translation = CGAffineTransformMakeTranslation(-200, -450)
        let rotation = CGAffineTransformMakeRotation(CGFloat(M_PI_4 * -1))
        let transform = CGAffineTransformConcat(translation, rotation)

        UIView.beginAnimationChain(0.8, options: .CurveEaseInOut) {
                self.phone.y = 170
            }.thenAfterStart(0.1) {
                self.subheader.y = 105
                moveAndScaleSection(self.firstSection)
            }.thenAfterStart(0.15) {
                moveAndScaleSection(self.secondSection)
                self.subheader.alpha = 1
                self.headline.y = 45
            }.thenAfterStart(0.1) {
                moveAndScaleSection(self.thirdSection)
                self.headline.alpha = 1
            }.thenAfterStart(0.1) {
                moveAndScaleSection(self.fourthSection)
            }.completion { _ in
                println("First completion")
            }.chainAfterCompletion(1.2, options: .CurveEaseIn) {
                self.displayImageView.alpha = 0
            }.thenAfterStart(0.2) {
                self.headline.alpha = 0
                self.headline.transform = transform
            }.thenAfterStart(0.1) {
                self.subheader.alpha = 0
                self.subheader.transform = transform
            }.thenAfterStart(0.2) {
                self.phone.alpha = 0
                self.phone.transform = transform
            }.completion { _ in
                println("Second completion")
            }.animate()
    }
}


