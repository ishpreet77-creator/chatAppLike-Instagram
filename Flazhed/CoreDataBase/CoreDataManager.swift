//
//  CoreDataManager.swift
//  Flazhed
//
//  Created by ios2 on 25/10/21.
//

import Foundation
import UIKit
import CoreData
class CoreDataManager : NSObject {
    
    // MARK:- Context
    static var shared=CoreDataManager()
     class func getContext() -> NSManagedObjectContext {
//         let appdelegate = UIApplication.shared.delegate as! AppDelegate
//         return appDelegate.persistentContainer.viewContext
        let container = NSPersistentContainer(name: ApiKey.kAppName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
        })
        
        return container.viewContext
     }
    
    
    // MARK:- Delete Hangout List Data
    
    class func deleteRecords(entityName: String) -> Void {
        let context = getContext()
        let moc = context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [NSManagedObject]
        for object in resultData {
            moc.delete(object)
        }
        DispatchQueue.main.async {
            do {
                try moc.save()
                debugPrint("deleted \(entityName)!")
            } catch let error as NSError  {
                debugPrint("Could not save \(error), \(error.userInfo)")
            } catch {
            }
        }
    }
    
    
    // MARK:- Save Hangout List Data
    class func saveHangoutListData(array: JSONArray) {
//        self.deleteRecords(entityName: APIKeys.kVenueListing)
        let context = getContext()
//        let context = getbgContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kHangoutListing)
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        if result?.count == 0 {
            let entity = NSEntityDescription.entity(forEntityName: ApiKey.kHangoutListing, in: context)
            let newdata = NSManagedObject(entity: entity!, insertInto: context)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
                newdata.setValue(data, forKey: ApiKey.kHangouts)
                do {
                    try context.save()
                    debugPrint("Saved \(String(describing: entity?.name))")
                }catch {
                    debugPrint("***************** error while Saving *********")
                }
            }catch {
                debugPrint("***************** error while Saving *********")
            }
        }
    }
    
    // MARK:- Append Hangout list data
    class func appendHangoutListData(array: JSONArray) {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kHangoutListing)
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        if result?.count ?? 0 > 0 {
            let entity = NSEntityDescription.entity(forEntityName: ApiKey.kHangoutListing, in: context)
            let newdata = NSManagedObject(entity: entity!, insertInto: context)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
                newdata.setValue(data, forKey: ApiKey.kHangouts)
                do {
                    try context.save()
                    debugPrint("Saved \(String(describing: entity?.name))")
                }catch {
                    debugPrint("***************** error while Saving *********")
                }
            }catch {
                debugPrint("***************** error while Saving *********")
            }
        }
    }
    
    // MARK:- Retrieve Venue List Data
    class func fetchHangoutistData() -> [HangoutListDM] {//JSONArray {
        var dict = [HangoutListDM]() //JSONArray()
        let context = getContext()
//        let context = getbgContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kHangoutListing)
        do {
            let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
            for data in result!{
                if let dataDict = data.value(forKey: ApiKey.kHangouts) as? Data{
                    do {
                        let myData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataDict)
                        let value = myData as! JSONArray
                        for item in value {
                            let hangoutList = HangoutListDM.init(detail: item)
                            let id = hangoutList._id
                            if dict.contains(where: { $0._id == id }) == false {
                                dict.append(hangoutList)
                            }
                        }
                    }
                }
//                dict = dict.sorted(by: { ($0.created_at ?? kEmptyString).compare(($1.created_at ?? kEmptyString)) == .orderedAscending })
                debugPrint(dict)
            }
            return dict
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
            debugPrint("failed......")
            return [HangoutListDM]() //JSONArray()
        }
     }
    
    // MARK:- Save Chat List Data
    class func saveChatListData(array: JSONArray) {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kChatData)
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        if result?.count == 0 {
            let entity = NSEntityDescription.entity(forEntityName: ApiKey.kChatData, in: context)
            let newdata = NSManagedObject(entity: entity!, insertInto: context)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
                newdata.setValue(data, forKey: ApiKey.kChatDetails)
                do {
                    try context.save()
                    debugPrint("Saved \(String(describing: entity?.name))")
                }catch {
                    debugPrint("***************** error while Saving *********")
                }
            }catch {
                debugPrint("***************** error while Saving *********")
            }
        }
    }
    
    // MARK:- Append Chat list data
    class func appendChatListData(array: JSONArray) {
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kChatData)
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        if result?.count ?? 0 > 0 {
            let entity = NSEntityDescription.entity(forEntityName: ApiKey.kChatData, in: context)
            let newdata = NSManagedObject(entity: entity!, insertInto: context)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
                newdata.setValue(data, forKey: ApiKey.kChatDetails)
                do {
                    try context.save()
                    debugPrint("Saved \(String(describing: entity?.name))")
                }catch {
                    debugPrint("***************** error while Saving *********")
                }
            }catch {
                debugPrint("***************** error while Saving *********")
            }
        }
    }
    
    // MARK:- Retrieve Chat List Data
    class func fetchChatListData() -> [chat_room_details_Model] {//JSONArray {
        var dict = [chat_room_details_Model]() //JSONArray()
        let context = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kChatData)
        do {
            let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
            for data in result!{
                if let dataDict = data.value(forKey: ApiKey.kChatDetails) as? Data{
                    do {
                        let myData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataDict)
                        let value = myData as! JSONArray
                        for item in value {
                            let chatList = chat_room_details_Model.init(detail: item)
                            let id = chatList._id
                            if dict.contains(where: { $0._id == id }) == false {
                                dict.append(chatList)
                            }
                        }
                    }
                }
//                dict = dict.sorted(by: { ($0.created_at ?? kEmptyString).compare(($1.created_at ?? kEmptyString)) == .orderedAscending })
                debugPrint(dict)
            }
            return dict
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
            debugPrint("failed......")
            return [chat_room_details_Model]() //JSONArray()
        }
     }
    
    // MARK:- Save story List Data
    class func saveStoryListData(array: JSONArray) {
//        self.deleteRecords(entityName: APIKeys.kVenueListing)
        let context = getContext()
//        let context = getbgContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kStoryListing)
        let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
        if result?.count == 0 {
            let entity = NSEntityDescription.entity(forEntityName: ApiKey.kStoryListing, in: context)
            let newdata = NSManagedObject(entity: entity!, insertInto: context)
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: array, requiringSecureCoding: false)
                newdata.setValue(data, forKey: ApiKey.kStories)
                do {
                    try context.save()
                    debugPrint("Saved \(String(describing: entity?.name))")
                }catch {
                    debugPrint("***************** error while Saving *********")
                }
            }catch {
                debugPrint("***************** error while Saving *********")
            }
        }
    }
    
    // MARK:- Retrieve Story List Data
    class func fetchStorytistData() -> [StoriesPostDataModel] {//JSONArray {
        var dict = [StoriesPostDataModel]() //JSONArray()
        let context = getContext()
//        let context = getbgContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kStoryListing)
        do {
            let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
            for data in result!{
                if let dataDict = data.value(forKey: ApiKey.kStories) as? Data{
                    do {
                        let myData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataDict)
                        let value = myData as! JSONArray
                        for item in value {
//                            let venueList = LocalVenueDM(details: item).json()
                            let storyList = StoriesPostDataModel.init(detail: item)
                            let id = storyList.post_id
                            if dict.contains(where: { $0.post_id == id }) == false {
                                dict.append(storyList)
                            }
                        }
                    }
                }
//                dict = dict.sorted(by: { ($0.created_at ?? kEmptyString).compare(($1.created_at ?? kEmptyString)) == .orderedAscending })
                debugPrint(dict)
            }
            return dict
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
            debugPrint("failed......")
            return [StoriesPostDataModel]() //JSONArray()

        }
     }
    
    // MARK:- Save Profile Data
    class func saveMyProfileData(dict: MyProfileDataModel) {
        var dataArray:[Data] = []
        
        for dict in dict.images ?? []
        {
            let data = HangoutVM.shared.stringToData(string: (IMAGE_BASE_URL + (dict.image ?? kEmptyString)))
            dataArray.append(data)
        }
        
        let context = getContext()
//        let context = getbgContext()
        let entity = NSEntityDescription.entity(forEntityName: ApiKey.kMyProfile, in: context)
        let newdata = NSManagedObject(entity: entity!, insertInto: context)
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false)
            newdata.setValue(data, forKey: ApiKey.kProfileDetails)
            
            
            do {
                try context.save()
                debugPrint("Saved \(String(describing: entity?.name))")
            } catch {
                debugPrint("***************** error while Saving *********")
            }
        } catch {
            debugPrint("***************** error while Saving *********")
        }
    }
    
    // MARK:- Retrieve Profile Data
    class func fetchMyProfileData() -> MyProfileDataModel? {
        var dict = MyProfileDataModel(detail: JSONDictionary()) //JSONDictionary()
        let context = getContext()
//        let context = getbgContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ApiKey.kMyProfile)
        do {
            let result = try? context.fetch(fetchRequest) as? [NSManagedObject]
            for data in result!{
                if let dataDict = data.value(forKey: ApiKey.kProfileDetails) as? Data {
                    do {
                        let myData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataDict) as! JSONDictionary
                        let user = MyProfileDataModel(detail: myData)
                        dict = user
                    }
                }
            }
            debugPrint(dict)
            return dict
        } catch {
            let fetchError = error as NSError
            debugPrint(fetchError)
            debugPrint("failed......")
            return MyProfileDataModel(detail: JSONDictionary()) //JSONDictionary()
        }
     }
}
