//
//  PickAddressVC.swift
//  xeviet
//
//  Created by Admin on 7/6/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftMessages
import ActionSheetPicker_3_0
import RxCocoa
import RxSwift

class PickAddressVC: UIViewController, GMSAutocompleteViewControllerDelegate {

    var didCompletePicked:((_ place: GMSPlace) -> ())!

    override func viewDidLoad() {
        super.viewDidLoad()
        let autocompleteController = GMSAutocompleteViewController()
             // setup textColor for SearchBar textfield
             UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
             autocompleteController.delegate = self
             
             
             // Specify the place data types to return.
             let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))!
             autocompleteController.placeFields = fields
             
             // Specify a filter.
             let filter = GMSAutocompleteFilter()
             filter.type = .noFilter
             autocompleteController.autocompleteFilter = filter
             
             // Display the autocomplete view controller.
             present(autocompleteController, animated: true, completion: nil)
        // Do any additional setup after loading the view.
    }


     // Handle the user's selection.
        func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
            didCompletePicked(place)
            self.navigationController?.presentingViewController!.dismiss(animated: true, completion: nil)
        }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
          // TODO: handle the error.
          print("Error: ", error.localizedDescription)
        self.navigationController?.presentingViewController!.dismiss(animated: true, completion: nil)
      }
      
      // User canceled the operation.
      func wasCancelled(_ viewController: GMSAutocompleteViewController) {
          self.navigationController?.presentingViewController!.dismiss(animated: true, completion: nil)
      }
      
      // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
          UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
      
      func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
          UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
