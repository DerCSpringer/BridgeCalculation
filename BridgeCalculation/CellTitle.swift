//
//  CellTitle.swift
//  BridgeCalculation
//
//  Created by Daniel on 9/5/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation

class CellTitle {
    
    fileprivate static var numberOfTricks = 14
    static let numberOfSections = cellTitleFromSection.count
    
    //MARK: Model variables from controller
    static var level : Int? { //Level selected in controller
        didSet {
            numberOfTricks = 14 - (-level! + 7)
        }
    }
    static var trumpSuit : String?
    static var wonOrLostTricks : Int?
    static var doubleOrNot : Int?
    static var highCardPoints : Int?
    static var numberOfTrumpSelected : String?
    static var imps : Int?
    static var points : Int?
    static var isVulnerable : Int?
    
    //MARK: types in collectionView
    
    fileprivate static let cellTitleFromSection : Dictionary<Int,String> = [
        0: "Level",
        1: "Trump Suit",
        2: "Number of tricks",
        3: "Double?",
        4: "High card points",
        5: "Number of trump",
        6: "Vulnerable?"
        
    ]
    
    static func numberOfCellsInSection(_ sectionName: String) -> Int {
        switch sectionName {
        case "Level" : return 7
        case "Trump Suit" : return 5
        case "Number of tricks" : return 14
        case "Double?" : return 3
        case "High card points" : return 21
        case "Number of trump" : return 4
        case "Vulnerable?" : return 2
        default : return 1
        }
    }
    
    fileprivate static let suit: Dictionary<Int,String> = [
        0: "♠️",
        1: "♥️",
        2: "♦️",
        3: "♣️",
        4: "NT"
    ]
    
    fileprivate static let risk: Dictionary<Int, String> = [
        0: "No Double",
        1: "Double",
        2: "Redouble"
    ]
    
    fileprivate static let numberOfTrump: Array<String> =
    ["<8","8","9","10+"]
    
    fileprivate static let vulnerable: Array<String> =
    ["No","Yes"]
    
    
    
    static func titleForCellAtIndexPath(_ indexPath: IndexPath) -> String {
        if let cellTitle = cellTitleFromSection[(indexPath as NSIndexPath).section] {
            switch cellTitle {
            case "Level" : return String((indexPath as NSIndexPath).row + 1)
            case "Trump Suit" : return suit[(indexPath as NSIndexPath).row]!
            case "Double?" : return risk[(indexPath as NSIndexPath).row]!
            case "Number of tricks" : return (String((indexPath as NSIndexPath).row - numberOfTricks + 1))
            case "High card points" : return String((indexPath as NSIndexPath).row + 20)
            case "Number of trump" : return numberOfTrump[(indexPath as NSIndexPath).row]
            case "Vulnerable?" : return vulnerable[(indexPath as NSIndexPath).row]
            default : return "Error"
            }
        }
        return "Error"
        
    }
    

}
