//
//  PurchasePlan.swift
//  Flazhed
//
//  Created by IOS32 on 11/02/21.
//

import Foundation
import UIKit
import StoreKit

protocol NavigateToPaymentPopup{
    func NavigateToPayment(name:String,transactionId:String?)
}


enum productIDs: String {
    
    //    //MARK: - For regret swipe
    //
    //    case swipeMonthly = "com.swipe.monthly"
    //    case swipeHalfYear = "com.swipe.halfyear"
    //    case swipeYearly = "com.swipe.yearly"
    //
    //    //MARK: - For shake
    //    case shakeOne = "com.shake.one"
    //    case shakeThree = "com.shake.three"
    //    case shakeFive = "com.shake.five"
    //
    //    //MARK: - For prolong chat
    //
    //    case prolongMonthly = "com.prolong.monthly"
    //    case ProlongHalfyearly = "com.prolong.halfyearly"
    //    case prolongYearly = "com.prolong.yearly"
    
    case kPlus =  "com.general.plus"
    case kGold =  "com.general.gold"
    case kPlatinum =  "com.general.platinum"
    case kChat =  "com.prolong.chat"
    
    
    
    /*
     

    //MARK: - For regret swipe
    
    case swipeMonthly = "com.swipe.monthly"
    case swipeHalfYear = "com.swipe.halfyear"
    case swipeYearly = "com.swipe.yearly"
    
    //MARK: - For shake
    case shakeOne = "com.shake.1"
    case shakeThree = "com.shake.3"
    case shakeFive = "com.shake.5"
    
    //MARK: - For prolong chat
    
    case prolongNewChanges = "com.prolong.chat"
    
    case prolongMonthly = "com.prolong.icebreaker"//"com.prolong.monthly"
    case ProlongHalfyearly = "com.prolong.romantique"//"com.prolong.halfyearly"
    case prolongYearly = "com.prolong.connoisseur"//"com.prolong.yearly"
    
    
    //MARK: - For Hangout
    
    case hangoutPlus = "com.hangout.plus" 
    case hangoutGold = "com.hangout.gold"
    case hangoutPlatinum = "com.hangout.platinum"
    
    //MARK: - For Chat
    
    case chatPlus = "com.chat.plus"
    case chatGold = "com.chat.gold"
    case chatPlatinum = "com.chat.platinum"
    
    //MARK: - For Story
    
    case storyPlus = "com.story.plus"
    case storyGold = "com.story.gold"
    case storyPlatinum = "com.story.platinum"
    
    //MARK: - For General
    
    case shakePlus = "com.general.plus"
    case shakeGold = "com.general.gold"
    case shakePlatinum = "com.general.platinum"
    
    */

}

class IAPHandler:BaseVC {
    
    static let shared = IAPHandler()
    var delegate:NavigateToPaymentPopup?
    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    var request: SKProductsRequest?
    var products = [SKProduct]()
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    let paymentQueue = SKPaymentQueue.default()
    var comeFrom = String()
    
    let kReceiptData = "receipt-data"
    let kPassword = "password"
    let kLatestReceiptInfo = "latest_receipt_info"
    let kExpirationDateMS = "expires_date_ms"
 
    
    var transactionId = ""
    var planId = ""
    var planAmount = ""
    var sortedArray = JSONArray()
    
    
    
    var transaction_id=""
    var amount=0
    var subscription_type=""
    var name=""
    var extra_shake=0
    var fromScreen = kRegret
    
    var hanoutPriceArray:[premiumModel] = []
    var chatPriceArray:[premiumModel] = []
    var storyPriceArray:[premiumModel] = []
    var shakePriceArray:[premiumModel] = []
    var prolongPriceArray:[premiumModel] = []
    
    //    private override init() {
    //           super.init()
    //       }
    //
    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }
}
extension IAPHandler: SKProductsRequestDelegate, SKRequestDelegate{
    
