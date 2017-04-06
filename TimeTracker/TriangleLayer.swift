//
//  TriangleLayer.swift
//  TimeTracker
//
//  Created by Frederic Forster on 06.04.17.
//  Copyright © 2017 Appdafuer. All rights reserved.
//

import UIKit

class TriangleLayer: CAShapeLayer {

    let innerPadding: CGFloat = 30.0

    override init() {
        super.init()
        fillColor = Utils.appdafuer.cgColor
        strokeColor = Utils.white.cgColor
        lineWidth = 7.0
        lineCap = kCALineCapRound
        lineJoin = kCALineJoinRound
        path = trianglePathSmall.cgPath
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var trianglePathSmall: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 50.0 + innerPadding, y: 95.0))
        trianglePath.addLine(to: CGPoint(x: 50.0, y: 12.5 + innerPadding))
        trianglePath.addLine(to: CGPoint(x: 95.0 - innerPadding, y: 95.0))
        trianglePath.close()
        return trianglePath
    }

    var trianglePathLeftExtension: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 5.0, y: 95.0))
        trianglePath.addLine(to: CGPoint(x: 50.0, y: 12.5 + innerPadding))
        trianglePath.addLine(to: CGPoint(x: 95.0 - innerPadding, y: 95.0))
        trianglePath.close()
        return trianglePath
    }

    var trianglePathRightExtension: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 5.0, y: 95.0))
        trianglePath.addLine(to: CGPoint(x: 50.0, y: 12.5 + innerPadding))
        trianglePath.addLine(to: CGPoint(x: 95.0, y: 95.0))
        trianglePath.close()
        return trianglePath
    }

    var trianglePathTopExtension: UIBezierPath {
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 5.0, y: 95.0))
        trianglePath.addLine(to: CGPoint(x: 50.0, y: 12.5))
        trianglePath.addLine(to: CGPoint(x: 95.0, y: 95.0))
        trianglePath.close()
        return trianglePath
    }

    func animate() {
        let triangleAnimation1: CABasicAnimation = CABasicAnimation(keyPath: "path")
        triangleAnimation1.fromValue = trianglePathSmall.cgPath
        triangleAnimation1.toValue = trianglePathLeftExtension.cgPath
        triangleAnimation1.beginTime = 0.0
        triangleAnimation1.duration = 0.3

        let triangleAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "path")
        triangleAnimation2.fromValue = trianglePathLeftExtension.cgPath
        triangleAnimation2.toValue = trianglePathRightExtension.cgPath
        triangleAnimation2.beginTime = triangleAnimation1.beginTime + triangleAnimation1.duration
        triangleAnimation2.duration = 0.25

        let triangleAnimation3: CABasicAnimation = CABasicAnimation(keyPath: "path")
        triangleAnimation3.fromValue = trianglePathRightExtension.cgPath
        triangleAnimation3.toValue = trianglePathTopExtension.cgPath
        triangleAnimation3.beginTime = triangleAnimation2.beginTime + triangleAnimation2.duration
        triangleAnimation3.duration = 0.2

        let triangleAnimationGroup: CAAnimationGroup = CAAnimationGroup()
        triangleAnimationGroup.animations = [triangleAnimation1, triangleAnimation2, triangleAnimation3]
        triangleAnimationGroup.duration = triangleAnimation3.beginTime + triangleAnimation3.duration
        triangleAnimationGroup.fillMode = kCAFillModeForwards
        triangleAnimationGroup.isRemovedOnCompletion = false
        add(triangleAnimationGroup, forKey: nil)
        }

}
