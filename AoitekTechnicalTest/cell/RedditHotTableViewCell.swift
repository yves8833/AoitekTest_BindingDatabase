//
//  RedditHotTableViewCell.swift
//  AoitekTechnicalTest
//
//  Created by YvesChen on 2020/2/10.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class RedditHotTableViewCell: UITableViewCell {

    lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 14)
        
        return textView
    }()
    
    lazy var rightImageView: UIImageView = {
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
        self.contentView.addSubview(titleTextView)
        self.contentView.addSubview(rightImageView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleTextView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            titleTextView.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -10),
            
            rightImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            rightImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            rightImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            rightImageView.heightAnchor.constraint(equalTo: rightImageView.widthAnchor)
        ])
    }
}
