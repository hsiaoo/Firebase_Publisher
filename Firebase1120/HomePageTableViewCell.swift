//
//  HomePageTableViewCell.swift
//  Firebase1120
//
//  Created by H.W. Hsiao on 2020/11/20.
//  Copyright © 2020 H.W. Hsiao. All rights reserved.
//

import UIKit

class HomePageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var content: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
