//
//  SearchTableViewCell.swift
//  Gitflow
//
//  Created by mac on 2018. 10. 23..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var departmentNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
