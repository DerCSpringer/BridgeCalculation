//
//  BridgeCalculationCollectionViewController.swift
//  BridgeCalculation
//
//  Created by Daniel on 9/5/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "typeSelection"

class BridgeCalculationCollectionViewController: UICollectionViewController {
    @IBOutlet weak var score: UITextField!
    @IBOutlet weak var imps: UITextField!
    
    fileprivate var selectedButtonPath : [IndexPath]?
    fileprivate var calculator = BridgeCalculationCalculator()
    
    //If I do [BridgeCalculationCollectionViewCell?]?() then all things in the array are also optional not just the array
    
    fileprivate let cellTitleFromSection : Dictionary<Int,String> = [
        0: "Level",
        1: "Trump Suit",
        2: "Number of tricks",
        3: "Double?",
        4: "High card points",
        5: "Number of trump",
        6: "Vulnerable?"
    
    ]
    
    fileprivate let cellColor: Dictionary<Int, UIColor> = [
        0: UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5),
        1: UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5),
        2: UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5),
        3: UIColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.5),
        4: UIColor.init(red: 0.5, green: 0.5, blue: 0.0, alpha: 0.5),
        5: UIColor.init(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5),
        6: UIColor.init(red: 1.0, green: 0.5, blue: 1.0, alpha: 0.5),
        7: UIColor.init(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.5)

    ]

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                let headerView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                    withReuseIdentifier: "BridgeCalculationSectionHeader",
                    for: indexPath)
                    as! BridgeCalculationCollectionReusableView
                headerView.sectionTitle.text = cellTitleFromSection[(indexPath as NSIndexPath).section]
                return headerView
                
            default:
                assert(false, "Unexpected element kind")
            }
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return CellTitle.numberOfSections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberOfItems = cellTitleFromSection[section] {
           return CellTitle.numberOfCellsInSection(numberOfItems)
        }
        else {return 0}
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BridgeCalculationCollectionViewCell
        cell.title.text = CellTitle.titleForCellAtIndexPath(indexPath)
        if let buttonPath = selectedButtonPath {
            if (buttonPath.contains(indexPath)) {
                cell.backgroundColor = UIColor.lightGray
            }
            else {cell.backgroundColor = cellColor[(indexPath as NSIndexPath).section]}
        }
        else {cell.backgroundColor = cellColor[(indexPath as NSIndexPath).section]}
        return cell
    }

    // MARK: UICollectionViewDelegate
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BridgeCalculationCollectionViewCell {
            if (indexPath as NSIndexPath).section < 6 {
                collectionView.scrollToItem(at: IndexPath.init(row: 0, section: (indexPath as NSIndexPath).section + 1), at: UICollectionViewScrollPosition.top, animated: true)
            }
            switch (indexPath as NSIndexPath).section {
            case 0://Deselect any buttons in number of tricks if you change the level
                CellTitle.level = (indexPath as NSIndexPath).row + 1
                CellTitle.wonOrLostTricks = nil
                if let selectedButtonPaths = selectedButtonPath {
                    for index in selectedButtonPaths {
                        if (index as NSIndexPath).section == 2 {
                            selectedButtonPath!.remove(at: selectedButtonPath!.index(of: index)!)
                        }
                    }
                }
                collectionView.reloadSections(IndexSet.init(integer: 2))
            case 1: CellTitle.trumpSuit = cell.title.text!
            case 2: CellTitle.wonOrLostTricks = Int(cell.title.text!)
            case 3: CellTitle.doubleOrNot = (indexPath as NSIndexPath).row
            case 4: CellTitle.highCardPoints = Int(cell.title.text!)
            case 5: CellTitle.numberOfTrumpSelected = cell.title.text!
            case 6: CellTitle.isVulnerable = ((indexPath as NSIndexPath).row)
            default : break
                
            }
        }
        
        checkButtonSelectionStateAtIndex(indexPath)
        updateScore()
        collectionView.reloadItems(at: [indexPath])
    }

    //Only allows for selection of one button per section
    func checkButtonSelectionStateAtIndex(_ indexPath : IndexPath)
    {
        var removedFlag = false
        if selectedButtonPath != nil {//Check for nil optional
            for index in selectedButtonPath! {//search to see if a button is already selected in section.  If so then unselect that button.
                if (indexPath as NSIndexPath).section == (index as NSIndexPath).section {
                    selectedButtonPath!.remove(at: selectedButtonPath!.index(of: index)!)
                    removedFlag = true
                    self.collectionView?.reloadItems(at: [index])
                }
            }
            //Need to compare all index pathes to see if any match the section number.  If so remove that and add this one
            if (selectedButtonPath!.contains(indexPath) && !removedFlag) {
                selectedButtonPath!.remove(at: selectedButtonPath!.index(of: indexPath)!)
            }
            else{//append to an already inited array
                selectedButtonPath?.append(indexPath)
            }
        }
        else { //Init array becuaes it's empty
            selectedButtonPath = [indexPath]
        }
        
    }
    
    func updateScore() {
        score.text = "Score: "
        imps.text = nil
        var expectedScore : Int?
        var actualScore : Int?
        if let eScore = calculator.calculateEstimatedScoreWithNumberOfTrump(CellTitle.numberOfTrumpSelected, trumpSuit: CellTitle.trumpSuit, highCardPoints: CellTitle.highCardPoints, isVulnerable: CellTitle.isVulnerable) {
            expectedScore = eScore
        }
                
        if let aScore = calculator.calculateScoreWithLevel(CellTitle.level, numberOfTricks: CellTitle.wonOrLostTricks, trumpSuit: CellTitle.trumpSuit, isVulnerable: CellTitle.isVulnerable, doubled: CellTitle.doubleOrNot) {
            actualScore = aScore
            score.text = "Score: " + String(aScore)
        }
        if expectedScore != nil && actualScore != nil {
            let impScore = actualScore! - expectedScore!
            if impScore < 0 {
                imps.text = "Defense: " + String(calculator.calculateImps(-1 * impScore)!) + " imps"
            }
            else {
                imps.text = "Offense: " + String(calculator.calculateImps(impScore)!) + " imps"

            }
        }
        
    }
}

extension BridgeCalculationCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize { //Return size of cell
            if ((indexPath as NSIndexPath).section == 3) { //Section with double selection(need bigger cells)
                return CGSize(width: 100.0, height: 50.0)
            }

            return CGSize(width: 50.0, height: 50.0) //Default sizes
    }
    
}
