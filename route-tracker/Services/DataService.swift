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
    var routePath: [CLLocationCoordinate2D] = []
    for i in 0..<route.count() {
      routePath.append(route.coordinate(at: i))
    }
    let coordinates = routePath.compactMap { Coordinate(coordinate: $0) }
    do {
      let realm = try Realm()
      let oldRoute = realm.objects(Coordinate.self)
      try realm.write {
        realm.delete(oldRoute)
        realm.add(coordinates)
      }
    } catch {
      debugPrint(error.localizedDescription)
    }
  }
  
  func loadRoute() -> GMSMutablePath {
    let routePath = GMSMutablePath()
    do {
      let realm = try Realm()
      let savedRoute = realm.objects(Coordinate.self)
      for coordinate in savedRoute {
        var clCoordinate = CLLocationCoordinate2D()
        clCoordinate.latitude = coordinate.latitude
        clCoordinate.longitude = coordinate.longitude
        routePath.add(clCoordinate)
      }
    } catch {
      debugPrint(error.localizedDescription)
    }
    return routePath
  }
}
