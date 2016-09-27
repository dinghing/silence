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
    init(){
        initWithDate()
    }
    func initWithDate(){
        
//        let q1: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//        dispatch_async(q1,{() -> Void in
            let url = NSURL(string: "http://www.mymunan.com/patch/test.json")
            let request = NSURLRequest(url: url as! URL)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        
             //           DispatchQueue.main.asynchronously() {
                            self.dateFromJson = self.readJSONObject(object: dictionary)!
                            self.didEndLoad?(self.dateFromJson)
             //           }
                                           }
                } catch let error as NSError{
                    print(error.localizedDescription)
                }
  //          });
        })
        task.resume()
        
    }
    
    func readJSONObject(object: [String: AnyObject]) -> [[String: AnyObject]]?{
        guard
            let contents = object["contents"] as? [[String: AnyObject]]
        else {
            return nil }

        return contents
    }
}
