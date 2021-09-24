//
//  NetworkInterface.swift
//
//  Created by Manish Gumbal on 08/08/18.
//  Copyright © 2018 Manish. All rights reserved.
//


/*
 STATUS CODES:
 200: Success (If request sucessfully done and data is also come in response)
 204: No Content (If request successfully done and no data is available for response)
 401: Unautorized (If token got expired)
 402: Block (If User blocked by admin)
 403: Delete (If User deleted by admin)
 406: Not Acceptable (If user is registered with the application but not verified)
 */

import Foundation
import Alamofire

//MARK: Call Backs
typealias JSONDictionary = [String:Any]
typealias JSONArray = [JSONDictionary]
typealias APIServiceSuccessCallback = ((Any?) -> ())
typealias APIServiceFailureCallback = ((NetworkErrorReason?, Error?) -> ())
typealias JSONArrayResponseCallback = ((JSONArray?) -> ())
typealias JSONDictionaryResponseCallback = ((JSONDictionary) -> ())
typealias responseCallBack = ((String?, Error?) -> ())
typealias responseWithData = ((String?, Error?, Any?) -> ())

//MARK: Constants
var myRequest: Alamofire.Request?
var ALAMOFIRE_TIMEOUT: Double = 250
let manager = Alamofire.Session.default

//MARK: Enums
public enum NetworkErrorReason: Error {
    case FailureErrorCode(code: Int, message: String)
    case InternetNotReachable
    case Other
}

struct Resource {
    let method: HTTPMethod
    let parameters: [String : Any]?
    let headers: [String:String]?
}

protocol APIService {
    var path: String { get }
    var resource: Resource { get }
}


class APIManager {
    
    //MARK: Variables
    static let kMessage = "message"
    static let NO_INTERNET = "No Internet"
    static let INTERNET_ERROR = "Your internet connection appears to be offline. Please try again."
    static let SERVER_ERROR = "Server Error"
    static let OTHER_ERROR = "Unable to connect with server. Please try again."
    static let ERROR = "Error"
    static let SOMETHING_WRONG = "Something went wrong. Please try again"
    static let UNAUTHORIZED = "Session expired. Please login again."
    
    class func errorForNetworkErrorReason(errorReason: NetworkErrorReason) -> (NSError) {
        var error: NSError!
        switch errorReason {
        case .InternetNotReachable:
            error = NSError(domain: APIManager.NO_INTERNET, code: -1, userInfo: [APIManager.kMessage : APIManager.INTERNET_ERROR])
        case let .FailureErrorCode(code, message):
            switch code {
            case 400, 401, 402, 403, 406:
                error = NSError(domain: APIManager.ERROR, code: code, userInfo: [APIManager.kMessage : message])
          
            case 500:
                error = NSError(domain: APIManager.SERVER_ERROR, code: code, userInfo: [APIManager.kMessage : SERVER_ERROR])
            default:
                error = NSError(domain: APIManager.OTHER_ERROR, code: code, userInfo: [APIManager.kMessage : message])
            }
        case .Other :
            error = NSError(domain: APIManager.OTHER_ERROR, code: 0, userInfo: [APIManager.kMessage : APIManager.SOMETHING_WRONG])
        }
        return error
    }
    
  
}

extension APIService {
    
    /*
     Method which needs to be called from the respective model class.
     - parameter successCallback:   successCallback with the JSON response.
     - parameter failureCallback:   failureCallback with ErrorReason, Error description and Error.
     */
    
    
    //MARK: Request Method to Send Request
    func request(showIndiacter:Bool=true,isJsonRequest: Bool = false, success: @escaping APIServiceSuccessCallback, failure: @escaping APIServiceFailureCallback) {
        if isJsonRequest
        {
            self.jsonRequest(showIndiacter:showIndiacter,jsonSuccess: { (responseSuccess) in
                success(responseSuccess)
            }, jsonFailure: { (errorReason, error) in
                Indicator.sharedInstance.hideIndicator()
                failure(errorReason, error)
            })
        }
        else {
            self.requestNormal(showIndiacter:showIndiacter,normalSuccess: { (responseSuccess) in
                success(responseSuccess)
            }, normalFailure: { (errorReason, error) in
                Indicator.sharedInstance.hideIndicator()

                failure(errorReason, error)
            })
        }
    }
    

    
    func request(mediaDict:[String: Data]? = nil, mediaArray:[Data]? = nil, mediaName: String? = nil, success:  @escaping APIServiceSuccessCallback, failure: @escaping APIServiceFailureCallback) {

        self.showIndicator() //Show Indicator
        self.showRequest() //Show Request in Console

        //Set Data
        let urlRequest = createMultipartRequest(mediaDict: mediaDict, mediaArray: mediaArray, mediaName: mediaName)

        //Create Request
        AF.upload((urlRequest?.1)!, with: (urlRequest?.0)!).uploadProgress(closure: { (progress) in
            //print(progress.localizedDescription ?? "0")
            //let dict = Int(progress.localizedDescription ?? "0")
            print("Progress: %d",progress.fractionCompleted)
            let dictValue = ["value": progress.fractionCompleted]
        }).responseJSON(completionHandler: { (response) in

            //Handle Indicators
            Indicator.sharedInstance.hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            myRequest = nil

            //Show Response Details
            print("*** API RESPONSE START ***")
            print("\(response))")
            print("*** API RESPONSE END ***")

            //Handle Response
            self.handleResponse(response: response, responseSuccess: { (responseSuccess) in
                success(responseSuccess)
            }, responseFailure: { (errorReason, error) in
                failure(errorReason, error)
                Indicator.sharedInstance.hideIndicator()

            })
        })
    }
    
