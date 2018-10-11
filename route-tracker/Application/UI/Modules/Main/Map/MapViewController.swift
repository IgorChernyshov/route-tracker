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
import RxSwift

class MapViewController: UIViewController {
  
  @IBOutlet weak var mapView: GMSMapView!
  @IBOutlet weak var switchTrackingButton: UIButton!
  
  private var beginBackgroundTask: UIBackgroundTaskIdentifier?
  
  private let locationManager = LocationManager.instance
  private let disposeBag = DisposeBag()
  
  private var route: RoutePolyline?
  private var routePath: GMSMutablePath?
  private var marker: SelfieMarker?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureLocationManager()
  }
  
  private func addNewMarker(coordinate: CLLocationCoordinate2D) {
    removeOldMarker()
    
    let marker = SelfieMarker(position: coordinate)
    marker.map = mapView
    self.marker = marker
  }
  
  private func removeOldMarker() {
    marker?.map = nil
    marker = nil
  }
  
  private func configureLocationManager() {
    locationManager
    .location
    .asObservable()
    .bind { [weak self] location in
      guard let location = location else { return }
      self?.routePath?.add(location.coordinate)
      self?.route?.path = self?.routePath
      self?.setCameraAt(coordinate: location.coordinate)
      self?.addNewMarker(coordinate: location.coordinate)
    }
    .disposed(by: disposeBag)
  }
  
  private func startTracking() {
    switchTrackingButton.setTitle("Stop Tracking", for: .normal)
    route?.map = nil
    route = RoutePolyline()
    routePath = GMSMutablePath()
    route?.map = mapView
    locationManager.startUpdatingLocation()
  }
  
  private func stopTracking() {
    switchTrackingButton.setTitle("Start Tracking", for: .normal)
    locationManager.stopUpdatingLocation()
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
