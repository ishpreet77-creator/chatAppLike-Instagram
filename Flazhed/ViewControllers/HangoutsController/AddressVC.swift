//
//  AddressVC.swift
//  Flazhed
//
//  Created by IOS22 on 08/01/21.
//

import UIKit
import IQKeyboardManagerSwift
import MapKit
import CoreLocation
import GoogleMaps
import GooglePlaces

protocol SelectedAddressDelegate {
    func selectedAddress(address:String,lat:String,long:String)
}


class AddressVC: BaseVC {
    private var tableView: UITableView!
    @IBOutlet weak var heightConst: NSLayoutConstraint!
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var buttomConst: NSLayoutConstraint!
    
    @IBOutlet weak var txtAddress: UITextField!
   // @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewMap: GMSMapView!
    let locationManager = CLLocationManager()
    var delegate:SelectedAddressDelegate?
    
    var hangoutLat = ""
    var hangoutLong = ""
    var marker = GMSMarker()
    var camera = GMSCameraPosition.camera(withLatitude: CURRENTLAT, longitude: CURRENTLONG, zoom: 15.0)
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
      var searchController: UISearchController?
      var resultView: UITextView?

    var placesClient:GMSPlacesClient?
    
    var oldLat = ""
    var oldLong = ""
    var oldAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.mapSetUp()
        self.heightConst.constant = NAVIHEIGHT
        self.topConst.constant = STATUSBARHEIGHT
    
    
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }

        locationManager.delegate=self
        

      
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.txtAddress.delegate = self
     
        txtAddress.becomeFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
         

    }
    
    @IBAction func backBtnAct(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func searchAddressAct(_ sender: UIButton)
    {

        
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        autocompleteController.secondaryTextColor = .darkGray
        autocompleteController.primaryTextColor = .lightGray
        autocompleteController.primaryTextHighlightColor = .black
        autocompleteController.tableCellBackgroundColor = .white
        autocompleteController.tableCellSeparatorColor = .lightGray
        
        

           // Display the autocomplete view controller.
           present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func NextAct(_ sender: UIButton)
    {
        
        delegate?.selectedAddress(address: self.txtAddress.text!, lat: self.hangoutLat, long: self.hangoutLong)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {

        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
       
        if self.getDeviceModel() == "iPhone 6"
        {
            buttomConst.constant = keyboardHeight+0
        }
        else
        {
            self.buttomConst.constant = keyboardHeight+0+20
        }
    }

    @objc
    func keyboardWillDisappear(notification: NSNotification?) {
        buttomConst.constant = 0
    }
   

    func mapSetUp()
    {
        if self.oldLat != "" && self.oldLong != ""
        {
           
            
            let camera = GMSCameraPosition.camera(withLatitude: Double(self.oldLat) ?? CURRENTLAT, longitude:  Double(self.oldLong) ?? CURRENTLONG, zoom: 15.0)
                viewMap.camera = camera
               
                marker.position = CLLocationCoordinate2D(latitude: Double(self.oldLat) ?? CURRENTLAT, longitude: Double(self.oldLong) ?? CURRENTLONG)
                marker.isDraggable = true

               viewMap.camera=camera
         viewMap.settings.myLocationButton = true
         viewMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         viewMap.isMyLocationEnabled = true
         viewMap.delegate=self
         viewMap.mapType = .normal
            self.txtAddress.text=self.oldAddress
         marker.map = viewMap
        }
        else
        {
            let camera = GMSCameraPosition.camera(withLatitude: CURRENTLAT, longitude: CURRENTLONG, zoom: 15.0)
                viewMap.camera = camera
               
                marker.position = CLLocationCoordinate2D(latitude: CURRENTLAT, longitude: CURRENTLONG)
                marker.isDraggable = true

               viewMap.camera=camera
         viewMap.settings.myLocationButton = true
         viewMap.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         viewMap.isMyLocationEnabled = true
         viewMap.delegate=self
         viewMap.mapType = .normal
      
         marker.map = viewMap
        }

        
    }
    
    //Mark: Reverse GeoCoding
       
    func reverseGeocoding(lat:Double,Long:Double) {
           let geocoder = GMSGeocoder()
           let coordinate = CLLocationCoordinate2DMake(lat,Long)
           
           var currentAddress = String()
           
           geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
               if let address = response?.firstResult() {
                   let lines = address.lines! as [String]
                   
                   print("Response is = \(address)")
                   print("Response is = \(lines)")
                   
                   currentAddress = lines.joined(separator: "\n")
                   
               }

           }
       }
}
extension AddressVC:CLLocationManagerDelegate
{

    func SearchedAddress(address: String, lat: String, long: String) {
        self.hangoutLat=lat
        self.hangoutLong=long
        self.txtAddress.text=address
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate

        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        CURRENTLAT=locValue.latitude
        CURRENTLONG=locValue.longitude
        }

}
extension AddressVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddressVC:GMSMapViewDelegate
{
    func mapView (_ mapView: GMSMapView, didEndDragging didEndDraggingMarker: GMSMarker) {

          print("Drag ended!")
          print("Update Marker data if stored somewhere.")

      }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        marker.position = position.target
        
        self.updateLocationoordinates(coordinates: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let lat = coordinate.latitude
        let long = coordinate.longitude

        print("Latitude: \(lat), Longitude: \(long)")
        
        self.updateLocationoordinates(coordinates: coordinate)
        
        ReverseGeocoding.geocode(latitude: coordinate.latitude, longitude: coordinate.longitude, completion: { (placeMark, completeAddress, error) in
                    if let placeMark = placeMark, let completeAddress = completeAddress
                     {
                           print("Address = \(completeAddress)")
                        self.hangoutLat="\(coordinate.latitude)"
                        self.hangoutLong="\(coordinate.longitude)"
                        self.txtAddress.text = completeAddress
 
                        
                       } else {
                       
                        print(error)
                       }
        
               
                })

    }
    
  
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition)
    {
    
        print(position)
        ReverseGeocoding.geocode(latitude: position.target.latitude, longitude: position.target.longitude, completion: { (placeMark, completeAddress, error) in
                    if let placeMark = placeMark, let completeAddress = completeAddress
                     {
                           print("Address = \(completeAddress)")
                        self.hangoutLat="\(position.target.latitude)"
                        self.hangoutLong="\(position.target.longitude)"
                        self.txtAddress.text = completeAddress
 
                        
                       } else {
                       
                        print(error)
                       }
        
               
                })
    }
    
    
    func updateLocationoordinates(coordinates:CLLocationCoordinate2D) {
            if marker == nil
            {
                marker = GMSMarker()
                marker.position = coordinates
         
                marker.map = viewMap
                marker.appearAnimation = .none
            }
            else
            {
                CATransaction.begin()
                CATransaction.setAnimationDuration(0.5)
                marker.position =  coordinates
                CATransaction.commit()
            }
        }
 
  
}
extension AddressVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(String(describing: place.name))")
    print("Place ID: \(String(describing: place.placeID))")
    print("Place attributions: \(String(describing: place.attributions))")
    self.txtAddress.text=place.formattedAddress ?? ""
    CURRENTLAT=place.coordinate.latitude
    CURRENTLONG=place.coordinate.longitude
    self.marker.position = place.coordinate
    let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15.0)
        viewMap.camera = camera
       
        marker.position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
       

       viewMap.camera=camera
    
    self.updateLocationoordinates(coordinates: place.coordinate)

    
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }

}
// Handle the user's selection.
extension AddressVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(String(describing: place.name))")
        print("Place address: \(String(describing: place.formattedAddress))")
        print("Place attributions: \(String(describing: place.attributions))")
      }

      func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                             didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
      }

      // Turn the network activity indicator on and off again.
      func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }

      func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
      }

}

