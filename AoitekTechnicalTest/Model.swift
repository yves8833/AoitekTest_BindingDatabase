//
//  Model.swift
//  AoitekTechnicalTest
//
//  Created by YvesChen on 2020/2/10.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import UIKit

class HotModel: Decodable {
    var info: [SimpleHotModel]
    var pageId: String?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum SubCodingKeys: String, CodingKey {
        case children
        case after
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let data = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .data)
        pageId = try? data.decode(String.self, forKey: .after)
        info = try data.decode([SimpleHotModel].self, forKey:.children)
    }
}

class SimpleHotModel: Decodable {
    var title: String
    var imageInfo: [HotImageModel]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum SubCodingKeys: String, CodingKey {
        case title
        case preview
    }
    
    enum SubImageCodingKeys: String, CodingKey {
        case images
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .data)
        title = try data.decode(String.self, forKey:.title)
        
        let preview = try? data.nestedContainer(keyedBy: SubImageCodingKeys.self, forKey: .preview)
        imageInfo = try preview?.decode([HotImageModel].self, forKey: .images)
    }
}

class ImageModel: Decodable {
    var url: String?
    var width: Int
    var height: Int
    
    enum CodingKeys: String, CodingKey {
        case url
        case width
        case height
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey:.url)
        width = try container.decode(Int.self, forKey:.width)
        height = try container.decode(Int.self, forKey:.height)
    }
}

struct HotImageModel: Decodable {
    var source: ImageModel
    var resolutions: [ImageModel]
}
