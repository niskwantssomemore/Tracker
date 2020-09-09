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
  
  func saveRoute(_ route: GMSMutablePath) {
    let routePathString = route.encodedPath()
    let routePath = Path(path: routePathString)
    do {
      let realm = try Realm()
      let oldRoute = realm.objects(Path.self)
      try realm.write {
        realm.delete(oldRoute)
        realm.add(routePath)
      }
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func loadRoutes() -> GMSMutablePath {
    var routePath = GMSMutablePath()
    do {
      let realm = try Realm()
      let savedRoute = realm.objects(Path.self)
      routePath = GMSMutablePath(fromEncodedPath: savedRoute.first?.path ?? String())!
    } catch {
      print(error.localizedDescription)
    }
    return routePath
  }
}
