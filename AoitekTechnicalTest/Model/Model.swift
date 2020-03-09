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
    var id: String
    var title: String
    var imageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum SubCodingKeys: String, CodingKey {
        case title
        case preview
        case id
    }
    
    enum SubImageCodingKeys: String, CodingKey {
        case images
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .data)
        title = try data.decode(String.self, forKey:.title)
        id = try data.decode(String.self, forKey: .id)
        
        let preview = try? data.nestedContainer(keyedBy: SubImageCodingKeys.self, forKey: .preview)
        let imageInfos = try? preview?.decode([ImageJSONModel].self, forKey: .images)
        imageUrl = imageInfos?.first?.url
    }
}

class ImageJSONModel: Decodable {
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case source
    }
    
    enum SubCodingKeys: String, CodingKey {
        case url
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let source = try container.nestedContainer(keyedBy: SubCodingKeys.self, forKey: .source)
        url = try source.decode(String.self, forKey:.url)
    }
}
