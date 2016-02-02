//
//  CommentViewController.swift
//  MeetMeUo
//
//  Created by Steven Yang on 2/1/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var meetUp = NSDictionary()
    var comments = [NSDictionary]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        let group = meetUp.objectForKey("group") as! NSDictionary
        let urlName = group.objectForKey("urlname") as! String
        let eventId = meetUp.objectForKey("id") as! String
        loadComments(urlName, eventId: eventId)
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! DynamicTableViewCell
        let comment = self.comments[indexPath.row] as NSDictionary
        cell.titleLabel?.text = comment.objectForKey("comment") as? String
        let member = comment.objectForKey("member") as! NSDictionary
        cell.subtitleLabel?.text = member.objectForKey("name") as? String
        let time = comment.objectForKey("created") as! Double
        let date = NSDate(timeIntervalSince1970: time/1000)
        let dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        cell.dateLabel?.text = dateFormatter.stringFromDate(date)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }

    
    func loadComments(urlname: String, eventId: String){
        let apiUrl = "https://api.meetup.com/\(urlname)/events/\(eventId)/comments"
        let url = NSURL(string: apiUrl)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do {
                self.comments = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [NSDictionary]
//                for (_, value) in self.json {
//                    self.comments.append(value as! NSDictionary)
//                }
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
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tableView.indexPathForSelectedRow
        let comment = comments[indexPath!.row]
        let destinationVC = segue.destinationViewController as! MemberViewController
        let member = comment.objectForKey("member") as! NSDictionary
        destinationVC.member = member
    }
}
