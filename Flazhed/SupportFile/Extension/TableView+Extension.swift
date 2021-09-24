//
//  TableView+Extension.swift
//  Flazhed
//
//  Created by IOS33 on 26/03/21.
//

import Foundation
import UIKit

extension UITableView
{
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }

    func scrollToTop(animated: Bool,row:Int = 0)
    {
    let indexPath = IndexPath(row: row, section: 0)
    if self.hasRowAtIndexPath(indexPath: indexPath)
    {
        
    self.scrollToRow(at: indexPath, at: .top, animated: animated)
        
    }
    else
    {
        self.reloadData()
    }
  }
    
    func scrollToBottom(animated: Bool,row:Int = 0,section:Int = 0) {
    let indexPath = IndexPath(row: row, section: section)
    if self.hasRowAtIndexPath(indexPath: indexPath) {
       self.scrollToRow(at: indexPath, at: .bottom, animated: animated)

    }
    else
    {
        self.reloadData()
    }
  }
    
    func scrollSamePostion(animated: Bool,row:Int = 0,section:Int = 0)
    {
    let indexPath = IndexPath(row: row, section: section)
    if self.hasRowAtIndexPath(indexPath: indexPath) {
        self.scrollToRow(at: indexPath, at: .bottom, animated: animated)

    }
    else
    {
        self.reloadData()
    }
  }
}
//MARK:- table extension 

extension UITableView {
      // center point of content size
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }

    // center indexPath
     var centerCellIndexPath: IndexPath? {

        if let centerIndexPath: IndexPath  = self.indexPathForRow(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }

    // visible or not
    func checkWhichVideoToEnableAtIndexPath() -> IndexPath? {
        guard let middleIndexPath = self.centerCellIndexPath else {return nil}
        guard let visibleIndexPaths = self.indexPathsForVisibleRows else {return nil}

        if visibleIndexPaths.contains(middleIndexPath) {
            return middleIndexPath
         }

        return nil

    }
}
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .top, animated: false)
           }
        }
    }

}
extension UITableView {

    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)

        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}
extension UITableView {

    public func reloadData1(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion:{ _ in
            completion()
        })
    }

    func scroll(to: scrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections-1)
            switch to{
            case .top:
                if numberOfRows > 0 {
                     let indexPath = IndexPath(row: 0, section: 0)
                     self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > 0 {
                    let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }

    enum scrollsTo {
        case top,bottom
    }
}
