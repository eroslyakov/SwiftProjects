//
//  UserInfoVC.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 11.08.2021.
//

import UIKit

protocol UserInfoVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}

class UserInfoVC: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerViewPlaceholder = UIView()
    let itemViewOnePlaceholder = UIView()
    let itemViewTwoPlaceholder = UIView()
    let dateLabel = GHFBodyLabel(textAlignment: .center)
    var viewPlaceholders: [UIView] = []
    
    var username: String!
    weak var delegate: UserInfoVCDelegate?
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        layoutUIElements()
        getUserInfo()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func getUserInfo() {
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error):
                self.presentAlertOnMainThread(title: GHFError.somethingWrong.rawValue, message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToedges(of: view)
        contentView.pinToedges(of: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    func configureUIElements(with user: User) {
        self.add(childVC: UserInfoHeaderVC(user: user), to: self.headerViewPlaceholder)
        self.add(childVC: RepoItemVC(user: user, delegate: self), to: self.itemViewOnePlaceholder)
        self.add(childVC: FollowerItemVC(user: user, delegate: self), to: self.itemViewTwoPlaceholder)
        self.dateLabel.text = "GitHub since \(user.createdAt.toFormatString())"
    }
    
    func layoutUIElements() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        viewPlaceholders = [headerViewPlaceholder, itemViewOnePlaceholder, itemViewTwoPlaceholder, dateLabel]
        
        for itemView in viewPlaceholders {
            contentView.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }

        NSLayoutConstraint.activate([
            headerViewPlaceholder.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerViewPlaceholder.heightAnchor.constraint(equalToConstant: 200),
            
            itemViewOnePlaceholder.topAnchor.constraint(equalTo: headerViewPlaceholder.bottomAnchor, constant: padding),
            itemViewOnePlaceholder.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwoPlaceholder.topAnchor.constraint(equalTo: itemViewOnePlaceholder.bottomAnchor, constant: padding),
            itemViewTwoPlaceholder.heightAnchor.constraint(equalToConstant: itemHeight),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwoPlaceholder.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVC: UIViewController, to placeholder: UIView) {
        addChild(childVC)
        placeholder.addSubview(childVC.view)
        childVC.view.frame = placeholder.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoVC: RepoItemVCDelegate {
    
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            presentAlertOnMainThread(title: "Invalid URL", message: GHFError.invalidUrl.rawValue, buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}

extension UserInfoVC: FollowerItemVCDelegate {
    
    func didTapGetFollowers(for user: User) {
        guard user.followers > 0 else {
            presentAlertOnMainThread(title: "No followers", message: GHFError.noFollowers.rawValue, buttonTitle: "So sad")
            return
        }
        delegate?.didRequestFollowers(for: user.login)
        dismissSelf()
    }
}
