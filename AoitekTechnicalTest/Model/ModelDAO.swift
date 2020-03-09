//
//  RMModelDAO.swift
//  AoitekTechnicalTest
//
//  Created by Yves Chen on 2020/3/6.
//  Copyright © 2020 YvesChen. All rights reserved.
//

import Foundation
import RealmSwift

protocol RMModelDAO {
    func insert(With models: [SimpleHotModel])
    func data() -> (Results<RMModel>?)
    func deleteAll()
}

class ModelDAO: RMModelDAO {
    let queue = DispatchQueue(label: "ModelDAO", qos: .background)
    
    func insert(With models: [SimpleHotModel]) {
        guard let realm = try? Realm() else {
            return
        }
        try! realm.write {
            for jsonModel in models {
                guard !(jsonModel.imageUrl ?? "").isEmpty else {
                    return
                }
                let rmModel = RMModel()
                rmModel.id = jsonModel.id
                rmModel.title = jsonModel.title
                rmModel.imageUrl = jsonModel.imageUrl!
                realm.add(rmModel, update: .all)
            }
        }
    }
    
    func deleteAll() {
        guard let realm = try? Realm() else {
            return
        }
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func data() -> (Results<RMModel>?) {
        guard let realm = try? Realm() else {
            return nil
        }
        print(realm.configuration.fileURL)
        return realm.objects(RMModel.self)
    }
}
