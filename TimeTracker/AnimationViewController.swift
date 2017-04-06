//
//  AnimationViewController.swift
//  TimeTracker
//
//  Created by Frederic Forster on 06.04.17.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {

    var holderView = HolderView(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
    }

    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = CGRect(x: view.bounds.width / 2 - boxSize / 2,
                                  y: view.bounds.height / 2 - boxSize / 2,
                                  width: boxSize,
                                  height: boxSize)
        holderView.parentFrame = view.frame
        holderView.delegate = self
        view.addSubview(holderView)
        holderView.addOval()
    }

    func animateLabel() {
        holderView.removeFromSuperview()
        view.backgroundColor = Utils.appdafuer

        let label: UILabel = UILabel(frame: view.frame)
        label.textColor = Utils.white
        let font = UIFont(name: "HelveticaNeue-Thin", size: 200.0)
        label.font = font
        label.textAlignment = NSTextAlignment.center
        label.text = "C"
        label.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        view.addSubview(label)

        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            label.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // swiftlint:disable:next force_cast
            let profileNC = storyboard.instantiateViewController(withIdentifier: "StartNavigationController") as! UINavigationController
            // swiftlint:disable:next force_cast            
            self.present(profileNC, animated: true, completion: nil)
        }
    }
}
