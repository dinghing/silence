//
//  dialectViewController.swift
//  silence
//
//  Created by dinghing on 9/25/16.
//  Copyright © 2016 dinghing.sample.com. All rights reserved.
//

import Foundation
import UIKit

class dialectViewController: UIViewController {
    
    // MARK: - Types
    
    struct Constants {
        struct Images {
            static let one = "one"
            static let two = "two"
            static let three = "three"
            static let four = "four"
            static let five = "five"
            static let six = "six"
            static let seven = "seven"
            static let eight = "eight"
            static let nine = "nine"
            static let ten = "ten"
        }
    }
    
    // MARK: - Properties
    
    @IBOutlet var backgroundImageView: UIImageView!
    
    var quoteLabel: FadingLabel!
    let animationDuration: TimeInterval = 1.0
    let switchingInterval: TimeInterval = 3.0
    var currentIndex = 0
    
    var quotes = [
        Quote(quote: "\"The unexamined life is not worth living.\"", author: "Socrates", image: UIImage(named: Constants.Images.one)!),
        Quote(quote: "\"The most beautiful thing we can experience is the mysterious. It is the source of all true art and science.\"", author: "Albert Einstein", image: UIImage(named: Constants.Images.two)!),
        Quote(quote: "\"I do not steal victory.\"", author: "Alexander the Great", image: UIImage(named: Constants.Images.three)!),
        Quote(quote: "\"The key to immortality is first living a life worth remembering.\"", author: "Bruce Lee", image: UIImage(named: Constants.Images.four)!),
        Quote(quote: "\"Decide... whether or not the goal is worth the risks involved. If it is, stop worrying....\"", author: "Amelia Earhart", image: UIImage(named: Constants.Images.five)!),
        Quote(quote: "\"I've failed over and over and over again in my life and that is why I succeed.\"", author: "Michael Jordan", image: UIImage(named: Constants.Images.six)!),
        Quote(quote: "\"Kind words can be short and easy to speak, but their echoes are truly endless.\"", author: "Mother Teresa", image: UIImage(named: Constants.Images.seven)!),
        Quote(quote: "\"Live as if you were to die tomorrow; learn as if you were to live forever.\"", author: "Mahatma Gandhi", image: UIImage(named: Constants.Images.eight)!),
        Quote(quote: "\"Somewhere, something incredible is waiting to be known.\"", author: "Carl Sagan", image: UIImage(named: Constants.Images.nine)!),
        Quote(quote: "\"It is not death that a man should fear, but he should fear never beginning to live.\"", author: "Marcus Aurelius", image: UIImage(named: Constants.Images.ten)!),
        ]
    
    // MARK: - View Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupCharacterLabel()
        setupBackgroundImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO this is changed to use the local data to evalute
        //I will change it to github
        let hoge = getLecture()
        hoge.didEndLoad = {(obj) in
            //print(obj.description,"mainThread")
            self.getDate(content: obj)
            self.animateBackgroundImageView()
        }
    }
    
    func getDate(content: [[String:AnyObject]])
    {
        for index in 0..<10 {
            quotes[index].quote = (content[index]["lecture"] as? String)!
            quotes[index].author = (content[index]["author"] as? String)!
        }
        
    }
    // MARK: - Convenience
    
    func animateBackgroundImageView() {
        
        // Quote is switched here so it is in sync with the image switching.
        switchQuote()
        
        CATransaction.begin()
        
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(self.switchingInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                self.animateBackgroundImageView()
            })
        }
        
        let transition = CATransition()
        transition.type = kCATransitionFade
        
        
        backgroundImageView.layer.add(transition, forKey: kCATransition)
        backgroundImageView.image = quotes[currentIndex].image
        
        CATransaction.commit()
        
        // Increase index to switch both the quote and image to the next.
        currentIndex = currentIndex < quotes.count - 1 ? currentIndex + 1 : 0
    }
    
    func switchQuote() {
        quoteLabel.text = "" // Clear label before switching to a new quote.
        quoteLabel.text = quotes[currentIndex].quote + "\n\n" + quotes[currentIndex].author
        
    }
    
    func setupBackgroundImageView() {
        // Initial image.
        backgroundImageView.image = quotes[currentIndex].image
    }
    
    func setupCharacterLabel() {
        quoteLabel = FadingLabel(frame: CGRect(x: 20, y: 20, width: 100, height: 100))
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        quoteLabel.textAlignment = NSTextAlignment.center
        //quoteLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        quoteLabel.font = UIFont(name: "PingFangTC-Ultralight", size: 30)
        quoteLabel.textColor = UIColor.white
        quoteLabel.lineBreakMode = .byWordWrapping
        quoteLabel.numberOfLines = 0
        
        self.view.addSubview(quoteLabel)
        
        // Constraints.
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            quoteLabel.widthAnchor.constraint(equalToConstant: self.view.frame.width / 1.25)
            ])
    }
    
    // MARK: - Status Bar
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
}

