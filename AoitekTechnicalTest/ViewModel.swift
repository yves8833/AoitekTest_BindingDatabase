//
//  ViewModel.swift
//  AoitekTechnicalTest
//
//  Created by YvesChen on 2020/2/10.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit
import Alamofire

enum HotModelStatus {
    case none
    case loading
    case success
    case failure
    case loadMoreLoading
    case loadMoreSuccess
    case loadMoreFailure
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
    var info: [SimpleHotModel]?
    private var pageID: String?
    var lastInfoCount: Int?
    
    func fetchRedditTaiwanHot() {
        self.status = .loading
        let parameters = ["limit": 25, "raw_json": 1]
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(TaiwanHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let result = response.data, let hotModel = try? JSONDecoder().decode(HotModel.self, from: result) {
                self.info = hotModel.info
                self.pageID = hotModel.pageId
                self.status = .success
            } else {
                /// error handle
                self.status = .failure
            }
            
        }
    }
    
    func loadMoreRedditTaiwanHotIfNeeded() {
        self.status = .loadMoreLoading
        lastInfoCount = info?.count
        guard let pageID = pageID else {
            return
        }
        let parameters = ["limit": 25, "raw_json": 1, "after": pageID] as [String : Any]
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(TaiwanHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let result = response.data, let hotModel = try? JSONDecoder().decode(HotModel.self, from: result) {
                self.info?.append(contentsOf: hotModel.info)
                self.pageID = hotModel.pageId
                self.status = .loadMoreSuccess
            } else {
                /// error handle
                self.status = .loadMoreFailure
            }
            
        }
    }
}

