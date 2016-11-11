//
//  ViewController.swift
//  silence
//
//  Created by dinghing on 9/25/16.
//  Copyright © 2016 dinghing.sample.com. All rights reserved.
//

import UIKit

//closure
//typealias SendValueClosure = (_ indexValue:Int)->Void


class ViewController: UITableViewController {
    
    //Types
    //var closure : SendValueClosure?
    
    //var rowNumber = 0
    struct Constaint {
        
        struct Images {
            static let one = "First"
            static let two = "Second"
            static let three = "Third"
            static let four = "Forth"
            static let five = "Fifth"
            static let six = "Sixth"
        }
    }
    
    var entries = [
        Entry(title:"First Entry",image:UIImage(named:"First")!),
        Entry(title:"Exploring",image:UIImage(named:"Second")!),
        Entry(title:"Traveling Abroad",image:UIImage(named:"Third")!),
        Entry(title:"Scuba Diving",image:UIImage(named:"Forth")!),
        Entry(title:"Trip Together",image:UIImage(named:"Fifth")!),
        Entry(title:"The Everything",image:UIImage(named:"Sixth")!)
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EntryCell
        let entry = entries[indexPath.row]
        
        cell.entryTitle.text = entry.title
        cell.entryImage.image = entry.image
        
        return cell
    }
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView!.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "sendValue", sender: indexPath.row)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "sendValue"{
            let controller = segue.destination as! dialectViewController
            controller.indexOfURL = Int(sender as! NSNumber)
        }
    }

    
    func configureNavigationController() {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureNavigationController()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

