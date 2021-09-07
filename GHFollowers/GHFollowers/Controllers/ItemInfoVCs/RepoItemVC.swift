//
//  RepoItemVC.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 11.08.2021.
//

import UIKit

protocol RepoItemVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
}

class RepoItemVC: ItemInfoVC {
    
    weak var delegate: RepoItemVCDelegate?
    
    init(user: User, delegate: RepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        itemViewOne.setUIData(itemInfoType: .repos, withCount: user.publicRepos)
        itemViewTwo.setUIData(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGitHubProfile(for: user)
    }
}
