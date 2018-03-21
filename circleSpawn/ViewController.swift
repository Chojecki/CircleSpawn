//
//  ViewController.swift
//  circleSpawn
//
//  Created by Marek Chojecki on 20.03.2018.
//  Copyright © 2018 Marek Chojecki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var orginalCircleCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        let size: CGFloat = 100
        let spawnedView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
        spawnedView.center = tap.location(in: view)
        spawnedView.backgroundColor = UIColor.randomBrightColor()
        spawnedView.layer.cornerRadius = size * 0.5
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        spawnedView.addGestureRecognizer(longPress)
        
        let triTaps = UITapGestureRecognizer(target: self, action: #selector(handleTriTap(_:)))
        triTaps.numberOfTapsRequired = 3
        spawnedView.addGestureRecognizer(triTaps)
        
        view.addSubview(spawnedView)
    }
    
    var longPressAnimation: UIViewPropertyAnimator?
    
    private func longPressAnimation(with gesture: UILongPressGestureRecognizer) {
        
        guard let pressedView = gesture.view else { return }
        let location = gesture.location(in: self.view)
        
        switch gesture.state {
        case .began:
            orginalCircleCenter = pressedView.center
            pressedView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            pressedView.alpha = 0.5
        case .changed:
            pressedView.center = location
        case .ended:
            pressedView.transform = CGAffineTransform(scaleX: 1, y: 1)
            pressedView.alpha = 1
            self.view.bringSubview(toFront: pressedView)
        default:
            break
        }
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    @objc func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        
        longPressAnimation = UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: {
            self.longPressAnimation(with: longPress)
        })
        longPressAnimation?.startAnimation()
    }
    
    @objc func handleTriTap(_ triTaps: UITapGestureRecognizer) {
        guard let circle = triTaps.view else { return }
        circle.removeFromSuperview()
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return random(min: 0.0, max: 1.0)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        assert(max > min)
        return min + ((max - min) * CGFloat(arc4random()) / CGFloat(UInt32.max))
    }
}

extension UIColor {
    static func randomBrightColor() -> UIColor {
        return UIColor(hue: .random(),
                       saturation: .random(min: 0.5, max: 1.0),
                       brightness: .random(min: 0.7, max: 1.0),
                       alpha: 1.0)
    }
}

