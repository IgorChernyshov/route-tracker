//
//  Path.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 20.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift

class Path: Object {
  
  @objc dynamic var path: String = ""
  
  convenience init (path: String) {
    self.init()
    self.path = path
  }
  
}
