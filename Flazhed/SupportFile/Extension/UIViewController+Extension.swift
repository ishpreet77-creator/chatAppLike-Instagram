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
        
        if kLoginSession.equalsIgnoreCase(string: message ?? "")
        {
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC
            destVC.type = .BlockReportError
            destVC.user_name=message ?? kError
            destVC.errorCode=401
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
        }
        else
        {
            let storyboard: UIStoryboard = UIStoryboard(name: "Chat", bundle: Bundle.main)
            let destVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAlertVC") as!  FeedbackAlertVC

            destVC.type = .BlockReportError
            destVC.user_name=message ?? kError
            destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

            self.present(destVC, animated: true, completion: nil)
        }

//
        
       
        
        
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
////MARK:- POPup delegate
//
//extension BaseVC:FeedbackAlertDelegate
//{
//    func FeedbackAlertOkFunc(name: String)
//    {
//    print("Name = \(name)")
//    }
//
//
//}
extension UIViewController {
    
    func showToast2(message : String, seconds: Double=30){
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.view.backgroundColor = .black
            alert.view.alpha = 0.5
            alert.view.layer.cornerRadius = 15
            self.present(alert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
                alert.dismiss(animated: true)
            }
        }
    
    func showToast3(message : String, font: UIFont = UIFont(name: "Averta-Regular", size: 14)!) {

        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.numberOfLines=0
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    
        func showToast(message: String) {
            let toastContainer = UIView(frame: CGRect())
            toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 20;
            toastContainer.clipsToBounds  =  true

            let toastLabel = UILabel(frame: CGRect())
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
           // toastLabel.font.withSize(12.0)
            toastLabel.font = UIFont(name: "Averta-Regular", size: 14)
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0

            toastContainer.addSubview(toastLabel)
            self.view.addSubview(toastContainer)

            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastContainer.translatesAutoresizingMaskIntoConstraints = false

            let centerX = NSLayoutConstraint(item: toastLabel, attribute: .centerX, relatedBy: .equal, toItem: toastContainer, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let lableBottom = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
            let lableTop = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
            toastContainer.addConstraints([centerX, lableBottom, lableTop])

            let containerCenterX = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let containerTrailing = NSLayoutConstraint(item: toastContainer, attribute: .width, relatedBy: .equal, toItem: toastLabel, attribute: .width, multiplier: 1.1, constant: 0)
            let containerBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
            self.view.addConstraints([containerCenterX,containerTrailing, containerBottom])

            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: {_ in
                    toastContainer.removeFromSuperview()
                })
            })
        }
 
    }
