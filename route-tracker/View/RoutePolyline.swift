//
//  RoutePolyline.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 20.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import GoogleMaps

class RoutePolyline: GMSPolyline {
  
  override init() {
    super.init()
    self.strokeWidth = 7
    self.strokeColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
  }
  
}
