//
//  Pins.swift
//  LookyLoos
//
//  Created by Joshua Hoyle on 6/8/21.
//

import Foundation
import MapKit

import UIKit
import MapKit
import Firebase
import FirebaseUI

class Pin {
    var latitude: Double
    var longitude: Double
    var evenTitle: String
    var eventSubtitle: String?
    
    init(latitude: Double, longitude: Double, eventTitle: String, eventSubtitle: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.evenTitle = eventTitle
        self.eventSubtitle = eventSubtitle
    }
}