    func getProducts() {
        
        let products : Set = [productIDs.kPlus.rawValue,productIDs.kGold.rawValue,productIDs.kPlatinum.rawValue,productIDs.kChat.rawValue]
        
        
//        self.hanoutPriceArray.removeAll()
//        self.chatPriceArray.removeAll()
//        self.storyPriceArray.removeAll()
//        self.shakePriceArray.removeAll()
//        
        /*
        let products : Set = [productIDs.hangoutPlus.rawValue,
                              productIDs.hangoutGold.rawValue,
                              productIDs.hangoutPlatinum.rawValue,
                              
                              productIDs.chatPlus.rawValue,
                              productIDs.chatGold.rawValue,
                              productIDs.chatPlatinum.rawValue,
                              
                              productIDs.storyPlus.rawValue,
                              productIDs.storyGold.rawValue,
                              productIDs.storyPlatinum.rawValue,
                              
                              productIDs.shakePlus.rawValue,
                              productIDs.shakeGold.rawValue,
                              productIDs.shakePlatinum.rawValue,
                              
                              productIDs.swipeMonthly.rawValue,productIDs.swipeHalfYear.rawValue,productIDs.swipeYearly.rawValue,productIDs.shakeOne.rawValue,productIDs.shakeThree.rawValue,productIDs.shakeFive.rawValue,productIDs.prolongMonthly.rawValue,productIDs.ProlongHalfyearly.rawValue,productIDs.prolongYearly.rawValue,
                              productIDs.prolongNewChanges.rawValue
        ]
        */
        
        let request = SKProductsRequest(productIdentifiers: products)
        
        // Set self as the its delegate.
        request.delegate = self
        
        // Make the request.
        request.start()
        paymentQueue.add(self)
        
    
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        let count : Int = response.products.count
        if (count>0) {
            let validProducts = response.products
            self.products = validProducts
            for p in validProducts {
                if p.productIdentifier == productIDs.kPlus.rawValue || p.productIdentifier == productIDs.kGold.rawValue || p.productIdentifier == productIDs.kPlatinum.rawValue
                {
                    let model = premiumModel(type: p.productIdentifier, price: self.priceOf(product: p))
                    hanoutPriceArray.append(model)//.append(self.priceOf(product: p))
                }
                else if p.productIdentifier == productIDs.kChat.rawValue// || p.productIdentifier == productIDs.chatGold.rawValue || p.productIdentifier == productIDs.chatPlatinum.rawValue
                {
                    let model = premiumModel(type: p.productIdentifier, price: self.priceOf(product: p))
                    prolongPriceArray.append(model)
                }
                /*
                else if p.productIdentifier == productIDs.storyPlus.rawValue || p.productIdentifier == productIDs.storyGold.rawValue || p.productIdentifier == productIDs.storyPlatinum.rawValue
                {
                    let model = premiumModel(type: p.productIdentifier, price: self.priceOf(product: p))
                    storyPriceArray.append(model)
                }
                else if p.productIdentifier == productIDs.shakePlus.rawValue || p.productIdentifier == productIDs.shakeGold.rawValue || p.productIdentifier == productIDs.shakePlatinum.rawValue
                {
                    let model = premiumModel(type: p.productIdentifier, price: self.priceOf(product: p))
                    shakePriceArray.append(model)
                }
                
                else if p.productIdentifier == productIDs.prolongMonthly.rawValue || p.productIdentifier == productIDs.ProlongHalfyearly.rawValue || p.productIdentifier == productIDs.prolongYearly.rawValue
                {
                    let model = premiumModel(type: p.productIdentifier, price: self.priceOf(product: p))
                    prolongPriceArray.append(model)
                }
                */
                
              
               debugPrint("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
                
               
                debugPrint("product price: \(self.priceOf(product: p))")
                
                
            }
          //  debugPrint("product Count: \(self.products)")
        } else {
            debugPrint("No products found")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        debugPrint(error.localizedDescription)
    }
    
    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchase(product:productIDs,fromScreen:String=kRegret){
        self.fromScreen=fromScreen
        debugPrint("profuct id = \(products)")
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {
            Indicator.sharedInstance.hideIndicator()
            return
        }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restoreProducts(fromScreen:String=kRegret){
        self.fromScreen=fromScreen
        Indicator.sharedInstance.showIndicator()
        if (SKPaymentQueue.canMakePayments()) {
           
            debugPrint("restore purchase canMakePayments")
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            // show error
            Indicator.sharedInstance.hideIndicator()
            self.delegate?.NavigateToPayment(name: kHideIndicator, transactionId: kEmptyString)
            debugPrint("restore purchase  Can not restore")
        }
    }
    
    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }
}
extension IAPHandler.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}
// let products : Set = [productIDs.swipeMonthly.rawValue,productIDs.swipeHalfYear.rawValue,productIDs.swipeYearly.rawValue,productIDs.shakeOne.rawValue,productIDs.shakeThree.rawValue,productIDs.shakeFive.rawValue,productIDs.prolongMonthly.rawValue,productIDs.ProlongHalfyearly.rawValue,productIDs.prolongYearly.rawValue]
extension IAPHandler: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for trans in transactions{
            debugPrint(trans.transactionState)
            debugPrint(trans.transactionState.transactionStatus(), trans.payment.productIdentifier)
            switch trans.transactionState {
            case .purchasing, .deferred: break // do nothing
            case .restored:
               
                let p = trans.payment
                
                if p.productIdentifier == productIDs.kPlus.rawValue
                {
                    queue.finishTransaction(trans)
                }
                else if p.productIdentifier == productIDs.kGold.rawValue {
                    queue.finishTransaction(trans)
                }
                else if p.productIdentifier == productIDs.kPlatinum.rawValue {
                    queue.finishTransaction(trans)
                }
                else if p.productIdentifier == productIDs.kChat.rawValue {
                    queue.finishTransaction(trans)
                }
                /*
                if p.productIdentifier == productIDs.swipeMonthly.rawValue
                {
                    // ... do stuff ...
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.swipeHalfYear.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.swipeYearly.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.shakeOne.rawValue {
                    queue.finishTransaction(trans)
                }
                
                else if p.productIdentifier == productIDs.shakeThree.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.shakeFive.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.prolongMonthly.rawValue {
                    queue.finishTransaction(trans)
                }
                
                else if p.productIdentifier == productIDs.ProlongHalfyearly.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.prolongYearly.rawValue {
                    queue.finishTransaction(trans)
                }
                
                //MARK: - New Premium
                
                
                else if p.productIdentifier == productIDs.hangoutPlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.hangoutGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.hangoutPlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.chatPlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.chatGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.chatPlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.storyPlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.storyGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.storyPlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.shakePlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.shakeGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.shakePlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.prolongNewChanges.rawValue {
                    queue.finishTransaction(trans)
                }
                */
                
                
                
        
                transactionId = trans.transactionIdentifier ?? ""
                debugPrint("Transaction id:= ",transactionId)
                
                if self.fromScreen == kPremium
                {
                    NotificationCenter.default.post(name: Notification.Name("PaymentPremiumNoti"), object: nil, userInfo: ["transactionId":transactionId])
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name("PaymentDoneNoti"), object: nil, userInfo: ["transactionId":transactionId])
                }
                self.delegate?.NavigateToPayment(name: kSucess, transactionId: transactionId)
                //self.delegate?.NavigateToPayment(name: kHideIndicator)
                //appDelegate.loadScanSideMenu()
                Indicator.sharedInstance.hideIndicator()
                
