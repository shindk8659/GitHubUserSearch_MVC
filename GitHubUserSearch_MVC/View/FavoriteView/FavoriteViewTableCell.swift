//
//  FavoriteViewTableCell.swift
//  githubExample
//
//  Created by 신동규 on 01/05/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

import UIKit

class FavoriteViewTableCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }

}
