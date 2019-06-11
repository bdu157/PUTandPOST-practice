//
//  ToDo.swift
//  PUTandPost-practice
//
//  Created by Dongwoo Pae on 6/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Todo: Codable {
    var title: String
    var identifier: String
    
    init(title: String, identifier: String = UUID().uuidString) {
        self.title = title
        self.identifier = identifier
    }
}
