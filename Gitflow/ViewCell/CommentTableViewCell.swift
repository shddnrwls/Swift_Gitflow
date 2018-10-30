//
//  CommentTableViewCell.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 26..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet var createdAtLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
