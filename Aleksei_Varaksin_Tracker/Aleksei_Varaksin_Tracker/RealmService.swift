//
//  RealmService.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 08.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import RealmSwift
import GoogleMaps

class RealmService {
    
    static let instance = RealmService()

    private init() {}
    
    func loadRoutes() -> [Date: GMSMutablePath] {
        var result: [Date: GMSMutablePath] = [:]
        var routePath = GMSMutablePath()
        var date = Date()
        do {
            let realm = try Realm()
            for object in realm.objects(Path.self) {
                routePath = GMSMutablePath(fromEncodedPath: object.path)!
                date = object.date
                result.updateValue(routePath, forKey: date)
            }
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    func saveRoute(_ route: GMSMutablePath) {
        let routePathString = route.encodedPath()
        let routePath = Path(path: routePathString)
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(routePath)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func signInUser(login: String, password: String) -> Bool {
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).filter("login = %@", login)
            if !user.isEmpty {
                return user[0].password == password ? true : false
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }

    func registerUser(login: String, password: String) -> Bool {
        do {
            let realm = try Realm()
            let user = realm.objects(User.self).filter("login = %@", login)
            if user.isEmpty {
                let newUser = User.init(login: login, password: password)
                try realm.write {
                    realm.add(newUser)
                }
                return true
            } else {
                try realm.write {
                    user[0].password = password
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
}
