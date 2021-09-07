//
//  GHFEmptyStateView.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 10.08.2021.
//

import UIKit

class GHFEmptyStateView: UIView {
    
    let messageLabel = GHFTitleLabel(textAlignment: .center, fontSize: 28)
    let logo = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        addSubviews(messageLabel, logo)

        messageLabel.numberOfLines = 3
        messageLabel.textColor = .secondaryLabel
        logo.image = Images.emptyStateLogo
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabelCenterYConstant: CGFloat = DeviceTypes.isiPhoneSEAspectRatio ? -80 : -150
        let logoBottomConstant: CGFloat = DeviceTypes.isiPhoneSEAspectRatio ? 80 : 40
        
        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: messageLabelCenterYConstant),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),
            
            logo.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logo.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logo.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: logoBottomConstant)
        ])
    }
    
}
