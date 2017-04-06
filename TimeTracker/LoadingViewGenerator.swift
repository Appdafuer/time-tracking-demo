//
//  LoadingViewGenerator.swift
//  TimeTracker
//
//  Created by Frederic Forster on 05/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewGenerator {

    static func setView() {
        let transparentLoadingView = UIView()

        transparentLoadingView.backgroundColor = UIColor(white: 1, alpha: 0)
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        transparentLoadingView.addSubview(loadingView)
        let constraints = [
            NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: transparentLoadingView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: transparentLoadingView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200),
            NSLayoutConstraint(item: loadingView, attribute: NSLayoutAttribute.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
        ]
        NSLayoutConstraint.activate(constraints)

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.addViewFullscreen(transparentLoadingView)
    }

    static func dismissView() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let subviews = appDelegate?.window?.subviews else {return}
        for subview in subviews {
            let subSubViews = subview.subviews
            for subSubView in subSubViews where subSubView is LoadingView {
                subview.removeFromSuperview()
            }
        }
    }

}
