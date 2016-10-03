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
    
    
    //The array is optional
    private var selectedButtons = [BridgeCalculationCollectionViewCell]?()
    private var selectedButtonPath = [NSIndexPath]?()
    private var calculator = BridgeCalculationCalculator()
    
    //If I do [BridgeCalculationCollectionViewCell?]?() then all things in the array are also optional not just the array
    
    private let cellTitleFromSection : Dictionary<Int,String> = [
        0: "Level",
        1: "Trump Suit",
        2: "Number of tricks",
        3: "Double?",
        4: "High card points",
        5: "Number of trump",
        6: "Vulnerable?"
    
    ]
    
    private let cellColor: Dictionary<Int, UIColor> = [
        0: UIColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5),
        1: UIColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5),
        2: UIColor.init(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.5),
        3: UIColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 0.5),
        4: UIColor.init(red: 0.5, green: 0.5, blue: 0.0, alpha: 0.5),
        5: UIColor.init(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.5),
        6: UIColor.init(red: 1.0, green: 0.5, blue: 1.0, alpha: 0.5),
        7: UIColor.init(red: 1.0, green: 0.5, blue: 0.5, alpha: 0.5)

    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            switch kind {
                
            case UICollectionElementKindSectionHeader:
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "BridgeCalculationSectionHeader",
                    forIndexPath: indexPath)
                    as! BridgeCalculationCollectionReusableView
                headerView.sectionTitle.text = cellTitleFromSection[indexPath.section]
                return headerView
                
            default:
                assert(false, "Unexpected element kind")
            }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return CellTitle.numberOfSections
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if let numberOfItems = cellTitleFromSection[section] {
           return CellTitle.numberOfCellsInSection(numberOfItems)
        }
        else {return 0}
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BridgeCalculationCollectionViewCell
        cell.title.text = CellTitle.titleForCellAtIndexPath(indexPath)
        if let buttonPath = selectedButtonPath {
            if (buttonPath.contains(indexPath)) {
                cell.backgroundColor = UIColor.lightGrayColor()
            }
            else {cell.backgroundColor = cellColor[indexPath.section]}
        }
        else {cell.backgroundColor = cellColor[indexPath.section]}
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    
    //Probably not needed anymore
    //If I selected an object then unselect it.  If I select a new object then deselect the old and and select the new one.  If I select an object then just select it.
    override func collectionView(collectionView: UICollectionView,
        shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//            if let selectedButton = selectedButtons?[indexPath.section] {
//                collectionView.deselectItemAtIndexPath(collectionView.indexPathForCell(selectedButton)!, animated: true)
//            }
            return true
    }
    
        override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? BridgeCalculationCollectionViewCell {
            switch indexPath.section {
            case 0://Deselect any buttons in number of tricks if you change the level
                CellTitle.level = indexPath.row + 1
                CellTitle.wonOrLostTricks = nil
                if let selectedButtonPaths = selectedButtonPath {
                    for index in selectedButtonPaths {
                        if index.section == 2 {
                            selectedButtonPath!.removeAtIndex(selectedButtonPath!.indexOf(index)!)
                        }
                    }
                }
                collectionView.reloadSections(NSIndexSet.init(index: 2))
            case 1: CellTitle.trumpSuit = cell.title.text!
            case 2: CellTitle.wonOrLostTricks = Int(cell.title.text!)
            case 3 : CellTitle.doubleOrNot = indexPath.row
            case 4: CellTitle.highCardPoints = Int(cell.title.text!)
            case 5: CellTitle.numberOfTrumpSelected = cell.title.text!
            case 6: CellTitle.isVulnerable = !Bool(indexPath.row)
            default : break
                
            }
        }
        
        checkButtonSelectionStateAtIndex(indexPath)
        updateScore()
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
    
    
    //Only allows for selection of one button per section
    func checkButtonSelectionStateAtIndex(indexPath : NSIndexPath)
    {
        var removedFlag = false
        if selectedButtonPath != nil {//Check for nil optional
            for index in selectedButtonPath! {//search to see if a button is already selected in section.  If so then unselect that button.
                if indexPath.section == index.section {
                    selectedButtonPath!.removeAtIndex(selectedButtonPath!.indexOf(index)!)
                    removedFlag = true
                    self.collectionView?.reloadItemsAtIndexPaths([index])
                }
            }
            //Need to compare all index pathes to see if any match the section number.  If so remove that and add this one
            if (selectedButtonPath!.contains(indexPath) && !removedFlag) {
                selectedButtonPath!.removeAtIndex(selectedButtonPath!.indexOf(indexPath)!)
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
        score.text = nil
        imps.text = nil
        if let aScore = calculator.calculateEstimatedScoreWithNumberOfTrump(CellTitle.numberOfTrumpSelected, trumpSuit: CellTitle.trumpSuit, highCardPoints: CellTitle.highCardPoints, isVulnerable: CellTitle.isVulnerable) {
            score.text = String(aScore)
        }
                
        if let impScore = calculator.calculateScoreWithLevel(CellTitle.level, numberOfTricks: CellTitle.wonOrLostTricks, trumpSuit: CellTitle.trumpSuit, isVulnerable: CellTitle.isVulnerable, doubled: CellTitle.doubleOrNot) {
            imps.text = String(impScore)
        }
    }

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    


}

extension BridgeCalculationCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize { //Return size of cell
            if (indexPath.section == 3) { //Section with double
                return CGSizeMake(100.0, 50.0)
            }

            return CGSizeMake(50.0, 50.0) //Default sizes
    }
    
}

