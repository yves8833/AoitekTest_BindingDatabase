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
    var hotModels: [SimpleHotModel]? {
        get {
            return DataPersistant.hotModels()
        }
        set{
            if let hotModels = newValue {
                DataPersistant.saveHotModels(With: hotModels)
            }
        }
    }
    private var pageId: String?{
        get{
            return DataPersistant.pageId()
        }
        set{
            if let pageId = newValue {
                DataPersistant.savePageId(With: pageId)
            }
        }
        
    }
    var lastModelsCount: Int?
    
    func fetchRedditTaiwanHot() {
        self.status = .loading
        if let _ = hotModels {
            self.status = .success
            return
        }
        let parameters = ["limit": 25, "raw_json": 1]
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(TaiwanHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let result = response.data, let hotModel = try? JSONDecoder().decode(HotModel.self, from: result) {
                self.hotModels = hotModel.info.map({ (simpleHotJSONModel) -> SimpleHotModel in
                    if let imageInfo = simpleHotJSONModel.imageInfo {
                        return SimpleHotModel(title: simpleHotJSONModel.title, imageInfo: ImageModel(url: imageInfo.url, width: imageInfo.width, height: imageInfo.height))
                    } else {
                        return SimpleHotModel(title: simpleHotJSONModel.title, imageInfo: nil)
                    }
                })
                self.pageId = hotModel.pageId
                self.status = .success
            } else {
                /// error handle
                self.status = .failure
            }
            
        }
    }
    
    func loadMoreRedditTaiwanHotIfNeeded() {
        self.status = .loadMoreLoading
        guard let pageId = pageId else {
            self.status = .loadMoreFailure
            return
        }
        lastModelsCount = hotModels?.count
        let parameters = ["limit": 25, "raw_json": 1, "after": pageId] as [String : Any]
        let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
        Alamofire.request(TaiwanHotUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            if let result = response.data, let hotModel = try? JSONDecoder().decode(HotModel.self, from: result) {
                let loadMoreInfo = hotModel.info.map({ (simpleHotJSONModel) -> SimpleHotModel in
                                   if let imageInfo = simpleHotJSONModel.imageInfo {
                                       return SimpleHotModel(title: simpleHotJSONModel.title, imageInfo: ImageModel(url: imageInfo.url, width: imageInfo.width, height: imageInfo.height))
                                   } else {
                                       return SimpleHotModel(title: simpleHotJSONModel.title, imageInfo: nil)
                                   }
                               })
                self.hotModels?.append(contentsOf:loadMoreInfo)
                self.pageId = hotModel.pageId
                self.status = .loadMoreSuccess
            } else {
                /// error handle
                self.status = .loadMoreFailure
            }
            
        }
    }
}

