//
//  MemberViewController.swift
//  MeetMeUo
//
//  Created by Wong You Jing on 01/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    var member = NSDictionary()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var roleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = member.objectForKey("name") as? String
        let photo = member.objectForKey("photo") as! NSDictionary
        if let url = NSURL(string: photo.objectForKey("highres_link") as! String) {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }        
        }
        if let role = member.objectForKey("role") as? String{
            roleLabel.text = role
        }
    }
}
