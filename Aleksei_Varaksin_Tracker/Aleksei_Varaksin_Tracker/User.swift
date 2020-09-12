//
//  User.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 10.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import RealmSwift

class User: Object {

    @objc dynamic var login: String = ""
    @objc dynamic var password: String = ""

    convenience init (login: String, password: String) {
        self.init()
        self.login = login
        self.password = password
    }
    override static func primaryKey() -> String? {
        return "login"
    }
}
