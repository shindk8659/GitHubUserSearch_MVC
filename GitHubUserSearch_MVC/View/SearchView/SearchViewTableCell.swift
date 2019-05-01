//
//  SearchViewTableCell.swift
//  githubExample
//
//  Created by 신동규 on 29/04/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

import UIKit

class SearchViewTableCell: UITableViewCell {
    
    private var favoritesManager = FavoritesManager()
    public var items: Items?
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBAction func favoriteAction(_ sender: Any) {
        
        if favoriteButton.imageView?.image == UIImage.init(named: "reviewIcStar") {
            favoritesManager.deleteFavorite(items: items)
            favoriteButton.setImage(UIImage.init(named: "reviewIcStarGray"), for: .normal)
        } else {
            favoritesManager.updateFavorite(items: items)
            favoriteButton.setImage(UIImage.init(named: "reviewIcStar"), for: .normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
