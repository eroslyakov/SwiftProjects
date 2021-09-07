//
//  FavoritesListVC.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 08.08.2021.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    let tableView = UITableView()
    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("FAVORITES WILL APPEAR")
        navigationController?.setNavigationBarHidden(false, animated: true)
        getFavorites()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeEmptyCells()
        
        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
    
    func getFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let favorites):
                print(favorites.count)
                if favorites.isEmpty {
                    self.showEmptyStateView(with: GHFError.emptyFavorites.rawValue)
                    return
                }
                self.hideEmptyStateView()
                self.favorites = favorites
                self.tableView.reloadDataOnMainThread()
                
            case .failure(let error):
                self.presentAlertOnMainThread(title: GHFError.somethingWrong.rawValue, message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FavoritesListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        cell.setData(with: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let destinationVC = FollowerListVC(username: favorite.login)
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        PersistenceManager.updateWith(favorite: favorites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                self.presentAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok")
                return
            }
            
            self.favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            if self.favorites.isEmpty {
                DispatchQueue.main.async {
                    self.showEmptyStateView(with: GHFError.emptyFavorites.rawValue)
                }
            }
        }
    }
}
