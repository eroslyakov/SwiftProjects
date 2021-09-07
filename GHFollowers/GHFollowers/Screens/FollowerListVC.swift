//
//  FollowerListVC.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 09.08.2021.
//

import UIKit

class FollowerListVC: UIViewController {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isRequestingFollowers = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureSearchController()
        configureNavigationBar()
        configureCollectionView()
        configureDataSource()
        getFollowers()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.setData(with: follower)
            
            return cell
        })
    }
    
    private func configureNavigationBar() {
        let addToFavotitesButton = UIBarButtonItem(image: SFSymbols.heart, style: .plain, target: self, action: #selector(addToFavoritesTapped))
        navigationItem.rightBarButtonItem = addToFavotitesButton
        navigationController?.navigationBar.isHidden = false
    }
    
    private func getFollowers() {
        guard filteredFollowers.isEmpty else { return }
        
        showLoader()
        isRequestingFollowers = true
        
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoader()
            self.isRequestingFollowers = false
            
            switch result {
            case .failure(let error):
                self.presentAlertOnMainThread(title: "Bad Stuff Happend", message: error.rawValue, buttonTitle: "Ok")
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                if followers.isEmpty {
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: GHFError.noFollowers.rawValue)
                    }
                    return
                }
                
                self.followers.append(contentsOf: followers)
                self.updateData(with: self.followers)
                self.page += 1
            }
        }
    }
    
    private func updateData(with followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    @objc func addToFavoritesTapped() {
        showLoader()
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            self?.dismissLoader()
            guard let self = self else { return }
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard error == nil else {
                        self.presentAlertOnMainThread(title: GHFError.somethingWrong.rawValue, message: error!.rawValue, buttonTitle: "Ok")
                        return
                    }
                    self.presentAlertOnMainThread(title: "Success!", message: "You have successfully favorited this user 🎉", buttonTitle: "Ok")
                }
            case .failure(let error):
                self.presentAlertOnMainThread(title: GHFError.somethingWrong.rawValue, message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

extension FollowerListVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height

        if offsetY > contentHeight - screenHeight
            && hasMoreFollowers
            && !isRequestingFollowers {
            getFollowers()
        }
    }
    
}

extension FollowerListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredFollowers = followers.filter({ (follower: Follower) in
                return follower.login.lowercased().contains(searchText.lowercased())
            })
            updateData(with: filteredFollowers)
        } else {
            filteredFollowers = []
            updateData(with: followers)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = filteredFollowers.isEmpty ? followers[indexPath.item] : filteredFollowers[indexPath.item]
        let destinationVC = UserInfoVC(username: follower.login)
        destinationVC.delegate = self
        let navigationController = UINavigationController(rootViewController: destinationVC)
        present(navigationController, animated: true)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
    }
}

extension FollowerListVC: UserInfoVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filteredFollowers.removeAll()
        hasMoreFollowers = true
        isRequestingFollowers = false
        getFollowers()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}
