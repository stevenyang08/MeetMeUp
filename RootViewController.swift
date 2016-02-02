//
//  RootViewController.swift
//  MeetMeUo
//
//  Created by Steven Yang on 2/1/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    let apiKey = "e1a593549141e25726b49653c82572"
    var json = NSDictionary()
    var meetups = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let searchTerm = "mobile"
        loadSearchTerm(searchTerm)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        let meetup = self.meetups[indexPath.row]
        cell.textLabel?.text = meetup.objectForKey("name") as? String
        if let venue = meetup.objectForKey("venue") as! NSDictionary?{
            cell.detailTextLabel?.text = venue.objectForKey("address_1") as? String
        }
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetups.count
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        var searchTerm = searchBar.text!
        searchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+")
        loadSearchTerm(searchTerm)
    }

    @IBAction func onTapped(sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    func loadSearchTerm(searchTerm: String){
        let apiUrl = "https://api.meetup.com/2/open_events.json?zip=60604&text=\(searchTerm)&time=,1w&key="
        let url = NSURL(string: apiUrl + apiKey)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                self.json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                self.meetups = self.json.objectForKey("results") as! [NSDictionary]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
            catch let error as NSError{
                print("json error: \(error.localizedDescription)")
            }
            
        }
        task.resume()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! DetailViewController
        let indexPath = self.tableView.indexPathForSelectedRow!
        let meetup = self.meetups[indexPath.row]
        destination.meetUp = meetup
    }
}