            case .purchased:
                Indicator.sharedInstance.hideIndicator()
              
                let p = trans.payment
                transactionId = trans.transactionIdentifier ?? ""
                debugPrint("Transaction id:= ",transactionId)
                if p.productIdentifier == productIDs.kPlus.rawValue
                {
                    queue.finishTransaction(trans)
                }
                else if p.productIdentifier == productIDs.kGold.rawValue {
                    queue.finishTransaction(trans)
                }
                else if p.productIdentifier == productIDs.kPlatinum.rawValue {
                    queue.finishTransaction(trans)
                }
                else if p.productIdentifier == productIDs.kChat.rawValue {
                    queue.finishTransaction(trans)
                }
                /*
                if p.productIdentifier == productIDs.swipeMonthly.rawValue {
                    // ... do stuff ...
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.swipeHalfYear.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.swipeYearly.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.shakeOne.rawValue {
                    queue.finishTransaction(trans)
                }
                
                else if p.productIdentifier == productIDs.shakeThree.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.shakeFive.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.prolongMonthly.rawValue {
                    queue.finishTransaction(trans)
                }
                
                else if p.productIdentifier == productIDs.ProlongHalfyearly.rawValue {
                    queue.finishTransaction(trans)
                } else if p.productIdentifier == productIDs.prolongYearly.rawValue {
                    queue.finishTransaction(trans)
                }
                
                //MARK: - New Premium
                
                
                else if p.productIdentifier == productIDs.hangoutPlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.hangoutGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.hangoutPlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.chatPlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.chatGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.chatPlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.storyPlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.storyGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.storyPlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.shakePlus.rawValue {
                   queue.finishTransaction(trans)
               }
               else if p.productIdentifier == productIDs.shakeGold.rawValue {
                   queue.finishTransaction(trans)
               } else if p.productIdentifier == productIDs.shakePlatinum.rawValue {
                   queue.finishTransaction(trans)
               }
                
                else if p.productIdentifier == productIDs.prolongNewChanges.rawValue {
                    queue.finishTransaction(trans)
                }
                */
                
                transaction_id = transactionId
                
