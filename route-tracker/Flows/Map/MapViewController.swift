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
  
  private var route: RoutePolyline?
  private var routePath: GMSMutablePath?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLocationManager()
  }
  
  fileprivate func configureLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.pausesLocationUpdatesAutomatically = false
    locationManager?.startMonitoringSignificantLocationChanges()
    locationManager?.requestAlwaysAuthorization()
    locationManager?.delegate = self
    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  private func startTracking() {
    switchTrackingButton.setTitle("Stop Tracking", for: .normal)
    route?.map = nil
    route = RoutePolyline()
    routePath = GMSMutablePath()
    route?.map = mapView
    locationManager?.startUpdatingLocation()
  }
  
  private func stopTracking() {
    switchTrackingButton.setTitle("Start Tracking", for: .normal)
    locationManager?.stopUpdatingLocation()
    DispatchQueue.global().async { [weak self] in
      guard let routePath = self?.routePath else { return }
      RouteService.instance.saveRoute(routePath)
    }
  }
  
  private func showStopTrackingAlert() {
    let alertController = UIAlertController(title: "Tracking is active!", message: "You need to stop tracking first", preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Stop", style: .destructive) { [weak self] action in
      self?.stopTracking()
      self?.loadPreviousRoute()
    }
    alertController.addAction(confirmAction)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    present(alertController, animated: true, completion: nil)
  }
  
  private func loadPreviousRoute() {
    mapView.clear()
    route?.map = nil
    route = RoutePolyline()
    routePath = RouteService.instance.loadRoute()
    route?.path = routePath
    route?.map = mapView
    guard let setBounds = routePath else { return }
    let bounds = GMSCoordinateBounds(path: setBounds)
    mapView.animate(with: GMSCameraUpdate.fit(bounds))
  }
  
  private func setCameraAt(coordinate: CLLocationCoordinate2D) {
    let position = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
    mapView.animate(to: position)
  }
  
  @IBAction func switchTrackingModeButtonWasPressed(_ sender: Any) {
    if switchTrackingButton.title(for: .normal) == "Start Tracking" {
      startTracking()
    } else {
      stopTracking()
    }
  }
  
  @IBAction func showPreviousRouteButtonWasPressed(_ sender: Any) {
    if switchTrackingButton.title(for: .normal) == "Stop Tracking" {
      showStopTrackingAlert()
    } else {
      loadPreviousRoute()
    }
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Center camera at users position
    guard let location = locations.last else { return }
    routePath?.add(location.coordinate)
    route?.path = routePath
    setCameraAt(coordinate: location.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    debugPrint(error.localizedDescription)
  }
}
