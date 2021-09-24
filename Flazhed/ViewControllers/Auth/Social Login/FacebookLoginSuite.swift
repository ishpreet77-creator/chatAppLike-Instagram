//
//  FacebookLoginSuite.swift
//  Demo
//
//  Created by ios on 17/05/19.
//

import FBSDKCoreKit
import FBSDKLoginKit

typealias FacebookSuiteSuccessClosure = (Bool, Any?) -> ()
typealias FacebookSuiteFailureClosure = (String, Error?) -> ()

let kFBName = "name"
let kFBID = "id"
let kFBEmail = "email"
let kFBImageUrl = "picture.type(large)"
let kFBUser_posts = "photos"
let kInstagram_basic = "instagram_basic"
let kBirthday = "birthday"
let kFBGender = "user_gender"

let kfeed = "feed.limit(3)"

//MARK:- Available read permissions
enum ReadPermission : String  {
    case  public_profile, email,user_photos//, public_actions, user_videos, user_photos
    
    static let allValues = [public_profile, email, user_photos]//,user_photos] // ,public_actions,user_videos,user_photos
    
    static func defaultPermissions() -> [String] {
        var permissions = [String]()
        
        for perm in ReadPermission.allValues {
            permissions.append(perm.rawValue)
        }
        
        return permissions
    }
}

//MARK:- Class
class FacebookLoginSuite {
    
    //MARK:- Variables
    var permissions : [String]
    
    var accessToken : AccessToken? {
        return AccessToken.current
    }
    
    private var fbLoginManager = LoginManager()
    private var graphConnection=GraphRequestConnection()
    
    //MARK:- Intializers
    init(permissions: [String]) {
        self.permissions = permissions
    }
    
    convenience init(){
        self.init(permissions:ReadPermission.defaultPermissions())
    
    }
    
    //MARK:- Account
    
    func hasLoggedIn() -> Bool {
        return AccessToken.current != nil
    }
    
    func logout() {
        if(hasLoggedIn()) {
            fbLoginManager.logOut()
        }
    }
    
    func signInWithController(controller : UIViewController!, success: @escaping FacebookSuiteSuccessClosure, error: @escaping FacebookSuiteFailureClosure) {
        if hasLoggedIn() {
            success(true,nil)
            return
        }
        
        //Request login
        Indicator.sharedInstance.hideIndicator()
      // fbLoginManager.loginBehavior = .browser
      //  fbLoginManager

        fbLoginManager.logIn(permissions: permissions, from: controller) { result, err in
            
            if err != nil {
                error(err!.localizedDescription,err)
                return
            }
            
            guard result?.isCancelled != true else {
                error("Operation Cancelled",err)
                return
            }
            
            self.userProfile(success: { (status, data) in
                success(status,data)
            }, error1: { (message, err) in
                error(message,err)
            })
            
        }
    }
    
    
    //MARK:- Graph Requests
    func userProfile(success: @escaping FacebookSuiteSuccessClosure, error1: @escaping FacebookSuiteFailureClosure) {
        
        guard hasLoggedIn() else {
            error1("Sign In Required", nil)
            return
        }
        Indicator.sharedInstance.showIndicator()
        //me
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"\(kFBName),\(kFBID),\(kFBEmail),\(kFBUser_posts),\(kFBImageUrl)"])
       //
        graphConnection.add(graphRequest, completionHandler: { (connection, result, err) -> Void in
            Indicator.sharedInstance.hideIndicator()
            if err != nil {
                error1((err?.localizedDescription)!, err)
                return
            }
           let userData = result as? Dictionary<String,AnyObject>
            print(userData)
            Indicator.sharedInstance.hideIndicator()
            success(true, userData)
        })
        self.graphConnection.start()
        
//        graphConnection.add(GraphRequest(graphPath: "/me", parameters: ["fields":"email"])) { httpResponse, result, error   in
//            if error != nil {
//                NSLog(error.debugDescription)
//                return
//            }
//
//            print(result)
//            // Handle vars
//            if let result = result as? [String:String],
//                let email: String = result["email"],
//                let fbId: String = result["id"] {
//
//                // internal usage of the email
//                //self.userService.loginWithFacebookMail(facebookMail: email)
//
//            }
//
//        }
    
        
//        graphConnection = graphRequest.start(completionHandler: { (connection, result, err) -> Void in
//            Indicator.sharedInstance.hideIndicator()
//            if err != nil {
//                error1((err?.localizedDescription)!, err)
//                return
//            }
//           let userData = result as? Dictionary<String,AnyObject>
//            print(userData)
//            let id = userData?[ApiKey.kId] as! String
//            self.requestWithPath(path: "/\(id)/photos") { (sucees, dic) in
//                print(dic)
//            } error: { (er, error) in
//                print(error)
//            }
//            self.requestWithPath(path: "/\(id)") { (sucees, dic) in
//                print(dic)
//            } error: { (er, error) in
//                print(error)
//            }
        //    success(true, userData)
      //  })
        
        let accessToken = AccessToken.current?.tokenString
            let params = ["access_token" : accessToken ?? ""]
        
        print("Facebook login token = \(accessToken)")
        let request = GraphRequest(graphPath: "albums", parameters: params, httpMethod: .get)

           request.start(completionHandler: { (test, result, error) in
               if(error == nil)
               {
                  print(result!)
               }
           })
        GraphRequest(graphPath: "/me/albums", parameters: ["fields":"id,name,user_photos"], httpMethod: HTTPMethod(rawValue: "GET")).start(completionHandler: {  (connection, result, error) in
print("result = ")
            
            

                print(result!)
        })
        
        let connection = GraphRequestConnection()

        connection.add(GraphRequest(graphPath: "/me/albums", parameters: ["fields":"id,name,user_photos"])) { httpResponse, result, error   in
            if error != nil {
                NSLog(error.debugDescription)
                return
            }
            print(result)

           

        }
    
        
        
//        self.requestWithPath(path: "photos") { (sucees, dic) in
//            print(dic)
//        } error: { (er, error) in
//            print(error)
//        }
        
       

    }
    
    
    //MARK:- Makes a GET request to specified path.
    func requestWithPath(path : String, success: @escaping FacebookSuiteSuccessClosure, error: @escaping FacebookSuiteFailureClosure) {
        
        guard hasLoggedIn() else {
            error("Sign In Required",nil)
            return
        }
        
        let graphRequest = GraphRequest(graphPath: path)
        
//        graphConnection = graphRequest.start(completionHandler: { (connection, result, err) -> Void in
//            if err != nil {
//                error((err?.localizedDescription)!,err)
//                return
//
//            }
//
//            success(true,result)
//        })
      
    }
    
    func cancelRequest() {
      //  graphConnection?.cancel()
       // graphConnection = nil
    }
    
    func resetFacebookAccessToken() {
        AccessToken.current = nil
    }
}
