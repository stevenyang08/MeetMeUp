//
//  DynamicTableViewCell.swift
//  MeetMeUo
//
//  Created by Wong You Jing on 01/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

import UIKit

class DynamicTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
