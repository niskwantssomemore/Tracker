//
//  MapViewController.swift
//  Aleksei_Varaksin_Tracker
//
//  Created by Aleksei Niskarav on 05.09.2020.
//  Copyright © 2020 Aleksei Niskarav. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet var startTrackingButton: UIButton!
    
    private let locationManager = LocationManager.instance
    private let disposeBag = DisposeBag()
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
        if (routePath != nil) {
            loadPreviousRoutes()
        }
    }
    
    func configureMap() {
        mapView.delegate = self
        mapView.mapType = .hybrid
    }
    
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                self?.mapView.animate(to: GMSCameraPosition(target: location.coordinate, zoom: 15))
        }
        .disposed(by: disposeBag)
    }
    
    func configureRoute() {
        route?.map = nil
        route = GMSPolyline()
        route?.strokeWidth = 2
        route?.map = mapView
    }
    
    func loadPreviousRoutes() {
        configureRoute()
        route?.strokeColor = .green
        route?.path = routePath
        guard let setBounds = routePath else { return }
        let bounds = GMSCoordinateBounds(path: setBounds)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    @IBAction func startTracking(_ sender: Any) {
        if (startTrackingButton.title(for: .normal) == "Stop tracking") {
            locationManager.stopUpdatingLocation()
            DispatchQueue.global().async { [weak self] in
              guard let routePath = self?.routePath else { return }
              RealmService.instance.saveRoute(routePath)
            }
            startTrackingButton.setTitle("Start tracking", for: .normal)
        }
        else
        {
            configureRoute()
            route?.strokeColor = .red
            routePath = GMSMutablePath()
            switch CLLocationManager.authorizationStatus() {
                case .authorizedAlways, .authorizedWhenInUse:
                    startTrackingButton.setTitle("Stop tracking", for: .normal)
                    locationManager.startUpdatingLocation()
                case .notDetermined, .restricted, .denied:
                    showErrorLocationAlertController()
                @unknown default:
                    break
            }
        }
    }
    
    @IBAction func showPreviousRoutes(_ sender: Any) {
        if (startTrackingButton.title(for: .normal) == "Stop tracking") {
            showErrorPreviousRoutesAlertController()
        }
        else {
            performSegue(withIdentifier: "toRoutesTableViewControllerSegue", sender: nil)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate, GMSMapViewDelegate {
    
    func showErrorLocationAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Please enable geolocation for the correct work of the application", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorPreviousRoutesAlertController() {
        let alertController = UIAlertController(title: "Error", message: "Please stop tracking to view previous routes", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.first?.coordinate else { return }
        let camera = GMSCameraPosition(target: coordinates, zoom: 15)
        routePath?.add(coordinates)
        route?.path = routePath
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showErrorLocationAlertController()
    }
}
