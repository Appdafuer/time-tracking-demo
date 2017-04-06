//
//  UIView+Extensions.swift
//  TimeTracker
//
//  Created by Frederic Forster on 05/04/2017.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit

extension UIView {
    func addViewFullscreen(_ view: UIView) {

        view.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(view)

        let views: [String:Any] = ["view": view]

        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
}
