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
    //var testView : UIPickerView!
    private var numberOfTricks = 26 // Calculate in model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        level.dataSource = self
        level.delegate = self
        trump.dataSource = self
        trump.delegate = self
        tricks.dataSource = self
        tricks.delegate = self
        level.tag = 0
        trump.tag = 1
        tricks.tag = 2
    }
    
    private let rowTitle: Dictionary<String,RowAndNumber> = [
        "level" : RowAndNumber.Title({String($0 + 1)}),
        "trump" : RowAndNumber.Title({suit[$0]!}),
        "tricks" : RowAndNumber.Title({String($0 - 13)})
    ]
    
//    private lazy var test : Dictionary < UIPickerView, String> = [
//        testView : "good"
//    
//    
//    
//    ]

    
    private static var suit: Dictionary<Int,String> = [
        0:"♥️",
        1: "♠️",
        2: "♣️",
        3: "♦️",
        4: "No Trump"
    ]
    
    private enum RowAndNumber {
        case Title((Int) -> String)
        case Rows((Double) -> (Double))
    }
    private let pickerViewName: Dictionary<Int, String> = [
        0 : "level",
        1 : "trump",
        2 : "tricks"
    ]

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let pickerViewName = pickerViewName[pickerView.tag] {
            if let function = rowTitle[pickerViewName]{
                switch function {
                case .Title(let functionType): return functionType(row)
                default : return ""
                }
            }
        }
        return ""
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
            default : return 1
            }
        }
        return 1
    }
}
