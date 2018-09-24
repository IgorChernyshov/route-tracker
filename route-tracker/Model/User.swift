//
//  User.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
  
  @objc dynamic var login: String = ""
  @objc dynamic var password: String = ""
  
  convenience init (login: String, password: String) {
    self.init()
    self.login = login
    self.password = password
  }
  
}
