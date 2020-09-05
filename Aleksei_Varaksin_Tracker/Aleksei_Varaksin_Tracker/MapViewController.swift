//
//  MapViewController.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 05.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    func configureMap() {
        mapView.delegate = self
        mapView.mapType = .hybrid
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
    }
    
    @IBAction func startTracking(_ sender: UIBarButtonItem) {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager?.startUpdatingLocation()
            case .notDetermined, .restricted, .denied:
                showErrorAlertController()
            @unknown default:
                break
        }
    }
    
    @IBAction func stopTracking(_ sender: UIBarButtonItem) {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager?.stopUpdatingLocation()
            case .notDetermined, .restricted, .denied:
                showErrorAlertController()
            @unknown default:
                break
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func showErrorAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Please enable geolocation for the correct work of the application", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else { return }
        let camera = GMSCameraPosition(target: coordinates, zoom: 15)
        let marker = GMSMarker(position: coordinates)
        marker.map = mapView
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showErrorAlertController()
    }
}
