//
//  MapViewController.swift
//  route-tracker
//
//  Created by Igor Chernyshov on 19.09.2018.
//  Copyright © 2018 Igor Chernyshov. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var switchTrackingButton: UIButton!
  
  private var locationManager: CLLocationManager?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureLocationManager()
  }
  
  fileprivate func configureLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.requestWhenInUseAuthorization()
    locationManager?.delegate = self
  }
  
  fileprivate func addMarker(atCoordinate: CLLocationCoordinate2D) {
    let marker = GMSMarker(position: atCoordinate)
    marker.map = mapView
  }

  @IBAction func switchTrackingModeButtonWasPressed(_ sender: Any) {
    if switchTrackingButton.title(for: .normal) == "Start Tracking" {
      switchTrackingButton.setTitle("Stop Tracking", for: .normal)
      locationManager?.startUpdatingLocation()
    } else {
      switchTrackingButton.setTitle("Start Tracking", for: .normal)
      locationManager?.stopUpdatingLocation()
    }
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Center camera at users position
    guard let coordinate = locations.last?.coordinate else { return }
    let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
    mapView.camera = camera
    addMarker(atCoordinate: coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint(error.localizedDescription)
  }
}
