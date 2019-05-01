//
//  FavoriteViewController.swift
//  githubExample
//
//  Created by 신동규 on 01/05/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

import UIKit
import SDWebImage

class FavoriteViewController: UIViewController {

    private let favoritesManager = FavoritesManager()
    private var currentfavorites:[Items?]?
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteTableView.delegate = self
        self.favoriteTableView.dataSource = self
        self.favoriteTableView.tableFooterView = UIView(frame: .zero)
        getFavoritesData()
    }

      
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getFavoritesData()
    }
    
    func getFavoritesData() {
        favoritesManager.getFavorite { [weak self](favorites, error) in
            self?.currentfavorites = favorites
            self?.favoriteTableView.reloadData()
            
        }
        
    }
    
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentfavorites?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoriteViewTableCell
        cell.idLabel.text = currentfavorites?[indexPath.row]?.login
        cell.scoreLabel.text = "Score: \(String(format: "%.6f",(currentfavorites?[indexPath.row]?.score)!))점"
        
        cell.avatarImageView.sd_setImage(with: URL(string: (currentfavorites?[indexPath.row]?.avatar_url)!), placeholderImage:nil)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "userWeb") as! UserWebViewController
        userPageViewController.urlString = currentfavorites?[indexPath.row]?.html_url ?? ""
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(userPageViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "좋아요 취소") { (action, indexPath) in
            self.favoritesManager.deleteFavorite(items:self.currentfavorites?[indexPath.row])
            self.currentfavorites?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete]
        
    }
    
    
}

