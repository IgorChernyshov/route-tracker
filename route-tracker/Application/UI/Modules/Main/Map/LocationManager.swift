//
//  LocationManager.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 29/09/2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {
  
  static let instance = LocationManager()
  
  private override init() {
    super.init()
    configureLocationManager()
  }
  
  private let locationManager = CLLocationManager()
  
  let location: BehaviorSubject<CLLocation?> = BehaviorSubject(value: nil)
  
  func startUpdatingLocation() {
    locationManager.startUpdatingLocation()
  }
  
  func stopUpdatingLocation() {
    locationManager.stopUpdatingLocation()
  }
  
  private func configureLocationManager() {
    locationManager.delegate = self
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.startMonitoringSignificantLocationChanges()
    locationManager.requestAlwaysAuthorization()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    self.location.onNext(locations.last)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint(error.localizedDescription)
  }
}
