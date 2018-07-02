//
//  battleTableCell.swift
//  Ultracorps Battle Simulator 2
//
//  Created by Darrell Root on 6/30/18.
//  Copyright © 2018 com.darrellroot. All rights reserved.
//

import UIKit

class battleTableCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
