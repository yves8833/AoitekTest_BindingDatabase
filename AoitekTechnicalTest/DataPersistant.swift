//
//  DataPersistant.swift
//  flickrPhotosSearch
//
//  Created by YvesChen on 2020/1/13.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import Foundation

let HotModelsKey = "HotModels"
let PageIdKey = "PageId"

class DataPersistant {
    
    static func userDefaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    static func saveHotModels(With info: [SimpleHotModel]) {
        let dictInfo = info.map { (simpleHotModel) -> Dictionary<String, Any> in
            if let imageInfo = simpleHotModel.imageInfo {
                return ["title": simpleHotModel.title, "url": imageInfo.url, "height": imageInfo.height, "width": imageInfo.width]
            } else {
                return ["title": simpleHotModel.title]
            }
        }
        self.userDefaults().set(dictInfo, forKey: HotModelsKey)
        self.userDefaults().synchronize()
    }
    
    static func hotModels() -> [SimpleHotModel]? {
        let info = self.userDefaults().array(forKey: HotModelsKey)
        return info?.map({ (dict) -> SimpleHotModel in
            let dictionary = (dict as! [String: Any])
            if let title = dictionary["title"] as? String, let url = dictionary["url"] as? String, let height = dictionary["height"] as? Int, let width = dictionary["width"] as? Int {
                return SimpleHotModel(title: title , imageInfo: ImageModel(url: url, width: width, height: height))
            } else {
                return SimpleHotModel(title: dictionary["title"] as! String , imageInfo: nil)
            }
        })
    }
    
    static func savePageId(With pageId: String) {
        self.userDefaults().set(pageId, forKey: PageIdKey)
        self.userDefaults().synchronize()
    }
    
    static func pageId() -> String? {
        return self.userDefaults().string(forKey: PageIdKey)
    }
    
}
