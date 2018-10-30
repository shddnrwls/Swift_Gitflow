//
//  RepositoryTableViewCell.swift
//  Gitflow
//
//  Created by mac on 2018. 9. 12..
//  Copyright © 2018년 UkJin. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet var repositoryNameLabel: UILabel!
    @IBOutlet var languageLable: UILabel!
    @IBOutlet var codeLineLabel: UILabel!
    @IBOutlet var totalCommitLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
