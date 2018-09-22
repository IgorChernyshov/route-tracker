//
//  DataService.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 20.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift
import GoogleMaps

class DataService {
  
  static let instance = DataService()
  
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
      debugPrint(error.localizedDescription)
    }
  }
  
  func loadRoute() -> GMSMutablePath {
    var routePath = GMSMutablePath()
    do {
      let realm = try Realm()
      let savedRoute = realm.objects(Path.self)
      routePath = GMSMutablePath(fromEncodedPath: savedRoute.first?.path ?? String())!
    } catch {
      debugPrint(error.localizedDescription)
    }
    return routePath
  }
}
