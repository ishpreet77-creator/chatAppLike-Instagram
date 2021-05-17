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
    func NavigateToPayment(transId:String)
}


enum productIDs: String {
    
    //MARK:- For regret swipe
    
    case swipeMonthly = "com.swipe.monthly"
    case swipeHalfYear = "com.swipe.halfyear"
    case swipeYearly = "com.swipe.yearly"
    
    //MARK:- For shake
    case shakeOne = "com.shake.one"
    case shakeThree = "com.shake.three"
    case shakeFive = "com.shake.five"
    
    //MARK:- For prolong chat
    
    case prolongMonthly = "com.prolong.monthly"
    case ProlongHalfyearly = "com.prolong.halfyearly"
    case prolongYearly = "com.prolong.yearly"

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
    
    
    
    
    var transaction_id=""
    var amount=0
    var subscription_type=""
    var name=""
    var extra_shake=0
  
    

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
     
        let products : Set = [productIDs.swipeMonthly.rawValue,productIDs.swipeHalfYear.rawValue,productIDs.swipeYearly.rawValue,productIDs.shakeOne.rawValue,productIDs.shakeThree.rawValue,productIDs.shakeFive.rawValue,productIDs.prolongMonthly.rawValue,productIDs.ProlongHalfyearly.rawValue,productIDs.prolongYearly.rawValue]
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
                print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
            }
        } else {
            print("No products found")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchase(product:productIDs){
        print("profuct id = \(products)")
        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first else {
            Indicator.sharedInstance.hideIndicator()
            return
        }
        let payment = SKPayment(product: productToPurchase)
       paymentQueue.add(payment)
    }
    
    func restoreProducts(){
        if (SKPaymentQueue.canMakePayments()) {
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().restoreCompletedTransactions()
        } else {
            // show error
            Indicator.sharedInstance.hideIndicator()

            print("Can not restore")
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
            print(trans.transactionState)
            print(trans.transactionState.transactionStatus(), trans.payment.productIdentifier)
            switch trans.transactionState {
            case .purchasing, .deferred: break // do nothing
            case .restored:
                DataManager.purchasePlan = true
                let p = trans.payment
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
                //appDelegate.loadScanSideMenu()
                Indicator.sharedInstance.hideIndicator()

            case .purchased:
                Indicator.sharedInstance.hideIndicator()
                DataManager.purchasePlan = true
                let p = trans.payment
                transactionId = trans.transactionIdentifier ?? ""
                print("Transaction id:= ",transactionId)
                
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
                
              transaction_id = transactionId
                
                NotificationCenter.default.post(name: Notification.Name("PaymentDoneNoti"), object: nil, userInfo: ["transactionId":transactionId])

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
                DataManager.purchasePlan = false
                Indicator.sharedInstance.hideIndicator()
                queue.finishTransaction(trans)
               
//
            default:
                Indicator.sharedInstance.hideIndicator()
                break
            }
        }
    }
    
}
    
    // MARK:-  Api Call for BuyPlan
 extension IAPHandler{
    func validatePurchase(success: @escaping (Bool)->()) {
        Indicator.sharedInstance.showIndicator()
        if let receiptURL = Bundle.main.appStoreReceiptURL {
            if let receipt = NSData(contentsOf: receiptURL) {
                var params = JSONDictionary()
                params[kReceiptData] = receipt.base64EncodedString(options: [])
                params[kPassword] = "53e3309868ee4460a594ce006f0e3792"//"5143a3d41ac740699dd9502f7d79ad3c"
                let appleServer = receiptURL.lastPathComponent == "sandboxReceipt" ? "sandbox" : "buy"
                let url = "https://\(appleServer).itunes.apple.com/verifyReceipt"
                var request = URLRequest(url: URL(string: url)!)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                }
                catch let error {
                    print(error.localizedDescription)
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
                                    print(responseDict)
                                    if let receiptArray = responseDict[self.kLatestReceiptInfo] as? JSONArray {
                                        
                                        if let receiptDict = receiptArray.last {
                                            
                                            print("Payment receipt = \(receiptDict)")
                                            
                                            let expirationDateMS = receiptDict[self.kExpirationDateMS] as? String ?? "0.0"
                                            if Int64(Double(expirationDateMS)!) >= Date().millisecondsSince1970 {
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
                                    print("bad json")
                                }
                            }
                            catch let error as NSError {
                                DispatchQueue.main.async {
                                    Indicator.sharedInstance.hideIndicator()
                                    success(false)
                                }
                                print(error)
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
