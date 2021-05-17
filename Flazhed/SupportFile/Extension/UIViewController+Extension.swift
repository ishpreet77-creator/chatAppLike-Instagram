//
//  UIViewController+Extension.swift
//  Flazhed
//
//  Created by IOS22 on 18/01/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import AudioToolbox
extension UIViewController{

    //MARK:- User of alert/action sheet
    public func openAlert(title: String?,
                          message: String?,
                          alertStyle:UIAlertController.Style?,
                          actionTitles:[String]?,
                          actionStyles:[UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?]){

        let alertController = UIAlertController(title: title, message: message, preferredStyle: alertStyle ?? .alert)
        if actionTitles?.count == 0
        {
            let action = UIAlertAction(title: kAlert, style: .default, handler: actions[0])
            alertController.addAction(action)
        }
        else
        {
            for(index, indexTitle) in actionTitles!.enumerated()
            {
                let action = UIAlertAction(title: indexTitle, style: actionStyles[index], handler: actions[index])
                alertController.addAction(action)
            }
        }
        
        self.present(alertController, animated: true)
    }
    
    public func openSimpleAlert(message: String?)
    {

        let alertController = UIAlertController(title:kAlert, message: message, preferredStyle: .alert)
       
            let action = UIAlertAction(title: kOk, style: .default, handler: nil)
            alertController.addAction(action)
        self.present(alertController, animated: true)
    }
}


protocol LocationUpdateProtocol {
    func locationDidUpdateToLocation(lat:Double,long:Double)
}

let kLocationDidChangeNotification = "LocationDidChangeNotification"

class UserLocationManager: NSObject, CLLocationManagerDelegate {

static let SharedManager = UserLocationManager()

fileprivate var locationManager = CLLocationManager()

var currentLocation : CLLocation?

var delegate : LocationUpdateProtocol!

fileprivate override init ()
{
    super.init()
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
   
    locationManager.requestAlwaysAuthorization()
    self.locationManager.startUpdatingLocation()
}

// MARK: - CLLocationManagerDelegate
func locationManager(manager: CLLocationManager,didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
    currentLocation = newLocation
    let userInfo : NSDictionary = ["location" : currentLocation!]


    let lat = currentLocation?.coordinate.latitude ?? 30.921
    let long = currentLocation?.coordinate.longitude ?? 76.0909
    
    DispatchQueue.main.async() { () -> Void in
        self.delegate.locationDidUpdateToLocation(lat:lat, long:long)
        
        NotificationCenter.default.post(name: Notification.Name(kLocationDidChangeNotification), object: self, userInfo: userInfo as [NSObject : AnyObject])
    }
}

}
extension UIDevice {
    static func vibrate() {
           AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
       }
}
extension Date {

    func dateFormatWithSuffix() -> String {
        return "dd'\(self.daySuffix())' MMMM"
    }

    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}
