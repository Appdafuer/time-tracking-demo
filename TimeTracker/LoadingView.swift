//
//  LoadingView.swift
//  TimeTracker
//
//  Created by Frederic Forster on 05/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {

    var loginIndicatorFrame = UIView()
    var lblLogin = UILabel()
    private let animationSizeKey = 75

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.layer.cornerRadius = 10

        setLabel()
        setFrame()
        setConstraints()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        let views = ["myView": self, "loadingIndicator": loginIndicatorFrame, "lblLogin": lblLogin]
        var allConstraints = [
            NSLayoutConstraint(item: loginIndicatorFrame, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loginIndicatorFrame, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loginIndicatorFrame, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                               constant: CGFloat(animationSizeKey)),
            NSLayoutConstraint(item: loginIndicatorFrame, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: CGFloat(animationSizeKey)),
            NSLayoutConstraint(item: lblLogin, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -10)
        ]
        let loginLabelBorderConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|-10-[lblLogin]-10-|", options: [], metrics: nil, views: views)
        allConstraints += loginLabelBorderConstraints
        NSLayoutConstraint.activate(allConstraints)
    }

    func setLabel() {
        lblLogin.translatesAutoresizingMaskIntoConstraints = false
        lblLogin.textColor = UIColor.white
        lblLogin.textAlignment = NSTextAlignment.center
        lblLogin.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        lblLogin.text = "Loading..."
        self.addSubview(lblLogin)
    }

    func setFrame() {
        loginIndicatorFrame.translatesAutoresizingMaskIntoConstraints = false
        let animation = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .pacman, color: .white, padding: 0)
        animation.startAnimating()
        animation.isUserInteractionEnabled = false
        loginIndicatorFrame.addSubview(animation)
        self.addSubview(loginIndicatorFrame)
    }

}
