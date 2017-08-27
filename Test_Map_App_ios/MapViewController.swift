//
//  MapViewController.swift
//  Test_Map_App_ios
//
//  Created by PeCheRukiN on 25.08.17.
//  Copyright © 2017 PeCheRukiN. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, YMKMapImageBuilderDelegate {
    
    @IBOutlet weak var mapView: YMKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var reusablePoint: MapPointAnnotation?
    var adressesDataArray: [AdressData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupMapView()
        setupBlurView()
        setupTableView()
    }
    

    func setupMapView() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.showTraffic = false
        self.mapView.setCenter(YMKMapCoordinateMake(55.764231, 37.561723), atZoomLevel: 13, animated: true)
    }
    
    func setupSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Введите адрес для поиска"
    }
    
    func setupBlurView() {
        blurView.isHidden = true
        blurView.backgroundColor = UIColor.black
        blurView.alpha = 0
    }
    
    func setupTableView()  {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isHidden = true
        self.tableView.tableFooterView = UIView()
    }
    
    func configureReusablePoint() {
        if reusablePoint == nil {
            self.reusablePoint = MapPointAnnotation()
            self.mapView.addAnnotation(reusablePoint)
            self.mapView.selectedAnnotation = reusablePoint
        }
    }
    
    func setSearchTo(_ value: Bool) {
        if value {
            self.searchBar.becomeFirstResponder()
            self.searchBar.setShowsCancelButton(true, animated: true)
            self.blurView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.blurView.alpha = 0.4
                self.tableView.isHidden = false
            }
        } else {
            self.searchBar.text = ""
            self.searchBar.resignFirstResponder()
            self.searchBar.setShowsCancelButton(false, animated: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.blurView.alpha = 0
            }) { (completion) in
                self.blurView.isHidden = true
                self.tableView.isHidden = true
                self.adressesDataArray = []
                self.tableView.reloadData()
            }
        }
    }
}

extension MapViewController: YMKMapViewDelegate {
    
    func mapView(_ mapView: YMKMapView!, gotSingleTapAt coordinate: YMKMapCoordinate) {
        let longitude = coordinate.longitude
        let latitude = coordinate.latitude
        
        self.configureReusablePoint()
        
        self.reusablePoint?.coordinate = coordinate
        self.reusablePoint?.title = " "
        
        ServiceLocator.shared().networkService.getSingleAdress(for: longitude, latitude: latitude) { (adress) in
            self.reusablePoint?.title = "\(adress)"
            self.mapView.scroll(to: self.reusablePoint, animated: true)
        }
    }
    
    func mapView(_ view: YMKMapView!, calloutViewFor annotation: YMKAnnotation!) -> YMKCalloutView! {
        let identifier = "pointCallout"
        let callout: YMKDefaultCalloutView = mapView.dequeueReusableCalloutView(withIdentifier: identifier) as? YMKDefaultCalloutView ?? YMKDefaultCalloutView(reuseIdentifier: identifier)
        callout.annotation = annotation
        
        return callout
    }
    
    func mapView(_ mapView: YMKMapView!, viewFor annotation: YMKAnnotation!) -> YMKAnnotationView! {
        let identifier = "pointAnnotation"
        let view: YMKPinAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? YMKPinAnnotationView ?? YMKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        
        return view
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        setSearchTo(true)
        
        let latitude = self.mapView.userLocation.coordinate().latitude
        let longitude = self.mapView.userLocation.coordinate().longitude
        
        ServiceLocator.shared().networkService.getNearestAddresses(for: longitude, latitude: latitude) { (adressesData) in
            self.adressesDataArray = adressesData
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ServiceLocator.shared().networkService.getAdressesBundle(for: searchText) { (adressesData) in
            self.adressesDataArray = adressesData
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        setSearchTo(false)
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adressesDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdressCell") as! AdressCell
        cell.adressNameLabel.text = self.adressesDataArray[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let longitude = self.adressesDataArray[indexPath.row].longitude
        let latitude = self.adressesDataArray[indexPath.row].latitude
        let adressName = self.adressesDataArray[indexPath.row].name
        
        self.configureReusablePoint()
        self.reusablePoint?.coordinate = YMKMapCoordinateMake(latitude, longitude)
        self.reusablePoint?.title = adressName
        self.setSearchTo(false)
        self.mapView.scroll(to: self.reusablePoint, animated: true)
    }
}
