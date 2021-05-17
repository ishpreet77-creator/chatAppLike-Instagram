//
//  ImageCheckmodel.swift
//  Flazhed
//
//  Created by IOS33 on 11/03/21.
//

import Foundation

struct ImageCheckDM
{
   
    var status:String?
    var request:ImageRequestDM?
    var weapon:Double?
    var alcohol:Double?
    var drugs:Double?
    var nudity:NudityDM?
    var offensive:OffensiveDM?
    
    var error:ImageErrorDM?
    
    init(detail:JSONDictionary)
    {
        self.status = detail["status"] as? String

        self.request = ImageRequestDM.init(detail: (detail["request"] as? JSONDictionary) ?? [:])
        self.weapon = detail["weapon"] as? Double
        self.alcohol = detail["alcohol"] as? Double
        self.drugs = detail["drugs"] as? Double
        
        self.nudity = NudityDM.init(detail: (detail["nudity"] as? JSONDictionary) ?? [:])
        self.offensive = OffensiveDM.init(detail: (detail["offensive"] as? JSONDictionary) ?? [:])
        
        self.error = ImageErrorDM.init(detail: (detail["error"] as? JSONDictionary) ?? [:])
    }
}
struct ImageRequestDM
{
   
    var id:String?
    var timestamp:Double?
    var operations:Int?
    init(detail:JSONDictionary)
    {
        self.id = detail["id"] as? String
        self.timestamp = detail["timestamp"] as? Double
        self.operations = detail["operations"] as? Int
    }
}

struct NudityDM
{
   
    
    var raw:Double?
    var safe:Double?
    var partial:Double?
    
    init(detail:JSONDictionary)
    {
        self.raw = detail["raw"] as? Double
        self.safe = detail["safe"] as? Double
        self.partial = detail["partial"] as? Double
    }
}
struct OffensiveDM
{
   
    
    var prob:Double?

    
    init(detail:JSONDictionary)
    {
        self.prob = detail["prob"] as? Double
      
    }
}


struct ImageErrorDM
{
    var code:Int?
    var message:String?
    var type:String?

    
    init(detail:JSONDictionary)
    {
        self.message = detail["message"] as? String
        self.type = detail["type"] as? String
        self.code = detail["code"] as? Int
    }
}
