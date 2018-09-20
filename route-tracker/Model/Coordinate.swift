//
//  Coordinate.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 20.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class Coordinate: Object {
  
  @objc dynamic var latitude = 0.0
  @objc dynamic var longitude = 0.0
  
  convenience init (coordinate: CLLocationCoordinate2D) {
    self.init()
    self.latitude = coordinate.latitude
    self.longitude = coordinate.longitude
  }
  
}
