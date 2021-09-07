//
//  FollowerItemVC.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 11.08.2021.
//

import UIKit

protocol FollowerItemVCDelegate: AnyObject {
    func didTapGetFollowers(for user: User)
}

class FollowerItemVC: ItemInfoVC {
    
    weak var delegate: FollowerItemVCDelegate?
    
    init(user: User, delegate: FollowerItemVCDelegate) {
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
        itemViewOne.setUIData(itemInfoType: .followers, withCount: user.followers)
        itemViewTwo.setUIData(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        delegate?.didTapGetFollowers(for: user)
    }
}
