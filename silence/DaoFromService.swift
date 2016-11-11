//
//  DaoFromService.swift
//  SecretTextAnimation
//
//  Created by dinghing on 8/16/16.
//  Copyright © 2016 dinghing.sample.com. All rights reserved.
//

import Foundation
import UIKit

class getLecture {
    
    var didEndLoad: (([[String: AnyObject]]) -> Void)?
    
    var dateFromJson: [[String: AnyObject]] = []
    var url: String
    init(url: String){
        self.url = url
        initWithDate()
        
    }
    func initWithDate(){
        DispatchQueue.global().async {
            //let url = NSURL(string: "https://dinghing.github.io/test.json")
            let url = NSURL(string:self.url)
            let request = NSURLRequest(url: url as! URL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                do {
                    
                    let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        
                        DispatchQueue.main.async() {
                            self.dateFromJson = self.readJSONObject(object: dictionary)!
                            self.didEndLoad?(self.dateFromJson)
                        }
                    }
                } catch let error as NSError{
                    print(error.localizedDescription)
                }
        })
        task.resume()
        }
        
    }
    
    func readJSONObject(object: [String: AnyObject]) -> [[String: AnyObject]]?{
        guard
            let contents = object["contents"] as? [[String: AnyObject]]
        else {
            return nil }

        return contents
    }
}
