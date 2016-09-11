//
//  CellTitle.swift
//  BridgeCalculation
//
//  Created by Daniel on 9/5/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import Foundation

class CellTitle {
    
    private static var numberOfTricks = 14
    private static var numberOfPoints = 40
    static let numberOfSections = cellTitleFromSection.count
    
    //MARK: Model variables from controller
    static var level : Int? { //Level selected in controller
        didSet {
            numberOfTricks = 14 - (-level! + 7)
        }
    }
    static var trumpSuit : String?
    static var wonOrLostTricks : Int?
    static var doubleOrNot : String?
    static var highCardPoitns : Int?
    static var numberOfTrumpSelected : Int?
    static var imps : Int?
    static var points : Int?
    
    //MARK: types in collectionView
    
    private static let cellTitleFromSection : Dictionary<Int,String> = [
        0: "Level",
        1: "Trump Suit",
        2: "Number of tricks",
        3: "Double?",
        4: "High card points",
        5: "Number of trump"
        
    ]
    
    static func numberOfCellsInSection(sectionName: String) -> Int {
        switch sectionName {
        case "Level" : return 7
        case "Trump Suit" : return 5
        case "Number of tricks" : return 14
        case "Double?" : return 3
        case "High card points" : return 41
        case "Number of trump" : return 4
        default : return 1
        }
    }
    
    private static let suit: Dictionary<Int,String> = [
        0: "♠️",
        1: "♥️",
        2: "♦️",
        3: "♣️",
        4: "NT"
    ]
    
    private static let risk: Dictionary<Int, String> = [
        0: "No Double",
        1: "Double",
        2: "Redouble"
    ]
    
    private static let numberOfTrump: Array<String> =
    ["<8","8","9","10+"]
    
    
    
    static func titleForCellAtIndexPath(indexPath: NSIndexPath) -> String {
        if let cellTitle = cellTitleFromSection[indexPath.section] {
            switch cellTitle {
            case "Level" : return String(indexPath.row + 1)
            case "Trump Suit" : return suit[indexPath.row]!
            case "Double?" : return risk[indexPath.row]!
            case "Number of tricks" : return (String(indexPath.row - numberOfTricks))
            case "High card points" : return String(indexPath.row)
            case "Number of trump" : return numberOfTrump[indexPath.row]
            default : return "Error"
            }
        }
        return "Error"
        
    }
    

}
