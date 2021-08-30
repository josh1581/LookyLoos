//
//  PinsController.swift
//  LookyLoos
//
//  Created by Joshua Hoyle on 6/8/21.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import MapKit

class PinsController {
    
  
    
    
    //MARK: - SOT
    
    
    
    //MARK: - Properties
    let shared = PinsController()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    static var userUID = ""
    
    //MARK: - CRUD Functions
    
    static func savePinToDB(eventTitle: String, eventSubtitle: String, latitude: Double, longitude: Double) {
        let newPinRef = Firestore.firestore().collection("pins").document()
        newPinRef.setData([
            "eventTitle": eventTitle,
            "eventSubtitle": eventSubtitle,
            "latitude": latitude,
            "longitude": longitude,
            "lastupdated": FieldValue.serverTimestamp()
        ])
        
    }
    
    static func saveReportToDB(reportTitle: String, reportSubtitle: String, reportText: String) {
        
        let newReportRef = Firestore.firestore().collection("reports").document(userUID)
        newReportRef.setData([
            "reportTitle": reportTitle,
            "reportSubtitle": reportSubtitle,
            "reportText": reportText,
            //"lastUpdated": FieldValue.serverTimestamp()
        ])
    }
    
    
    
    

} //end of class

