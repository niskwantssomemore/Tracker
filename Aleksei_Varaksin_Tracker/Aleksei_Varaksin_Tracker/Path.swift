//
//  Path.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 08.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import RealmSwift

class Path: Object {

    @objc dynamic var path: String = ""
    @objc dynamic var date: Date = Date()

    convenience init (path: String) {
        self.init()
        self.path = path
    }
}
