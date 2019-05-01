//
//  ViewController.swift
//  githubExample
//
//  Created by 신동규 on 29/04/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

import UIKit
import SDWebImage

class SearchViewController: UIViewController {

    private let networkManager = NetworkManager()
    private var favoritesManager = FavoritesManager()
    private var searchBar = UISearchBar(frame: CGRect.zero)
    private var searchWord = ""
    private var currentPage = 1
    private var totalCount = 1000
    private var searchModel: SearchModel?
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
        self.searchTableView.tableFooterView = UIView(frame: .zero)
        self.searchBar.delegate = self
        self.searchBar.placeholder = "GitHub ID를 검색 해주세요. :)"
        self.navigationItem.titleView = self.searchBar
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.searchTableView.reloadData()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchModel?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchViewTableCell
        let items = searchModel?.items?[indexPath.row]
        cell.items = items
        cell.idLabel.text = items?.login
        cell.scoreLabel.text = "Score: \( String(format: "%.6f",(items?.score)!))점"
        cell.avatarImageView.sd_setImage(with: URL(string: (items?.avatar_url)!), placeholderImage:nil)
        
        favoritesManager.isFavoriteSelected(items:items) { (bool) in
            if bool == true {
                cell.favoriteButton.setImage(UIImage.init(named: "reviewIcStar"), for: .normal)
            } else {
                cell.favoriteButton.setImage(UIImage.init(named: "reviewIcStarGray"), for: .normal)
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userPageViewController = self.storyboard?.instantiateViewController(withIdentifier: "userWeb") as! UserWebViewController
        let items = searchModel?.items?[indexPath.row]
        userPageViewController.urlString = items?.html_url ?? ""
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(userPageViewController, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = searchModel?.items?.count ?? 0
        if indexPath.row == count - 1 {
            if count < totalCount {
                self.networkManager.search(searchWord: searchWord, searchPage: currentPage) {
                    [weak self] model,error in
                    if model?.items != nil {
                        self?.searchModel?.items? += (model?.items)!
                        self?.currentPage += 1
                        self?.perform(#selector(self?.loadTable), with: nil, afterDelay: 0.5)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @objc func loadTable() {
       self.searchTableView.reloadData()
        
    }
}

extension SearchViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true;
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false;
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchModel = nil
        self.currentPage = 1
        self.searchTableView.setContentOffset(CGPoint.zero, animated: false)
        self.searchTableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchTableView.setContentOffset(CGPoint.zero, animated: false)
        self.currentPage = 1
        self.searchWord = searchBar.text ?? ""
        self.networkManager.search(searchWord: searchWord, searchPage: currentPage) { [weak self] model, error in
            if model?.items != nil {
                self?.searchModel = model
                self?.currentPage += 1
                self?.totalCount = (model?.total_count)! > 1000 ? 1000: (model?.total_count)!
                self?.searchTableView.reloadData()
                
            }
            
        }
        self.searchBar.resignFirstResponder()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
    }
   
}

