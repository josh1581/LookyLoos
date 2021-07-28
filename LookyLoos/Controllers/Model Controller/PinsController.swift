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
    
    //MARK: - Shared Instance
    
    static let sharedInstance = PinsController()
    //MARK: - SOT
    
    var pins: [Pin] = []
    
    //MARK: - Properties
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    //MARK: - CRUD Functions
    
    func fetchPinsFromDB() {
        db.collection("pins").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                
            }
        }
    }
    
    
    
}
} //end of class

