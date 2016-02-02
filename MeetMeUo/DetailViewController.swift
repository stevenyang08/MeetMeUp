//
//  DetailViewController.swift
//  MeetMeUo
//
//  Created by Steven Yang on 2/1/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var meetUp = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = meetUp.objectForKey("name") as? String
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell1")!
        var text : String
        switch indexPath.row{
            
        case 0:
            let group = self.meetUp.objectForKey("group") as! NSDictionary
            text  = (group.objectForKey("name") as? String)!
            cell.textLabel?.text = String(text)
        case 1:
            text = "RSVP Count: " + String(self.meetUp.objectForKey("yes_rsvp_count") as! Int)
            cell.textLabel?.text = String(text)
        case 2:
            let htmlText = (self.meetUp.objectForKey("description") as? String)!
            var text : NSAttributedString
            do {
                text = try NSAttributedString(data: htmlText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            } catch {
                text = NSAttributedString()
            }
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.attributedText = text
        default:
            text = ""
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! CommentViewController
        destination.meetUp = self.meetUp
    }
    
    @IBAction func onWebsiteTapped(sender: UIButton) {
        let url = NSURL(string: meetUp.objectForKey("event_url") as! String)
        let sfvc = SFSafariViewController(URL: url!)
        presentViewController(sfvc, animated: true, completion: nil)
    }
}