    //MARK: JSON REUQEST
    private func jsonRequest(showIndiacter:Bool=true,jsonSuccess: @escaping APIServiceSuccessCallback, jsonFailure: @escaping APIServiceFailureCallback) {
        do {
            
            print("Show indicator := \(showIndiacter)")
//            if
//            {
//
//            }
//            else
//           {
//            self.showIndicator()
//           }
//
            if showIndiacter
            {
                self.showIndicator()
            }
            //Show Indicator
            self.showRequest() //Show Request in Console
            
            //Set Path
            
         //   let url = path+(userId ?? "")
            
            var request = URLRequest(url: URL(string: path)!)
            
            //Set HTTP Method
            request.httpMethod = resource.method.rawValue
            
            //Set Headers
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if resource.headers != nil {
                for (key, value) in resource.headers! {
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }
            
            //Set Parameteres
            if resource.parameters != nil {
                request.httpBody = try! JSONSerialization.data(withJSONObject: resource.parameters ?? "")
            }
            
            //Create Request
            
            // let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = ALAMOFIRE_TIMEOUT
            myRequest = manager.request(request)
                .responseJSON { response in
                    
                    //Handle Indicators
                    Indicator.sharedInstance.hideIndicator()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    myRequest = nil
                    
                    //Show Response Details
                    print("*** API RESPONSE START ***")
                    print("\(response))")
                    print("*** API RESPONSE END ***")
                    
                    //Handle Response
                    self.handleResponse(response: response, responseSuccess: { (success) in
                        jsonSuccess(success)
                    }, responseFailure: { (errorReason, error) in
                        jsonFailure(errorReason, error)
                    })
            }
        }
    }
    
    //MARK: NORMAL REUQEST
    private func requestNormal(showIndiacter:Bool=true,normalSuccess: @escaping APIServiceSuccessCallback, normalFailure: @escaping APIServiceFailureCallback) {

        if showIndiacter
        {
        self.showIndicator()
        }//Show Indicator
        self.showRequest() //Show Request Details in console
        
        //Headers
        var headers = HTTPHeaders()
        if resource.headers != nil {
            for (key, value) in resource.headers! {
                headers.add(name: key, value: value)
            }
        }

        //Create Request
        AF.request(path, method: resource.method, parameters: resource.parameters, encoding: URLEncoding.queryString, headers: headers).validate().responseJSON(completionHandler: { (response) in
            
            //Handle Indicators
            Indicator.sharedInstance.hideIndicator()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            //Handle Response
            self.handleResponse(response: response, responseSuccess: { (success) in
                normalSuccess(success)
            }, responseFailure: { (errorReason, error) in
                normalFailure(errorReason, error)
                Indicator.sharedInstance.hideIndicator()

            })
        })
    }
    
    //MARK: MULTIPART REQUEST
    private func createMultipartRequest(mediaDict: [String: Data]?, mediaArray: [Data]?, mediaName: String?) -> (URLRequestConvertible, Data)? {
        
        // Create URL Request
        var mutableURLRequest = URLRequest(url: NSURL(string: path)! as URL)
        mutableURLRequest.httpMethod = resource.method.rawValue
        let boundaryConstant = "myRpostmandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        var uploadData = Data()
        
        // Set Parameters
        if resource.parameters != nil {
            for (key, value) in resource.parameters! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        //Set Headers
        if resource.headers != nil {
            for (key, value) in resource.headers! {
                mutableURLRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        //For Dictionary
        if mediaDict != nil {
            for (key, value) in mediaDict! {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).\(value.mimeType)\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(value)
                uploadData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        //For Arrays
        if let array = mediaArray, array.count > 0 {
            for data in array {
                uploadData.append("--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(mediaName!)[]\"; filename=\"\(mediaName!).\(data.mimeType)\"\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append(data)
                uploadData.append("\r\n".data(using: String.Encoding.utf8)!)
            }
        }
        
        uploadData.append("--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        do {
            let result = try Alamofire.URLEncoding.default.encode(mutableURLRequest, with: nil)
            return (result, uploadData)
        }
        catch _ {
        }
        return nil
    }
    
    
    //MARK: With file REUQEST
    
    
    func uploadApi(image : [Data], data: JSONDictionary,AudioData:Data)
    {
        Indicator.sharedInstance.showIndicator()
        
        let urlString =  BASE_URL.appending("complete-profile")
        
        let headers: HTTPHeaders = [kAccept:  kApplicationJson,kAuthorization: "Bearer \(DataManager.accessToken)"]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in data {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)}
                    
                    if let temp = value as? Int {
                        multipartFormData.append("(temp)".data(using: .utf8)!, withName: key)
                        
                    }
                    
                    if let temp = value as? NSArray
                    {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                if  !AudioData.isEmpty
                {
                    multipartFormData.append(AudioData, withName: "voice", fileName: "voice.mp3", mimeType: "mp3/mp4")
                }
                
                for img in image
                {
                    multipartFormData.append(img, withName: "images", fileName: "images.png", mimeType: "jpeg/jpg/png")
                }
                
            },
            to: urlString, //URL Here
            method: .post,
            headers: headers)
            .responseJSON { (resp) in
                
                print("resp is \(resp)")
                if let status = (resp.value as? NSDictionary)?.value(forKey: "status") as? String
                {
                    
                    if status == "success"
                    {
                        Indicator.sharedInstance.hideIndicator()
                   
                    }
                    else
                    {
                        Indicator.sharedInstance.hideIndicator()
                       
                    }
                    
                }
                else
                {
                    Indicator.sharedInstance.hideIndicator()
                }
                
            }
    }
    
    //MARK: Response Handling
    
    func handleResponse(response: AFDataResponse<Any>, responseSuccess: @escaping APIServiceSuccessCallback, responseFailure: @escaping APIServiceFailureCallback) {
        
//        //Show Response Details
//        print("*** API RESPONSE START ***")
//        print("\(response))")
//        print("*** API RESPONSE END ***")
//
        
        let code  = response.response?.statusCode ?? 0
        print("*** API RESPONSE CODE: \(code) ***")
        switch code {
        case 200:
            responseSuccess(response.value as AnyObject)
        default:
            self.handleError(response: response, error: response.error, callback: responseFailure)
        }
    }
    
    //MARK: Error Handling
    private func handleError(response: AFDataResponse<Any>?, error: Error?, callback:APIServiceFailureCallback) {
        
        if let errorCode = response?.response?.statusCode {
            guard let responseJSON = self.JSONFromData(data: (response?.data)! as NSData) else {
                callback(NetworkErrorReason.FailureErrorCode(code: errorCode, message:""), error)
                print("Couldn't read the data")
                return
            }
            let message = (responseJSON as? NSDictionary)?["message"] as? String ?? "Something went wrong. Please try again."
            callback(NetworkErrorReason.FailureErrorCode(code: errorCode, message: message), error)
        }
        else {
            let customError = NSError(domain: "Network Error", code: (error! as NSError).code, userInfo: (error! as NSError).userInfo)
            if let errorCode = response?.error?.localizedDescription , errorCode == "The Internet connection appears to be offline." {
                callback(NetworkErrorReason.InternetNotReachable, customError)
            }
            else {
                callback(NetworkErrorReason.Other, customError)
            }
        }
    }
    
    //MARK: Show Console Data
    func showRequest() {
        print("*** API REQUEST START ***")
        print("Request URL: \(path)")
        print("Request HTTP Method: \(resource.method)")
        print("Request Parameters: \(String(describing: resource.parameters)))")
        print("Request Headers: \(String(describing: resource.headers)))")
        print("*** API REQUEST END ***")
    }
    
    func showIndicator() {
        if Indicator.isEnabledIndicator
        {
            Indicator.sharedInstance.showIndicator()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    //MARK: Data Handling
    private func JSONFromData(data: NSData) -> Any? { //Convert Data to JSON
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    private func nsdataFromJSON(json: AnyObject) -> NSData?{     // Convert from JSON to nsdata
        
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
}

//MARK: Indicator Class
public class Indicator {
    
    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()
    static var isEnabledIndicator = true
    static var isUserInteractionEnabled = true
    
    private init() {
        blurImg.frame = UIScreen.main.bounds
        if Indicator.isUserInteractionEnabled {
            blurImg.backgroundColor = UIColor.black
            blurImg.isUserInteractionEnabled = true
            blurImg.alpha = 0.3
        }
        indicator.style = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    }
    
    func showIndicator(){
        DispatchQueue.main.async( execute: {
            if Indicator.isUserInteractionEnabled {
                UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            }
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
        })
    }
    
    func hideIndicator(){
        DispatchQueue.main.async( execute: {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        })
        self.blurImg.removeFromSuperview()
        self.indicator.removeFromSuperview()
    }
    func hideImageLoader(VC:UIViewController?){
        VC?.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: Get Mime Type
extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "jpeg",
        0x89 : "png",
        0x47 : "gif",
        0x49 : "tiff",
        0x4D : "tiff",
        0x66 : "3gp",
        0x52 : "wav",
        0x00 : "mov",
        0x25 : "pdf",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "mov"
    }
}

struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
