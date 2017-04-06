//
//  HolderView.swift
//  TimeTracker
//
//  Created by Frederic Forster on 06.04.17.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit

protocol HolderViewDelegate: class {
    func animateLabel()
}

class HolderView: UIView {

    var parentFrame: CGRect = CGRect.zero
    weak var delegate: AnimationViewController?

    let ovalLayer = OvalLayer()
    let triangleLayer = TriangleLayer()
    let whiteRectangleLayer = RectangleLayer()
    let greenRectangleLayer = RectangleLayer()
    let arcLayer = ArcLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Utils.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addOval() {
        triangleLayer.isHidden = true
        layer.addSublayer(triangleLayer)
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HolderView.wobbleOval), userInfo: nil, repeats: false)
    }

    func wobbleOval() {
        ovalLayer.wobble()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HolderView.drawAnimatedTriangle), userInfo: nil, repeats: false)
    }

    func drawAnimatedTriangle() {
        triangleLayer.isHidden = false
        triangleLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HolderView.spinAndTransform), userInfo: nil, repeats: false)
    }

    func spinAndTransform() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)

        let rotateAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = 0.45
        rotateAnimation.isRemovedOnCompletion = false
        layer.add(rotateAnimation, forKey: nil)

        ovalLayer.contract()
        Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(HolderView.drawWhiteAnimatedRectangle), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(HolderView.drawGreenAnimatedRectangle), userInfo: nil, repeats: false)
    }

    func drawWhiteAnimatedRectangle() {
        layer.addSublayer(whiteRectangleLayer)
        whiteRectangleLayer.animateStrokeWithColor(color: Utils.white)
    }

    func drawGreenAnimatedRectangle() {
        layer.addSublayer(greenRectangleLayer)
        greenRectangleLayer.animateStrokeWithColor(color: Utils.appdafuer)
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(drawArc), userInfo: nil, repeats: false)
    }

    func drawArc() {
        layer.addSublayer(arcLayer)
        arcLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(expandView), userInfo: nil, repeats: false)
    }

    func expandView() {
        backgroundColor = Utils.appdafuer

        frame = CGRect(x: frame.origin.x - greenRectangleLayer.lineWidth,
                       y: frame.origin.y - greenRectangleLayer.lineWidth,
                       width: frame.size.width + greenRectangleLayer.lineWidth * 2,
                       height: frame.size.height + greenRectangleLayer.lineWidth * 2)
        layer.sublayers = nil

        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.frame = self.parentFrame
        }) { _ in
            self.addLabel()
        }
    }

    func addLabel() {
       delegate?.animateLabel()
    }
}
