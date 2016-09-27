//
//  CLMLayerAnimation.swift
//  SecretText
//
//  Created by dinghing on 8/15/16.
//  Copyright © 2016 dinghing.sample.com. All rights reserved.
//

import Foundation
import QuartzCore

class CLMLayerAnimation: NSObject {
    
    // MARK: - Properties
    
    var completionClosure: ((_ finished: Bool)-> ())? = nil
    var layer: CALayer!
    
    // MARK: - Convenience
    
    class func animation(layer: CALayer, duration: TimeInterval, delay: TimeInterval, animations: (() -> ())?, completion: ((_ finished: Bool)-> ())?) -> CLMLayerAnimation {
        
        let animation = CLMLayerAnimation()
        
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            
            var animationGroup: CAAnimationGroup?
            let oldLayer = self.animatableLayerCopy(layer: layer)
            animation.completionClosure = completion
            
            if let layerAnimations = animations {
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                layerAnimations()
                CATransaction.commit()
            }
            
            animationGroup = self.groupAnimationsForDifferences(oldLayer: oldLayer, newLayer: layer)
            
            if let differenceAnimation = animationGroup {
                differenceAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                differenceAnimation.duration = duration
                differenceAnimation.beginTime = CACurrentMediaTime()
                differenceAnimation.delegate = animation
                layer.add(differenceAnimation, forKey: nil)
            }else{
                if let completion = animation.completionClosure {
                    completion(true)
                }
            }
        })
        return animation
    }
    
    class func groupAnimationsForDifferences(oldLayer: CALayer, newLayer: CALayer) -> CAAnimationGroup? {
        var animationGroup: CAAnimationGroup?
        var animations = [CABasicAnimation]()
        
        if !CATransform3DEqualToTransform(oldLayer.transform, newLayer.transform) {
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D: oldLayer.transform)
            animation.toValue = NSValue(caTransform3D: newLayer.transform)
            animations.append(animation)
        }
        
        if !oldLayer.bounds.equalTo(newLayer.bounds) {
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.fromValue = NSValue(cgRect: oldLayer.bounds)
            animation.toValue = NSValue(cgRect: newLayer.bounds)
            animations.append(animation)
        }
        
        if !oldLayer.frame.equalTo(newLayer.frame) {
            let animation = CABasicAnimation(keyPath: "frame")
            animation.fromValue = NSValue(cgRect: oldLayer.frame)
            animation.toValue = NSValue(cgRect: newLayer.frame)
            animations.append(animation)
        }
        
        if !oldLayer.position.equalTo(newLayer.position) {
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(cgPoint: oldLayer.position)
            animation.toValue = NSValue(cgPoint: newLayer.position)
            animations.append(animation)
        }
        
        if oldLayer.opacity != newLayer.opacity {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = oldLayer.opacity
            animation.toValue = newLayer.opacity
            animations.append(animation)
        }
        
        if animations.count > 0 {
            animationGroup = CAAnimationGroup()
            animationGroup!.animations = animations
        }
        
        return animationGroup
    }
    
    class func animatableLayerCopy(layer: CALayer) -> CALayer {
        
        let layerCopy = CALayer()
        
        layerCopy.opacity = layer.opacity
        layerCopy.transform = layer.transform
        layerCopy.bounds = layer.bounds
        layerCopy.position = layer.position
        
        return layerCopy
    }
    
    // MARK: - Core Animation Delegate
    
     func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let completion = completionClosure {
            completion(true)
        }
    }
}
