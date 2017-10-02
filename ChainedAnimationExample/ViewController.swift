//
//  ViewController.swift
//  ChainedAnimation
//
//  Created by Silvan Dähn on 06/21/2015.
//  Copyright (c) 06/21/2015 Silvan Dähn. All rights reserved.
//


import UIKit
import ChainedAnimation


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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let delay = DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delay) {
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
        phone.frame = view.bounds.insetBy(dx: 60, dy: 60)
        phone.outline(cornerRadius: 40)
        phone.y = view.height

        displayImageView.frame = phone.bounds.insetBy(dx: 10, dy: 60)
        displayImageView.outline()
        displayImageView.backgroundColor = .groupTableViewBackground
        phone.addSubview(displayImageView)
        view.addSubview(phone)
    }

    func layoutSections() {
        let sectionPadding: CGFloat = 15.0
        let sectionHeight = (displayImageView.height  - sectionPadding * 5) / 4.0
        let sectionFrame = displayImageView.bounds.insetBy(dx: sectionPadding, dy: displayImageView.height / 2.5)
        var currentY = sectionPadding

        for view in [firstSection, secondSection, thirdSection, fourthSection] {
            view.frame = sectionFrame
            view.y = currentY + sectionOffset
            view.backgroundColor = .white
            currentY += sectionHeight + sectionPadding
            view.alpha = 0
            displayImageView.addSubview(view)
        }
    }

    func layoutSubheader() {
        subheader.text = "This is an example application."
        subheader.font = UIFont(name: "Avenir Next", size: 18)
        subheader.textColor = .black
        subheader.sizeToFit()
        subheader.center = view.center
        subheader.y = 0
        subheader.alpha = 0
        view.addSubview(subheader)
    }

    func layoutHeadline() {
        headline.text = "Welcome!"
        headline.font = UIFont(name: "AvenirNext-UltraLight", size: 42)
        headline.textColor = .black
        headline.sizeToFit()
        headline.center = view.center
        headline.y = 0
        headline.alpha = 0
        view.addSubview(headline)
    }

    // MARK: - Animation

    func startAnimation() {
        let moveAndFadeIn: (UIView) -> Void = { section in
            section.alpha = 1
            section.y -= self.sectionOffset
        }

        let moveAndFadeOut: (UIView) -> Void = { view in
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }

        UIView.beginAnimationChain(0.8, options: .curveEaseInOut) {
            self.phone.y = 170
            }.thenAfterStart(0.1) {
                self.subheader.y = 105
                moveAndFadeIn(self.firstSection)
            }.thenAfterStart(0.15) {
                moveAndFadeIn(self.secondSection)
                self.subheader.alpha = 1
                self.headline.y = 45
            }.thenAfterStart(0.1) {
                moveAndFadeIn(self.thirdSection)
                self.headline.alpha = 1
            }.thenAfterStart(0.1) {
                moveAndFadeIn(self.fourthSection)
            }.completion { _ in
                print("First completion")
            }.chainAfterCompletion(1.2, delay: 0.5, options: .curveEaseIn) {
                moveAndFadeOut(self.displayImageView)
                moveAndFadeOut(self.phone)
            }.thenAfterStart(0.2) {
                moveAndFadeOut(self.headline)
            }.thenAfterStart(0.1) {
                moveAndFadeOut(self.subheader)
            }.completion { _ in
                print("Second completion")
            }.animate()
    }
}
