//
//  ViewController.swift
//  BridgeCalculation
//
//  Created by Daniel on 8/31/16.
//  Copyright © 2016 Daniel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var level: UIPickerView!
    @IBOutlet weak var trump: UIPickerView!
    @IBOutlet weak var tricks: UIPickerView!
    @IBOutlet weak var risk: UIPickerView!
    //private var testView: UIPickerView?
    //var testView : UIPickerView!
    private var numberOfTricks = 26 // Calculate in model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 0, green: 1.0, blue: 0.5, alpha: 1)
        
        level.dataSource = self
        level.delegate = self
        
        trump.dataSource = self
        trump.delegate = self
        
        tricks.dataSource = self
        tricks.delegate = self
        
        risk.dataSource = self
        risk.delegate = self
        
        level.tag = 0
        trump.tag = 1
        tricks.tag = 2
        risk.tag = 3
    }
    
    private let rowTitle: Dictionary<String,RowAndNumber> = [
        "level" : RowAndNumber.Title({String($0 + 1)}),
        "trump" : RowAndNumber.Title({suit[$0]!}),
        "tricks" : RowAndNumber.Title({String($0 - 13)}),
        "risk" : RowAndNumber.Title({risk[$0]!})
        ///"test" : self.testing({String($0)})
            
    ]
    
//    private lazy var test : Dictionary <UIPickerView, String> = [
//        self.tricks : "good"
//    ]
    
//    private lazy var testThis: Dictionary <String, String> = [
//        "good" : self.testing({String($0)}),
//        "googd" : "oidasjio"
//    ]

    
    private static var suit: Dictionary<Int,String> = [
        0: "♠️",
        1: "♥️",
        2: "♦️",
        3: "♣️",
        4: "No Trump"
    ]
    
    private static var risk: Dictionary<Int, String> = [
        0: "No Double",
        1: "Double",
        2: "Redouble"
    
    
    ]
    
    private enum RowAndNumber {
        case Title((Int) -> String)
        case Rows((Double) -> (Double))
    }
    
    //typealias testing = ((Int) -> String)
//    var testing : ((Int) -> String)
    
    
    //private let testing: ((Int) -> String)
    private let pickerViewName: Dictionary<Int, String> = [
        0 : "level",
        1 : "trump",
        2 : "tricks",
        3 : "risk"
    ]
    


    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let pickerViewName = pickerViewName[pickerView.tag] { // get name of compoenent from dict
            if let function = rowTitle[pickerViewName]{//get func type for component
                switch function {
                case .Title(let functionType): return functionType(row) //If .Title then return string of row number form appropriate dict
                default : return "Error"
                }
            }
        }
        return "Error"
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let pickerName = pickerViewName[pickerView.tag] {
            switch pickerName {
            case "level" : return 7
            case "trump" : return 5
            case "tricks" : return numberOfTricks
            case "risk" : return 3
            default : return 1
            }
        }
        return 1
    }
    
    
}
