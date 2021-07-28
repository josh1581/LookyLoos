//
//  MapviewBackup.swift
//  LookyLoos
//
//  Created by Joshua Hoyle on 6/4/21.
//
/*
 import UIKit
 import CoreLocation
 import Firebase
 import FirebaseUI
 import MapKit


 class MapViewController: UIViewController, MKMapViewDelegate {
     
     
     //MARK: - Outlets
     
     @IBOutlet weak var mapView: MKMapView!
     
     @IBOutlet weak var ambulanceButton: UIStackView!
     
     @IBOutlet weak var firetruckButton: UIStackView!
     
     @IBOutlet weak var policeButton: UIStackView!
     
     //MARK: - Properties
     let locationManager = CLLocationManager()
     
     var resultSearchController:UISearchController? = nil
     
     
     
     
     //MARK: - Lifecycle
     override func viewWillAppear(_ animated: Bool) {
         Auth.auth().addStateDidChangeListener { (auth, user) in
             if let user = user {
                 self.showUserInfo(user: user)
             } else {
                 self.showLoginVC()
             }
         }
     }
     
     
     
     override func viewDidLoad() {
         super.viewDidLoad()
         
         locationManager.delegate = self
         locationManager.requestLocation()
         locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.requestWhenInUseAuthorization()
     
         let locationSearchTable = storyboard!.instantiateViewController(identifier: "LocationSearchTable")
         resultSearchController = UISearchController(searchResultsController: locationSearchTable)
         resultSearchController?.searchResultsUpdater = (locationSearchTable as! UISearchResultsUpdating)
         
         let searchBar = resultSearchController!.searchBar
         searchBar.sizeToFit()
         searchBar.placeholder = "Where are we going?"
         navigationItem.titleView = resultSearchController?.searchBar
      
         
         resultSearchController?.hidesNavigationBarDuringPresentation = false
         resultSearchController?.dimsBackgroundDuringPresentation = true
         definesPresentationContext = true
         
         
         
     }
     
     //MARK: - Actions
     
    
     @IBAction func ambulanceButtonTapped(_ sender: Any) {
     }
     
     @IBAction func firetruckButtonTapped(_ sender: Any) {
     }
     
     
     @IBAction func policeButtonTapped(_ sender: Any) {
     }
     
     //MARK: - Functions
     func showUserInfo(user: User) {
         
     }
     
     
     func showLoginVC() {
         let authUI = FUIAuth.defaultAuthUI()
         let providers = [FUIEmailAuth()]
         authUI?.providers = providers
         let authViewController = authUI!.authViewController()
         self.present(authViewController, animated: true, completion: nil)
     }
     
     
     
     
 }//end of class
 //MARK: - Extension

 extension MapViewController: FUIAuthDelegate {
     func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
         guard error == nil else {
             return
         }
         if error != nil {
             return
         }
     }
     
     
 }//end of extension

 extension MapViewController : CLLocationManagerDelegate {
     
     func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
     }
     
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if status == .authorizedWhenInUse {
             locationManager.requestLocation()
         }
     }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         if let location = locations.first {
             let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
             let region = MKCoordinateRegion(center: location.coordinate, span: span)
             mapView.setRegion(region, animated: true)
         }
         
         if locations.first != nil {
             print("location:: (location)")
         }
         
     }
     
 }

*/
