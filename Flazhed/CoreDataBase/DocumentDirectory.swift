//
//  DocumentDirectory.swift
//  Flazhed
//
//  Created by ios2 on 25/10/21.
//

import UIKit

class DocumentsDirectory {
    
    static var shared = DocumentsDirectory()
    let name = Date().timeIntervalSince1970
    func saveVideo(videoURL: NSURL) -> URL
    {
      
        let videoURL = videoURL
        let videoData = NSData(contentsOf: videoURL as URL)
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let newPath = path.appendingPathComponent("\(name)video.mp4")
        
        do {
            try videoData?.write(to: newPath)
            debugPrint("Video saved path =\(newPath)")
            return newPath
        } catch {
            print(error)
        }
        return path
    }
    
    func read(videoURL: URL) -> URL {
        let path = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        let filePath : URL = path.appendingPathComponent("\(name)video.mp4")
        return filePath
    }
}
