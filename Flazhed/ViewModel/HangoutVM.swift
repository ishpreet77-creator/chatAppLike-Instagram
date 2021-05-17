//
//  HangoutVM.swift
//  Flazhed
//
//  Created by IOS32 on 12/02/21.
//

import Foundation

class HangoutVM {
    
    static var shared = HangoutVM()

    var lastPage = 0
    var page = 0
    var HangoutDataArray:[HangoutDataModel] = []
    
    var hangoutOtherDataArray:[HangoutListDM] = []
    var Pagination_Details:Pagination_Details_Model?
    
    var hangoutDetail:HangoutListDM?
    
    private init(){}

    func callApiCreateHangout(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiCreateHangout(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiGetMyHangout(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiGetMyHangout(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.HangoutDataArray.removeAll()
           self.parseHangoutData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    func callApiDeleteHangout(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiDeleteHangout(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
           
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    
    func callApiGetOtherHangout(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiGetOtherHangout(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
            self.hangoutOtherDataArray.removeAll()
           self.parseOtherHangoutData(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
    func callApiGetHangoutDetail(data: JSONDictionary,response: @escaping responseCallBack)
    {
        APIManager.callApiGetHangoutDetail(data:data,successCallback: { (responseDict) in
         
            let message = responseDict[ApiKey.kMessage] as? String ?? kSomethingWentWrong
         
           self.parseHangoutDetails(response:responseDict)
            response(message, nil)
        }) { (errorReason, error) in
            response(nil, APIManager.errorForNetworkErrorReason(errorReason: errorReason!))
        }
    }
    
}
extension APIManager {

    class func callApiCreateHangout(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHangout.createHangout(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiGetMyHangout(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHangout.myHangouts(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    class func callApiDeleteHangout(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHangout.deleteHangout(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }
    
    
    
    class func callApiGetOtherHangout(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHangout.otherHangouts(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }

    
    class func callApiGetHangoutDetail(data: JSONDictionary,successCallback: @escaping JSONDictionaryResponseCallback,failureCallback: @escaping APIServiceFailureCallback){
        APIServicesHangout.detailHangout(data: data).request(isJsonRequest: true,success:{ (response) in
            if let responseDict = response as? JSONDictionary {
                print(responseDict)

                successCallback(responseDict)
            } else {
                successCallback([:])
            }
        }, failure: failureCallback)
    }

}
//MARK:- Parsing the data
extension HangoutVM {
    
    func parseHangoutData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let hangout_listing = data[ApiKey.kHangout_listing] as? JSONArray
            {
                    for hangout in hangout_listing
                    {
                    let post = HangoutDataModel(detail: hangout)
                     self.HangoutDataArray.append(post)
                    }
            }
    
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
            }
        }
    }
    
    func parseOtherHangoutData(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
            if let hangout_listing = data[ApiKey.kHangout_listing] as? JSONArray
            {
               
                    for hangout in hangout_listing
                    {
                    let post = HangoutListDM(detail: hangout)
                     self.hangoutOtherDataArray.append(post)
                    }
     
            
            }
            if let Pagination_details = data[ApiKey.kPagination_details] as? JSONDictionary
            {
                let details = Pagination_Details_Model(detail: Pagination_details)
                self.Pagination_Details = details
            }
        }
    }
    
    func parseHangoutDetails(response: JSONDictionary){
        if let data = response[ApiKey.kData] as? JSONDictionary
        {
    
          //  if let hangoutDetail = data[ApiKey.kHangout_details] as? JSONDictionary
          //  {
               
                let post = HangoutListDM(detail: data)
                self.hangoutDetail=post
      
            //}
        }
    }

}
