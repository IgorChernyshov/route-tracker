//
//  MapViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 19.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var switchTrackingButton: UIButton!
  
  private var beginBackgroundTask: UIBackgroundTaskIdentifier?
  
  private var locationManager: CLLocationManager?
  
  private var route: GMSPolyline?
  private var routePath: GMSMutablePath?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureLocationManager()
  }
  
  fileprivate func configureRouteStyle() {
    route?.strokeWidth = 7
    route?.strokeColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
  }
  
  fileprivate func configureLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.pausesLocationUpdatesAutomatically = false
    locationManager?.startMonitoringSignificantLocationChanges()
    locationManager?.requestAlwaysAuthorization()
    locationManager?.delegate = self
  }

  @IBAction func switchTrackingModeButtonWasPressed(_ sender: Any) {
    if switchTrackingButton.title(for: .normal) == "Start Tracking" {
      switchTrackingButton.setTitle("Stop Tracking", for: .normal)
      route?.map = nil
      route = GMSPolyline()
      configureRouteStyle()
      routePath = GMSMutablePath()
      route?.map = mapView
      locationManager?.startUpdatingLocation()
    } else {
      switchTrackingButton.setTitle("Start Tracking", for: .normal)
      locationManager?.stopUpdatingLocation()
      guard let routePath = routePath else { return }
      DataService.instance.saveRoute(routePath)
    }
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Center camera at users position
    guard let location = locations.last else { return }
    routePath?.add(location.coordinate)
    route?.path = routePath
    let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
    mapView.animate(to: position)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint(error.localizedDescription)
  }
}
