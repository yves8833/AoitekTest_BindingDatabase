//
//  RedditHotTableViewCell.swift
//  AoitekTechnicalTest
//
//  Created by YvesChen on 2020/2/10.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class RedditHotImageBackgroundTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        
        return label
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialView() {
        self.contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:  -5),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 30),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }

}
