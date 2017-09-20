//
//  CachedItemDetailViewController.swift
//  GCache
//
//  Created by Chris Woodard on 9/13/17.
//  Copyright © 2017 UsefulSoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

import GeoCache

class CachedItemDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager:CLLocationManager? = nil
    var geocoder:CLGeocoder? = nil
    var locPin:MapPin? = nil
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var itemId:Int64? = nil
    var gc:GeoCache? = nil
    
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemNotesField: UITextView!
    @IBOutlet weak var itemStreetField: UITextField!
    @IBOutlet weak var itemCityField: UITextField!
    @IBOutlet weak var itemStateField: UITextField!
    @IBOutlet weak var itemCountryField: UITextField!
    @IBOutlet weak var itemLocationMap: MKMapView!
    
    @IBAction func saveItem(_ sender: Any) {
        var dict:[String:Any] = [:]
        dict["Name"] = self.itemNameField.text
        dict["Street"] = self.itemStreetField.text
        dict["City"] = self.itemCityField.text
        dict["State"] = self.itemStateField.text
        dict["Country"] = self.itemCountryField.text
        dict["Lat"] = self.latitude
        dict["Lon"] = self.longitude
        dict["Timestamp"] = Date()
        var result:CacheStatus? = CacheStatus.NoError
        if let theItemId = self.itemId {
            result = self.gc?.update(locationId: theItemId, info: dict)
        }
        else {
            result = self.gc?.cache(loc: dict)
        }
        
        if result != CacheStatus.NoError {
            //display alert
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureMap(lat:Double, lon:Double) {
        self.latitude = lat
        self.longitude = lon
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let mapRegion = MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.itemLocationMap.setRegion(mapRegion, animated: true)
        if nil == self.locPin {
            self.locPin = MapPin()
        }
        self.itemLocationMap.removeAnnotation(self.locPin!)
        self.locPin?.coordinate = coord
        self.locPin?.title = self.itemNameField.text
        self.locPin?.subtitle = ""
        self.itemLocationMap.addAnnotation(self.locPin!)
    }
    
    @IBAction func geocode(_ sender: Any) {
        
        let streetStr = self.itemStreetField.text ?? ""
        let cityStr = self.itemCityField.text ?? ""
        let stateStr = self.itemStateField.text ?? ""
        let countryStr = self.itemCountryField.text ?? ""
        
        self.geocoder?.geocodeAddressString( "\(streetStr) \(cityStr) \(stateStr) \(countryStr)", completionHandler: { (placemarks, err) in
                if let gotPlacemarks = placemarks {
                    let firstPlacemark = gotPlacemarks[0]
                    let region = firstPlacemark.region as! CLCircularRegion
                    self.configureMap(lat: region.center.latitude, lon: region.center.longitude)
                }
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gc = GeoCache.sharedCache(options: [:])
        self.geocoder = CLGeocoder()
        
        if let theItemId = self.itemId {
            if let theItem = self.gc?.cachedLocation(theItemId) {
                self.itemNameField.text = theItem["Name"] as? String
                self.itemNotesField.text = theItem["Notes"] as? String
                self.itemStreetField.text = theItem["Street"] as? String
                self.itemCityField.text = theItem["City"] as? String
                self.itemStateField.text = theItem["State"] as? String
                self.itemCountryField.text = theItem["Country"] as? String
                if let lat = theItem["Lat"] as? Double,
                    let lon = theItem["Lon"] as? Double {
                    self.configureMap(lat: lat, lon: lon)
                }
            }
        }
        else {
                self.itemNameField.text = ""
                self.itemNotesField.text = ""
                self.itemStreetField.text = ""
                self.itemCityField.text = ""
                self.itemStateField.text = ""
                self.itemCountryField.text = ""
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Location Manager Delegates
    
    //MARK: - MapView Delegates
    
    //MARK: - TextField Delegates
    
    //MARK: - TextView Delegates
    
}