                if self.fromScreen == kPremium
                {
                    NotificationCenter.default.post(name: Notification.Name("PaymentPremiumNoti"), object: nil, userInfo: ["transactionId":transactionId])
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name("PaymentDoneNoti"), object: nil, userInfo: ["transactionId":transactionId])
                }
                self.delegate?.NavigateToPayment(name: kSucess, transactionId: transactionId)
                
            //amount = p.
            
            
            //                if DataManager.comeFromScreen == "Home" {
            //                    appDelegate.loadSideMenu()
            //
            //                }else{
            //                appDelegate.loadScanSideMenu()
            //                }
            
            //                let storyBoard = UIStoryboard(name: kAccount, bundle: nil)
            //
            //                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsVC
            //                vc.comeFromVerify=true
            //                self.navigationController?.pushViewController(vc, animated: false)
            
            
            //
            case .failed:
                
                Indicator.sharedInstance.hideIndicator()
                queue.finishTransaction(trans)
                self.delegate?.NavigateToPayment(name: kHideIndicator,transactionId:kEmptyString)
                
            //
            default:
                Indicator.sharedInstance.hideIndicator()
                self.delegate?.NavigateToPayment(name: kHideIndicator,transactionId:kEmptyString)
                break
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        Indicator.sharedInstance.hideIndicator()
        self.delegate?.NavigateToPayment(name: kHideIndicator,transactionId:kEmptyString)

    }

    
}

// MARK:-  Api Call for BuyPlan
extension IAPHandler{
    func validatePurchase2(success: @escaping (Bool)->()) {
        Indicator.sharedInstance.showIndicator()
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            if let receipt = NSData(contentsOf: receiptURL) {
                var params = JSONDictionary()
                params[kReceiptData] = receipt.base64EncodedString(options: []) // 7c033ad3578c461c962f46d6ae7a77af
                params[kPassword] = "7c033ad3578c461c962f46d6ae7a77af"//"5143a3d41ac740699dd9502f7d79ad3c"
                let appleServer = receiptURL.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
                let url = "https://\(appleServer).itunes.apple.com/verifyReceipt"
                var request = URLRequest(url: URL(string: url)!)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                }
                catch let error {
                    debugPrint(error.localizedDescription)
                }
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil {
                        DispatchQueue.main.async {
                            Indicator.sharedInstance.hideIndicator()
                            success(false)
                        }
                    }
                    else {
                        if let data = data {
                            do {
                                if let responseDict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? JSONDictionary {
                                    debugPrint(responseDict)
                                    if let receiptArray = responseDict[self.kLatestReceiptInfo] as? JSONArray {
                                        
                                        if let receiptDict = receiptArray.last {
                                            
                                            debugPrint("Payment receipt = \(receiptDict)")
                                            
                                            let expirationDateMS = receiptDict[self.kExpirationDateMS] as? String ?? "0.0"
                                            if Int64(Double(expirationDateMS)!) >= Date().millisecondsSince1970
                                            {
                                                DispatchQueue.main.async {
                                                    Indicator.sharedInstance.hideIndicator()
                                                    success(true)
                                                }
                                            }
                                            else {
                                                DispatchQueue.main.async {
                                                    Indicator.sharedInstance.hideIndicator()
                                                    success(false)
                                                }
                                            }
                                        }
                                    }
                                    else {
                                        DispatchQueue.main.async {
                                            Indicator.sharedInstance.hideIndicator()
                                            success(false)
                                        }
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        Indicator.sharedInstance.hideIndicator()
                                        success(false)
                                    }
                                    debugPrint("bad json")
                                }
                            }
                            catch let error as NSError {
                                DispatchQueue.main.async {
                                    Indicator.sharedInstance.hideIndicator()
                                    success(false)
                                }
                                debugPrint(error)
                            }
                            
                        }
                    }
                }
                task.resume()
            }
            else {
                Indicator.sharedInstance.hideIndicator()
                success(false)
            }
        }
        else {
            Indicator.sharedInstance.hideIndicator()
            success(false)
        }
    }
}


