//
//  CLMLayerAnimation.swift
//  SecretText
//
//  Created by dinghing on 8/15/16.
//  Copyright © 2016 dinghing.sample.com. All rights reserved.
//

import UIKit

class Quote {
    
    // MARK: - Properties
    
    var quote: String
    var author: String
    var image: UIImage
    
    // MARK: - Initializers
    
    init(quote: String, author: String, image: UIImage) {
        self.quote = quote
        self.author = author
        self.image = image
    }
}