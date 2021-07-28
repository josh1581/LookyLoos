//
//  LocationSearchTableViewController.swift
//  LookyLoos
//
//  Created by Joshua Hoyle on 6/3/21.
//

import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController  {
    
    //MARK: - Properties
    //var handleMapSearchDelegate:HandleMapSearch? = nil
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    
    
   
    
    
    
    
    //MARK: - Functions
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : " "
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? "," : " "
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : " "
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            selectedItem.subThoroughfare ?? " ",
            firstSpace,
            selectedItem.thoroughfare ?? " ",
            comma,
            selectedItem.locality ?? " ",
            secondSpace,
            selectedItem.administrativeArea ?? " "
        )
        return addressLine
    }
    
}//end of class

extension LocationSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
       // request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    
}// end of extension

extension LocationSearchTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text=selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        print(parseAddress(selectedItem: selectedItem))
        return cell
        
    }
}





