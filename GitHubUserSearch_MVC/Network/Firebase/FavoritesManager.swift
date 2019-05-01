//
//  FirebaseManager.swift
//  githubExample
//
//  Created by 신동규 on 01/05/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

import UIKit
import Firebase
import CodableFirebase

class FavoritesManager {
    
    func getFavorite(completion: @escaping ([Items?]?,Error?) -> Void) {
        Database.database().reference().child("favoriteModel").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let value = snapshot.value else { return }
            do {
                let model = try FirebaseDecoder().decode([Items].self, from: value)
                completion(model,nil)
            } catch let error {
                print(error)
               completion(nil,error)
                
            }
        })
      
    }
    
    func updateFavorite(items:Items?) {
        getFavorite { [weak self](currnetFavorite, error) in
            if currnetFavorite == nil {
                let data = try! FirebaseEncoder().encode([items])
                Database.database().reference().child("favoriteModel").setValue(data)
            } else {
                if (((self?.isDuplicate(favorites: currnetFavorite, login: items?.login))!)) {
                    var addedFavorites = currnetFavorite
                    addedFavorites?.append(items)
                    let data = try! FirebaseEncoder().encode(addedFavorites)
                    Database.database().reference().updateChildValues(["favoriteModel":data])

                }
                
            }
            
        }
        
    }
    
    
    func deleteFavorite(items:Items?){
        getFavorite { (currnetFavorite, error) in
            
            let deleteFavorites = currnetFavorite?.filter{$0?.login != items?.login}
            let data = try! FirebaseEncoder().encode(deleteFavorites)
            Database.database().reference().updateChildValues(["favoriteModel":data])
            
        }
        
    }
    
    func isDuplicate(favorites: [Items?]?, login: String?) -> Bool {
        let doubleCheck = favorites?.filter({ (item) -> Bool in
            return item?.login == login
        })
        return doubleCheck?.count == 0 ? true : false
        
    }
    
    func isFavoriteSelected(items: Items? ,completion: @escaping (Bool) -> Void){
       
        getFavorite { (currnetFavorite, error) in
            let seletedFavorite = currnetFavorite?.filter{$0?.login == items?.login}
            if seletedFavorite?.count == 1 {
                completion(true)
            }
            else {
                 completion(false)
            }
            
        }
      
        
    }

}
