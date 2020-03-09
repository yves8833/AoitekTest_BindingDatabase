//
//  ViewModel.swift
//  AoitekTechnicalTest
//
//  Created by YvesChen on 2020/2/10.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

enum HotModelStatus {
    case none
    case dataChanged
    case fetchServerLoading
    case fetchServerFailure
    case loadMoreLoading
    case loadMoreFailure
    case finish
}

protocol ViewModelDelegate: AnyObject {
    func updateWithStatus(_ status: HotModelStatus)
}

class ViewModel: NSObject {
    
    weak var delegate: ViewModelDelegate?
    var status: HotModelStatus = .none {
        didSet{
            DispatchQueue.main.async {
                self.delegate?.updateWithStatus(self.status)
            }
        }
    }
    
    private let TaiwanHotUrl = "https://www.reddit.com/r/Taiwan/hot.json"
    private let modelDAO = ModelDAO()
    var hotModels: Results<RMModel>? {
        return modelDAO.data()
    }
    
    private var pageId: String?
    private var notificationToken: NotificationToken? = nil
    func observeHotModels() {
        notificationToken = hotModels?.observe({ [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .error(_):
                self?.status = .fetchServerFailure
            default:
                self?.status = .dataChanged
            }
        })
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func bindingData() {
        observeHotModels()
        fetchFromServer()
    }
    
    private func fetchFromServer() {
        self.status = .fetchServerLoading
        let parameters = ["limit": 25, "raw_json": 1]
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(TaiwanHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let result = response.data, let hotModel = try? JSONDecoder().decode(HotModel.self, from: result) else {
                self.status = .fetchServerFailure
                return
            }
            
            self.pageId = hotModel.pageId
            self.modelDAO.deleteAll()
            self.modelDAO.insert(With: hotModel.info)
            self.status = .finish
        }
    }
    
    func loadMoreRedditTaiwanHotIfNeeded() {
        self.status = .loadMoreLoading
        guard let pageId = pageId else {
            self.status = .loadMoreFailure
            return
        }
        let parameters = ["limit": 25, "raw_json": 1, "after": pageId] as [String : Any]
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(TaiwanHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            guard let result = response.data, let hotModel = try? JSONDecoder().decode(HotModel.self, from: result) else {
                self.status = .loadMoreFailure
                return
            }
            
            self.pageId = hotModel.pageId
            self.modelDAO.insert(With: hotModel.info)
            self.status = .finish
        }
    }
}

