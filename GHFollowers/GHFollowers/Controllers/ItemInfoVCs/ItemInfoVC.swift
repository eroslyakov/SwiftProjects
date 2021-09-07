//
//  ItemInfoVC.swift
//  GHFollowers
//
//  Created by Rosliakov Evgenii on 11.08.2021.
//

import UIKit

class ItemInfoVC: UIViewController {
    
    let horizontalStack = UIStackView()
    let itemViewOne = GHFItemInfoView()
    let itemViewTwo = GHFItemInfoView()
    let actionButton = GHFButton()
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBackground()
        configureStackView()
        configureActionButton()
        layoutUI()
    }
    
    func configureBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    func configureStackView() {
        horizontalStack.axis = .horizontal
        horizontalStack.distribution = .equalSpacing
        
        horizontalStack.addArrangedSubview(itemViewOne)
        horizontalStack.addArrangedSubview(itemViewTwo)
    }
    
    func configureActionButton() {
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {}
    
    func layoutUI() {
        view.addSubviews(horizontalStack, actionButton)
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            horizontalStack.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

}
