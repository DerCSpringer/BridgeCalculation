//
//  BridgeCalculationCalculator.swift
//  BridgeCalculation
//
//  Created by Daniel on 9/19/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

class BridgeCalculationCalculator: NSObject {
    private var columnPosition = 13
    private var rowPosition : Int?
    private let compensationTable = [
        [30, 10, 90, 70, 120, 120, -20, -40, -40, -60, -60, -70, 20, -10],
        [60, 30, 140, 130, 160, 240, 30, 0, 20, -10, 40, 40, 40, 20],
        [100, 100, 170, 200, 230, 310, 60, 50, 60, 70, 70, 100, 60, 50],
        [140, 180, 260, 330, 280, 380, 80, 80, 90, 110, 160, 260, 90, 80],
        [190, 310, 330, 450, 370, 510, 160, 180, 170, 200, 260, 320, 160, 150],
        [270, 410, 390, 550, 400, 570, 190, 270, 260, 400, 320, 450, 220, 290],
        [350, 500, 430, 630, 440, 640, 320, 440, 340, 500, 420, 560, 310, 480],
        [400, 580, 470, 690, 510, 730, 360, 490, 410, 590, 480, 680, 390, 580],
        [420, 630, 540, 750, 640, 920, 390, 580, 470, 680, 590, 870, 420, 600],
        [450, 660, 600, 860, 720, 1050, 420, 640, 530, 770, 670, 1000, 440, 630],
        [550, 770, 730, 1050, 920, 1320, 490, 740, 670, 990, 850, 1250, 470, 660],
        [620, 900, 890, 1280, 1020, 1470, 560, 840, 820, 1210, 950, 1400, 510, 710],
        [770, 1120, 970, 1400, 1070, 1550, 710, 1060, 900, 1330, 1000, 1480, 640, 900],
        [910, 1310, 1010, 1460, 1110, 1610, 840, 1240, 940, 1390, 1040, 1540, 820, 1170]
    ]
    
    private let imps=[20, 50, 90, 130, 170, 220, 270, 320, 370, 430, 500, 600, 750, 900, 1100, 1300, 1500, 1750, 2000, 2250, 2500, 3000, 3500, 4000, 100000]

    
    //There are 13 columns in the above table.  Each number represents a score from this Compensation Table http://www.compensationtable.com/printable.php
    //First we figure out if we are in a major/minor/ or no fit
    //This gives us a range of columns for each type.  We always start out at the rightmost column in a type
    //After the fit is figured we then go to the number in the fit.  This narrows our range.  After that we figure out vulnerability to give us a specific column number.  We figure the row number by using the total number of high card points
    func calculateEstimatedScoreWithNumberOfTrump(numberOfTrump : String?, trumpSuit : String?, highCardPoints : Int?, isVulnerable : Bool?) -> Int? {
        if numberOfTrump == nil || trumpSuit == nil || highCardPoints == nil || isVulnerable == nil {return nil}
        
        columnPosition = 13 //Last column in matrix and starting position
        var pointsAfter33HCP = 0
        var trumpType : String?
        if trumpSuit == "♠️" || trumpSuit == "♥️" {trumpType = "Major"}
        else if trumpSuit == "♦️" || trumpSuit == "♣️" { trumpType = "Minor"}
        else if trumpSuit == "NT" { trumpType = "NT" }
        if var hcp = highCardPoints { //Over 33 points is not in the matrix so I need to calculate a score over 33
            if hcp > 33 {
                pointsAfter33HCP = hcp - 33
                hcp = 33
            }
            else {rowPosition = hcp - 20}
        }
        
        if trumpType == "Major" { columnPosition = 5 }
        else if trumpType == "Minor" { columnPosition = 11 }
        else if trumpType == "NT" { columnPosition = 13 }
        
        if trumpType != "NT" {
            switch numberOfTrump! {
            case "<8" : columnPosition = 13
            case "8" : columnPosition -= 4
            case "9" : columnPosition -= 2
            default : break
            }
        }
        
        if !isVulnerable! {columnPosition -= 1}
        if isVulnerable! {pointsAfter33HCP *= 150}
        else {pointsAfter33HCP *= 100}
        return compensationTable[rowPosition!][columnPosition] + pointsAfter33HCP
    }
    
