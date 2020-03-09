//
//  ViewController.swift
//  AoitekTechnicalTest
//
//  Created by YvesChen on 2020/2/10.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    let RedditHotTableViewCellReuseIdentifier = "RedditHotTableViewCell"
    let RedditHotImageBackgroundTableViewCellReuseIdentifier = "RedditHotImageBackgroundTableViewCell"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.register(RedditHotImageBackgroundTableViewCell.self, forCellReuseIdentifier: RedditHotImageBackgroundTableViewCellReuseIdentifier)
        tableView.register(RedditHotTableViewCell.self, forCellReuseIdentifier: RedditHotTableViewCellReuseIdentifier)
        
        return tableView
    }()
    
    private lazy var loadingIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicatorView)
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return activityIndicatorView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return label
    }()
    
    lazy var viewModel: ViewModel = {
        let viewModel = ViewModel()
        viewModel.delegate = self
        
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.bindingData()
        initialView()
    }
    
    func initialView() {
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hotModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 4 == 0 {
            return 200
        } else {
            return UIScreen.main.bounds.size.width / 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let hotModel = viewModel.hotModels?[indexPath.row] else { return UITableViewCell() }
        if indexPath.row % 4 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RedditHotImageBackgroundTableViewCellReuseIdentifier, for: indexPath) as! RedditHotImageBackgroundTableViewCell
            cell.titleLabel.text = hotModel.title
            cell.backgroundImageView.sd_setImage(with: URL(string: hotModel.imageUrl), placeholderImage: UIImage(named: "slowmo"))
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RedditHotTableViewCellReuseIdentifier, for: indexPath) as! RedditHotTableViewCell
            cell.titleTextView.text = hotModel.title
            cell.rightImageView.sd_setImage(with: URL(string: hotModel.imageUrl), placeholderImage: UIImage(named: "slowmo"))
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let hotModels = viewModel.hotModels, indexPath.row == hotModels.count - 1, viewModel.status != .loadMoreLoading {
            viewModel.loadMoreRedditTaiwanHotIfNeeded()
        }
    }
}

extension ViewController: ViewModelDelegate {
    func updateWithStatus(_ status: HotModelStatus) {
        switch status {
        case .fetchServerLoading:
            loadingIndicatorView.startAnimating()
            tableView.isHidden = true
            errorLabel.isHidden = true
            break
        case .fetchServerFailure:
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = true
            errorLabel.isHidden = false
            errorLabel.text = "網路異常，請稍後再試。"
            break
        case .loadMoreFailure:
            let alert = UIAlertController.init(title: "Alert", message: "加載失敗", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            break
        case .dataChanged:
            tableView.reloadData()
            loadingIndicatorView.stopAnimating()
            tableView.isHidden = false
            errorLabel.isHidden = true
            break
        default:
            break
        }
    }
    
    
}
