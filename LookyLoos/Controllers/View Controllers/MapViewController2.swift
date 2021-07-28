//
//  MapViewController.swift
//  LookyLoos
//
//  Created by Joshua Hoyle on 6/1/21.
//
/*
import UIKit
import CoreLocation
import Firebase
import FirebaseUI
import MapKit


class MapViewController: UIViewController {
    let locationManager = CLLocationManager()

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
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //MARK: - Actions
    //@IBAction func loginButtonTapped(_ sender: Any) {
   //     let authUI = FUIAuth.defaultAuthUI()
   //     guard authUI != nil else {
    //       return
     //   }
      // authUI?.delegate = self
      //  let authViewController = authUI!.authViewController()
       // present(authViewController, animated: true, completion: nil)
   // }
    
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
        
    
}
 
*/