        func calculateScoreWithLevel(level : Int?, numberOfTricks : Int?, trumpSuit : String?, isVulnerable : Bool?, doubled : Int?) -> Int? {
        if (level == nil || numberOfTricks == nil || trumpSuit == nil || isVulnerable == nil || doubled == nil) {
            return nil
        }
        var trumpType : String?
        var penalityPerTrick = 0
        var gameBonus = 0
        var result = 0
        var pointsForTricks = 0
        var doubledBonus = 0
        
        if trumpSuit == "♠️" || trumpSuit == "♥️" {trumpType = "Major"}
        else if trumpSuit == "♦️" || trumpSuit == "♣️" { trumpType = "Minor"}
        else if trumpSuit == "NT" { trumpType = "NT" }
        
        
        if numberOfTricks >= 0 {
            gameBonus = calculateGameBonus(level!, isVulnerable: isVulnerable!, trumpType: trumpType!)
            pointsForTricks = calculatePointsForTricks(trumpType!, numberOfTricks: numberOfTricks!, level: level!)
            if doubled > 0 {
                /* bonus for double or redouble*/ doubledBonus += (doubled! * 50)
                /* bonus for double or redouble for tricks*/ + (((2 * doubled!) - 1) * pointsForTricks)
                /* bonus for double or redouble for overtricks*/ + (numberOfTricks! * (100 + 100 * Int(isVulnerable!)) * doubled!)}
        }
        
        //Penalty
        //doubled = 0 means not doubled, 1 = doubled, 2 = redouble
        //Does all penalities: doubled, redouble, vuln, not vuln
        if(numberOfTricks < 0) {penalityPerTrick -= Int(pow(2.0, Double(doubled!))) * (50 + (50 * (Int(isVulnerable!)))) * numberOfTricks!}
        
        
        //Double bonus
        
        result = gameBonus + pointsForTricks + doubledBonus - penalityPerTrick
        return result
    }
    
    private func calculatePointsForTricks(trumpType : String, numberOfTricks: Int, level : Int) -> Int
    {
        var pointsForTricks = 0
        if trumpType == "Minor" {
            pointsForTricks = (numberOfTricks + level) * 20
        }
        else if trumpType == "Major" {
            pointsForTricks = (numberOfTricks + level) * 30
        }
        else if trumpType == "NT" {
            pointsForTricks = ((numberOfTricks + level) * 30) + 10
        }
        
        return pointsForTricks
    }
    
    private func calculateGameBonus(level : Int, isVulnerable : Bool, trumpType : String) -> Int
    {
        var bonus = 0
            //Major game bonus
        if ((level == 4 || level == 5) && isVulnerable == true && trumpType != "Minor") {bonus = 500}
        else if ((level == 4 || level == 5) && isVulnerable == false && trumpType != "Minor") {bonus = 300}
            
            //Minor game bonus
        else if (level == 5 && isVulnerable == true && trumpType == "Minor") {bonus = 500}
        else if (level == 5 && isVulnerable == false && trumpType == "Minor") {bonus = 300}
            
            //Small slam bonus
        else if (level == 6 && isVulnerable == true) {bonus = 1250}
        else if (level == 6 && isVulnerable == false) {bonus = 800}
            
            //Grand slam bonus
        else if (level == 7 && isVulnerable == true) {bonus = 2000}
        else if (level == 7 && isVulnerable == false) {bonus = 1300}
            
            //NT game bonus
        else if (level == 3 && trumpType == "NT" && isVulnerable == true) {bonus = 500}
        else if (level == 3 && trumpType == "NT" && isVulnerable == false) {bonus = 300}
            //Part score bonus
        else if (level <= 4 && bonus == 0) {bonus = 50}
        
        return bonus
    }
    
    func calculateImps(score : Int?) -> Int?
    {
        for expectedScore in imps {
            if score < expectedScore {return imps.indexOf(expectedScore)}
        }
        return nil
    }
}
