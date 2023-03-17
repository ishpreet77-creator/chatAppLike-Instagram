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
    
    var isSocketConnected=false
    let manager = SocketManager(socketURL: URL(string:SOCKET_URL)! ,config: [.log(true), .compress])


    init() {
        socket = manager.defaultSocket
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
   
    func initializeSocket(){
        self.socket.on("connect"){ data, ack in
            debugPrint("socket connected")
           // self.openListener(jsonDict: [:])
           // self.getAllMessageInOnMethod()
            self.isSocketConnected=true
        }
        self.socket.on("disconnect"){ data, ack in
            debugPrint("socket disconnect")
            self.isSocketConnected=false
        }
        self.socket.on("connect_error"){ data, ack in
            debugPrint("socket connect_error")
        }
        self.socket.on("connect_timeout"){ data, ack in
            debugPrint("socket connect_timeout")
        }
        self.socket.connect()
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .cellular:
            debugPrint("Message Network available via Cellular Data.")
            self.socket.connect()
            break
        case .wifi:
            debugPrint("Message Network available via WiFi.")
            self.socket.connect()
         
            break
        case .unavailable:
            debugPrint("Message Network is not available.")

            break
        case .none:
     
            debugPrint("Message Network is  unavailable.")
          
         
            break
        }
      }
    
    
    
    //MARK: - send Chat Message the room
    func selfJoinSocket(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
        self.socket.emit("selfJoinSocket",  MessageChatDict, completion: {
        debugPrint("selfJoinSocket \(MessageChatDict)")
            
        })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    //MARK: - send Chat Message the room
    func checkRoomExist(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
        self.socket.emit("checkRoomExist",  MessageChatDict, completion: {

        debugPrint("checkRoomExist \(MessageChatDict)")
                })
        }
        else
        {
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    //MARK: - Join the room
    
    
    func joinRoomForChat(joinRoomDict:[String:String])
    {
//        if self.socket.status == .connected {
//            self.socket.disconnect()
//        }
        self.socket.connect()
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
            self.socket.emit("join",joinRoomDict, completion: {
            
                            debugPrint("emit join ")
              //  self.getAllMessageInOnMethod()
                
                                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    //MARK: Destory Room
    func destroyRoom() {
        socket.removeAllHandlers()
        manager.defaultSocket.disconnect()
    }
    
    
    //MARK: - send Chat Message the room
    func sendChatMessage(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("sendMessage",  MessageChatDict, completion: {

        debugPrint("sendMessage \(MessageChatDict)")
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    
    
    
    func sendSmsAlert(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("sendSmsAlert",  MessageChatDict, completion: {

                    debugPrint("sendSmsAlert \(MessageChatDict)")
                    //self.getAllMessageInOnMethod()
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    func userOnChatMessageScreen(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("userOnChatMessageScreen",  MessageChatDict, completion: {

                    debugPrint("userOnChatMessageScreen \(MessageChatDict)")

                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    func onActiveInactiveChatScreenJoin(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("onActiveInactiveChatScreenJoin",  MessageChatDict, completion: {

                    debugPrint("onActiveInactiveChatScreenJoin \(MessageChatDict)")
                 
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }

    
    
    
    //MARK: - Delete messge emirt method
    
    func deleteChatBySingleIdEmit(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("deleteChatBySingleId",  MessageChatDict, completion: {

                    debugPrint("deleteChatBySingleId \(MessageChatDict)")
                    //self.getAllMessageInOnMethod()
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    //MARK: - Delete messge emirt method
    
    func disconnectRoomEmit(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("disconnect",  MessageChatDict, completion: {

                    debugPrint("disconnect \(MessageChatDict)")
                    //self.getAllMessageInOnMethod()
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    //MARK: - send updateOnlineStatusAfter2Minutes
    
    func updateOnlineStatusAfter2Minutes(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
        self.socket.emit("updateOnlineStatusAfter2Minutes",  MessageChatDict, completion: {

        debugPrint("updateOnlineStatusAfter2Minutes \(MessageChatDict)")
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    
    //MARK: - badgeCountIntervalCheckEmitmethod
    func badgeCountIntervalCheckEmit(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
                self.socket.emit("badgeCountIntervalCheck",  MessageChatDict, completion: {

                  //  debugPrint("badgeCountIntervalCheck \(MessageChatDict)")
                    //self.getAllMessageInOnMethod()
                })
        }
        else{
         //   debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    //MARK: - get all message
    
    func getAllMessageInOnMethod()
    {
        
        self.socket.on("message", callback: { (data, error) in
            
            debugPrint("on method call \(error) = \(data)")
        })
    }
    
    
    
    
    func establishConnection(emitRequest:String,jsonDict:[String:Any]?,joinDict:[String:Any]?){
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
            self.socket.emit("join",joinDict!, completion: {

                            debugPrint("emit join ")
                self.openListener(jsonDict: jsonDict)
                        })
            self.socket.emit("sendMessage",  jsonDict!, completion: {

                debugPrint("sendMessage join ")
                self.openListener(jsonDict: jsonDict)
            })
                
//            }else{
//                self.socket.emit(emitRequest,notification, jsonString ?? [:])
//                openListener()
//            }
        }else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }

    
    func socketOff(request:String){
        self.socket.off(request)
    }
    func openListener(jsonDict:[String:Any]?){
        //orderDetail
//        SocketIOManager.shared.socket.on("message") { (sendBookingDataArray, ack) in
//                   debugPrint(sendBookingDataArray.count)
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
                debugPrint("socket connected  on")
            
            debugPrint("Data in message = \(data)")
            //self.socket?.emit("sendMessage", jsonDict as! SocketData)
            }
    }
    
    func establishConnection(emitRequest:String,jsonString:[String:Any]?){
        if(self.socket.status == .connected){
            self.isSocketConnected=true
               if jsonString == nil {
                self.socket.emit(emitRequest)
               }else{
                self.socket.emit(emitRequest, jsonString ?? [:])
                openListener(jsonDict: jsonString)
                   // let data =  self.socket.emitWithAck(emitRequest, jsonString!)
                   //debugPrint(data)
               }
           }else{
               debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
           }
       }
    
    
    func disconnectSocket(){
        if(self.socket.status == .connected){
            self.isSocketConnected=true
            self.socket.disconnect()
        }
    }
    
    //MARK: - Listner
    
    
    
    //MARK: - send Chat Message the room
    func sendMatchBlockNoti(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
        self.socket.emit("sendRemoveBlockAlert",  MessageChatDict, completion: {

        debugPrint("sendRemoveBlockAlert \(MessageChatDict)")
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    //MARK: - New socket method
    
    func updateChatSelfRead(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
        self.socket.emit("updateChatSelfRead",  MessageChatDict, completion: {

        debugPrint("updateChatSelfRead \(MessageChatDict)")
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    func getChatDatas(MessageChatDict:[String:Any])
    {
        if(self.socket.status == .connected)
        {
            self.isSocketConnected=true
        self.socket.emit("getChatDatas",  MessageChatDict, completion: {

        debugPrint("getChatDatas \(MessageChatDict)")
                })
        }
        else{
            debugPrint("Socket is not connected")
            self.isSocketConnected=false
            self.socket.connect()
        }
    }
    
    
    
    
    
}