// MARK:- Api Call for BuyPlan
extension IAPHandler
{
    func validatePurchase(success: @escaping (Bool,String)->())
    {
        Indicator.sharedInstance.showIndicator()
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            if let receipt = NSData(contentsOf: receiptURL) {
                var params = JSONDictionary()
                params[kReceiptData] = receipt.base64EncodedString(options: [])
                params[kPassword] = "7c033ad3578c461c962f46d6ae7a77af"
                let appleServer = receiptURL.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
                let url = "https://\(appleServer).itunes.apple.com/verifyReceipt"
                var request = URLRequest(url: URL(string: url)!)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                }
                catch let error {
                    debugPrint(error.localizedDescription)
                }
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    if error != nil {
                        DispatchQueue.main.async {
                            Indicator.sharedInstance.hideIndicator()
                            success(false, kEmptyString)
                        }
                    }
                    else {
                        if let data = data {
                            do {
                                if let responseDict = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? JSONDictionary {
                                    debugPrint(responseDict)
                                    if let receiptArray = responseDict[self.kLatestReceiptInfo] as? JSONArray {
                                        for dataArray in receiptArray
                                        {
                                            let purchasedate = dataArray["purchase_date"] as? String
                                            self.sortedArray = receiptArray.sorted(by: {(data1,data2) in
                                                let date1 = purchasedate
                                                let date2 = purchasedate
                                                if let d1 = date1 ,let d2 = date2{
                                                    return (d1.compare(d2) == .orderedDescending)
                                                }
                                                return false
                                            })
                                        }
                                        if let receiptDict = self.sortedArray.first {
                                            debugPrint("latest receiptDict = \(receiptDict)")
                                            
                                            let expirationDateMS = receiptDict[self.kExpirationDateMS] as? String ?? "0.0"
                                            
                                            let product_id = receiptDict[kProduct_id] as? String ?? kEmptyString
                                            
                                            if Int64(Double(expirationDateMS)!) >= Date().millisecondsSince1970 {
                                                DispatchQueue.main.async
                                                {
                                                    Indicator.sharedInstance.hideIndicator()
                                                    success(true, product_id)
                                                }
                                            }
                                            else {
                                                DispatchQueue.main.async {
                                                    Indicator.sharedInstance.hideIndicator()
                                                    success(false, kEmptyString)
                                                }
                                            }
                                        }
                                        // }
                                    }
                                    else {
                                        DispatchQueue.main.async {
                                            Indicator.sharedInstance.hideIndicator()
                                            success(false, kEmptyString)
                                        }
                                    }
                                }
                                else {
                                    DispatchQueue.main.async {
                                        Indicator.sharedInstance.hideIndicator()
                                        success(false, kEmptyString)
                                    }
                                    debugPrint("bad json")
                                }
                            }
                            catch let error as NSError {
                                DispatchQueue.main.async {
                                    Indicator.sharedInstance.hideIndicator()
                                    success(false, kEmptyString)
                                }
                                debugPrint(error)
                            }
                        }
                    }
                }
                task.resume()
            }
            else {
                Indicator.sharedInstance.hideIndicator()
                success(false, kEmptyString)
            }
        }
        else {
            Indicator.sharedInstance.hideIndicator()
            success(false, kEmptyString)
        }
    }
}


extension SKPaymentTransactionState{
    func transactionStatus() -> String{
        switch self {
        case .deferred:
            return "deferred"
        case .failed:
            return "failed"
        case .purchasing:
            return "restored"
        case .purchased:
            return "purchased"
        case .restored:
            return "restored"
        default:
            return "default"
        }
    }
}


//MARK: Alert Methods
extension IAPHandler {
    func showAlert(title: String? = "Alert", message: String?, otherButtons: [String:((UIAlertAction)-> ())]? = nil, cancelTitle: String = "OK", cancelAction: ((UIAlertAction)-> ())? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if otherButtons != nil {
            for key in otherButtons!.keys {
                alert.addAction(UIAlertAction(title: key, style: .default, handler: otherButtons![key]))
            }
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: cancelAction))
        //  UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func priceOf(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
       numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price) ?? kEmptyString
    }
}

//MARK: Date
extension Date {
    //    var millisecondsSince1970: Double {
    //        return self.timeIntervalSince1970 * 1000.0
    //    }
    
    func dateByAddingDays(inDays:NSInteger)->Date {
        return Calendar.current.date(byAdding: .day, value: inDays, to: self)!
    }
    
    
}

// MARK:- Extension Api Calls
extension IAPHandler
{
    
    func updatePaymentApi(data:JSONDictionary)
    {
        AccountVM.shared.callApiUpdatePayment(data: data, response: { (message, error) in
            
            if error != nil
            {
                self.showErrorMessage(error: error)
            }
            else{
                
                //                let storyBoard = UIStoryboard(name: kAccount, bundle: nil)
                //
                //                let vc = storyBoard.instantiateViewController(withIdentifier: "AccountsVC") as! AccountsVC
                //                vc.comeFromVerify=true
                //                self.navigationController?.pushViewController(vc, animated: false)
                
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
            
        })
    }
}


struct premiumModel
{
    var type:String?
    var price:String?
    
}
