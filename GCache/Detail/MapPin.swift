//
//  MapPin.swift
//  GCache
//
//  Created by Chris Woodard on 9/17/17.
//  Copyright © 2017 UsefulSoft. All rights reserved.
//

import UIKit
import MapKit

class MapPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    override init() {
        self.coordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        self.title = nil
        self.subtitle = nil
    }
    
    convenience init(coord:CLLocationCoordinate2D, title:String, subtitle:String) {
        self.init()
        self.coordinate = coord
        self.title = title
        self.subtitle = subtitle
    }
}
