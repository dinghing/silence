//
//  CLMLayerAnimation.swift
//  SecretText
//
//  Created by dinghing on 8/15/16.
//  Copyright © 2016 dinghing.sample.com. All rights reserved.
//

import UIKit

class FadingLabel: CharacterLabel {
    
    // MARK: - Properties

    override var attributedText: NSAttributedString! {
        get {
            return super.attributedText
        }
        
        set {
            super.attributedText = newValue
            self.animateIn { (finished) in
                self.animateIn(completion: nil)
            }
        }
    }
    
    override func initialTextLayerAttributes(textLayer: CATextLayer) {
        textLayer.opacity = 0
    }
    
    // MARK: - Convenience
    
    func animateIn(completion: ((_ finished: Bool) -> Void)?) {
    
        for textLayer in characterTextLayers {
            
            let duration = (TimeInterval(arc4random() % 100) / 200.0) + 0.25
            let delay = TimeInterval(arc4random() % 100) / 500.0
                        
            CLMLayerAnimation.animation(layer: textLayer, duration: duration, delay: delay, animations: {
                textLayer.opacity = 1
                }, completion:nil)
        }

    }

    func animateOut(completion: ((_ finished: Bool) -> Void)?) {
        var longestAnimation = 0.0
        var longestAnimationIndex = -1
        var index = 0
        
        for textLayer in oldCharacterTextLayers {
            
            let duration = (TimeInterval(arc4random() % 100) / 200.0) + 0.25
            let delay = TimeInterval(arc4random() % 100) / 500.0
            
            if duration+delay > longestAnimation {
                longestAnimation = duration + delay
                longestAnimationIndex = index
            }
            CLMLayerAnimation.animation(layer: textLayer, duration: duration, delay: delay, animations: {
                textLayer.opacity = 0
                }, completion: { finished in
                    textLayer.removeFromSuperlayer()
                    if textLayer == self.oldCharacterTextLayers[longestAnimationIndex] {
                        if let completionFunction = completion {
                            completionFunction(finished)
                        }
                    }
            })
            
            index += 1
        }
    }
    
}
