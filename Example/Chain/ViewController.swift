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
    convenience init(outlinedFrame: CGRect) {
        self.init(frame: outlinedFrame)
        backgroundColor = .clearColor()
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 1
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.startAnimation()
        }
    }

    override func viewDidLayoutSubviews() {
        let outline: UIView -> () = { view in
            view.backgroundColor = .clearColor()
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.layer.borderWidth = 1
        }

        phone.frame = CGRectInset(view.bounds, 60, 60)
        outline(phone)
        phone.layer.cornerRadius = 40
        phone.y = 700

        displayImageView.frame = CGRectInset(phone.bounds, 10, 60)
        displayImageView.image = UIImage(named: "screen")
        outline(displayImageView)
        displayImageView.backgroundColor = .groupTableViewBackgroundColor()
        phone.addSubview(displayImageView)
        view.addSubview(phone)

        let sectionPadding: CGFloat = 15.0
        let sectionHeight = ((displayImageView.height  - sectionPadding * 5) / 4.0)
        var currentY = sectionPadding

        for view in [firstSection, secondSection, thirdSection, fourthSection] {
            view.frame = CGRectInset(displayImageView.bounds, sectionPadding, displayImageView.height / 2.5)
            view.y = currentY + sectionOffset
            view.backgroundColor = .whiteColor()
            currentY += sectionHeight + sectionPadding
            view.alpha = 0
            displayImageView.addSubview(view)
        }

        subheader.text = "This is an awesome application."
        subheader.font = UIFont(name: "Avenir Next", size: 18)
        subheader.textColor = .blackColor()
        subheader.sizeToFit()
        subheader.center = view.center
        subheader.y = 0
        subheader.alpha = 0
        view.addSubview(subheader)

        headline.text = "Welcome!"
        headline.font = UIFont(name: "AvenirNext-UltraLight", size: 42)
        headline.textColor = .blackColor()
        headline.sizeToFit()
        headline.center = view.center
        headline.y = 0
        headline.alpha = 0
        view.addSubview(headline)
        super.viewDidLayoutSubviews()
    }

    // MARK: - Animation

    func startAnimation() {
        UIView.beginAnimationChain(0.5, options: .CurveEaseInOut) {
            self.phone.y = 170
            }.thenAfter(0.1) {
                self.subheader.y = 105
                self.firstSection.alpha = 1
                self.firstSection.y -= self.sectionOffset
            }.thenAfter(0.15) {
                self.secondSection.alpha = 1
                self.secondSection.y -= self.sectionOffset
                self.subheader.alpha = 1
                self.headline.y = 45
            }.thenAfter(0.1) {
                self.thirdSection.alpha = 1
                self.thirdSection.y -= self.sectionOffset
                self.headline.alpha = 1
            }.thenAfter(0.05) {
                self.fourthSection.alpha = 1
                self.fourthSection.y -= self.sectionOffset
            }.completion { _ in
                // Do something on completion
            }.animate()
    }
}


