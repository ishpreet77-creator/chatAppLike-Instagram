//
//  SocketClassFile.swift
//  Stay Home
//
//  Created by GANESH on 04/06/20.
//  Copyright © 2020 Apptunix. All rights reserved.
//

import Foundation
import UIKit
import SocketIO
protocol SocketDataDelegates {
    func didReceiveData(data:[[String:Any]])
}

class SocketIOManager {
    
   
    var socket:SocketIOClient!
    var delegate : SocketDataDelegates?
    static let shared = SocketIOManager()
    
    let manager = SocketManager(socketURL: URL(string:SOCKET_URL)! ,config: [.log(true), .compress])


    init() {
        socket = manager.defaultSocket
       
    }
   
    func initializeSocket(){
        self.socket.on("connect"){ data, ack in
            print("socket connected")
           // self.openListener(jsonDict: [:])
           // self.getAllMessageInOnMethod()
            
        }
        self.socket.on("disconnect"){ data, ack in
            print("socket disconnect")
        }
        self.socket.on("connect_error"){ data, ack in
            print("socket connect_error")
        }
        self.socket.on("connect_timeout"){ data, ack in
            print("socket connect_timeout")
        }
        self.socket.connect()
    }
    
    
    //MARK:- Join the room
    
    
    func joinRoomForChat(joinRoomDict:[String:String])
    {
        if(self.socket.status == .connected)
        {

            self.socket.emit("join",joinRoomDict, completion: {
            
                            print("emit join ")
              //  self.getAllMessageInOnMethod()
                
                                })
        }
        else{
            print("Socket is not connected")
            self.socket.connect()
        }
    }
    //MARK:- send Chat Message the room
   // ,joinRoomDict:[String:String
    
    func sendChatMessage(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
              
                self.socket.emit("sendMessage",  MessageChatDict, completion: {

                    print("sendMessage \(MessageChatDict)")
                    //self.getAllMessageInOnMethod()
                })
        }
        else{
            print("Socket is not connected")
            self.socket.connect()
        }
    }
    
    
    
    //MARK:- get all message
    
    func getAllMessageInOnMethod()
    {
        
        self.socket.on("message", callback: { (data, error) in
            
            print("on method call \(error) = \(data)")
        })
    }
    
    
    
    
    func establishConnection(emitRequest:String,jsonDict:[String:Any]?,joinDict:[String:Any]?){
        if(self.socket.status == .connected)
        {

            self.socket.emit("join",joinDict!, completion: {

                            print("emit join ")
                self.openListener(jsonDict: jsonDict)
                        })
            self.socket.emit("sendMessage",  jsonDict!, completion: {

                print("sendMessage join ")
                self.openListener(jsonDict: jsonDict)
            })
                
//            }else{
//                self.socket.emit(emitRequest,notification, jsonString ?? [:])
//                openListener()
//            }
        }else{
            print("Socket is not connected")
            self.socket.connect()
        }
    }

    
    func socketOff(request:String){
        self.socket.off(request)
    }
    func openListener(jsonDict:[String:Any]?){
        //orderDetail
//        SocketIOManager.shared.socket.on("message") { (sendBookingDataArray, ack) in
//                   print(sendBookingDataArray.count)
//                   if let jsonData = sendBookingDataArray as? [[String:Any]] {
//
//                    if self.delegate != nil{
//                        self.delegate?.didReceiveData(data: jsonData)
//                      //  DataManager.userMesage="\(jsonData)"
//
//                        let alert = UIAlertController(title: "Alert", message: "\(jsonData)", preferredStyle: UIAlertController.Style.alert)
//                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
//                       // self.present(alert, animated: true, completion: nil)
//                    }
//
//                   }
//               }
        let dict = ["timezone":"Asia/Kolkata","chat_room_id":"602a90391d3d7a1155f970d4","to_user_id":"60251200705bae2c1379b1a4","message":"treywretr","from_user_id":"60223b17a3370b59d3869ad5","name" : "guig", "room":"602a90391d3d7a1155f970d4"]
        
        self.socket.on("message") { data, error in
                print("socket connected  on")
            
            print("Data in message = \(data)")
            //self.socket?.emit("sendMessage", jsonDict as! SocketData)
            }
    }
    
    func establishConnection(emitRequest:String,jsonString:[String:Any]?){
        if(self.socket.status == .connected){
               if jsonString == nil {
                self.socket.emit(emitRequest)
               }else{
                self.socket.emit(emitRequest, jsonString ?? [:])
                openListener(jsonDict: jsonString)
                   // let data =  self.socket.emitWithAck(emitRequest, jsonString!)
                   //print(data)
               }
           }else{
               print("Socket is not connected")
            self.socket.connect()
           }
       }
    
    
    func disconnectSocket(){
        if(self.socket.status == .connected){
            self.socket.disconnect()
        }
    }
    
    //MARK:- Listner
    
    
    
    
    
}




