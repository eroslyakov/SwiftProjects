//
//  GHFItemInfoView.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 11.08.2021.
//

import UIKit

class GHFItemInfoView: UIView {

    let symbolImage = UIImageView()
    let titleLabel = GHFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GHFTitleLabel(textAlignment: .center, fontSize: 14)
    
    enum ItemInfoType {
        case repos, gists, following, followers
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        addSubviews(symbolImage, titleLabel, countLabel)
        
        symbolImage.translatesAutoresizingMaskIntoConstraints = false
        symbolImage.contentMode = .scaleToFill
        symbolImage.tintColor = .label
        
        NSLayoutConstraint.activate([
            symbolImage.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImage.widthAnchor.constraint(equalToConstant: 20),
            symbolImage.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.centerYAnchor.constraint(equalTo: symbolImage.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: symbolImage.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            countLabel.topAnchor.constraint(equalTo: symbolImage.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func setUIData(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImage.image = SFSymbols.repos
            titleLabel.text = "Public Repos"
        case .gists:
            symbolImage.image = SFSymbols.gists
            titleLabel.text = "Public Gists"
        case .following:
            symbolImage.image = SFSymbols.following
            titleLabel.text = "Following"
        case .followers:
            symbolImage.image = SFSymbols.followers
            titleLabel.text = "Followers"
        }
        countLabel.text = String(count)
    }
    
}
