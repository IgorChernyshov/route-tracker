//
//  AuthenticationService.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 24.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import RealmSwift

class AuthenticationService {
  
  static let instance = AuthenticationService()
  
  private init() {}
  
  func signInUser(login: String, password: String) -> Bool {
    do {
      let realm = try Realm()
      let user = realm.objects(User.self).filter("login = %@", login)
      if !user.isEmpty {
        return checkPassword(user: user[0], insertedPassword: password)
      }
    } catch {
      debugPrint(error.localizedDescription)
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
      }
    } catch {
      debugPrint(error.localizedDescription)
    }
    return false
  }
  
  private func checkPassword(user: User, insertedPassword: String) -> Bool {
    return user.password == insertedPassword
  }
  
}
