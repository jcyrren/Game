//
//  DetailViewController.swift
//  GameLife2
//
//  Created by Bhavik Nagda on 11/21/16.
//  Copyright © 2016 stulinProject. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var wrapping: UISwitch!
    @IBOutlet weak var coordinates: UILabel!
    @IBOutlet var Template: UILabel!
    @IBOutlet var Select: UIButton!
    @IBOutlet var picker: UIStepper!
    
    @IBOutlet var ColonyView: UIView!
    
    var BOARD_EDGE = 600.0
    var X_LOCATION = 200.0
    var Y_LOCATION = 200.0
    let templates = ["Glider Gun", "Basic", "Default"]
    var curIndex = 0
    
    
    var evolvePace: Double = 0.0
    var timer = Timer()
    
    var c: Colony? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    //    c!.setCellAlive(5, yCoor: 5)
    //    c!.setCellAlive(5, yCoor: 6)
    //    c!.setCellAlive(5, yCoor: 7)
    //    c!.setCellAlive(6, yCoor: 6)
        slider.setValue(0.0, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
        picker.wraps = true
        picker.autorepeat = true
        picker.maximumValue = 2
        makeView()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        timer.invalidate()
        let selectedValue = Double(sender.value)
        evolvePace = 1.0 - selectedValue
        if (evolvePace != 1.0) {
            timer = Timer.scheduledTimer(timeInterval: evolvePace, target: self, selector: #selector(evolve), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func switchChange(_ sender: Any) {
        if(wrapping.isOn){
            c!.wrapping = true
        } else {
            c!.wrapping = false
        }
    }
    
    @IBAction func template_change(_ sender: UIStepper) {
        curIndex = Int(sender.value)
        Template.text = templates[curIndex]
    }
    
    @IBAction func selected(_ sender: AnyObject) {
        switch templates[curIndex] {
        case "Glider Gun":
            c?.resetColony()
            c?.setCellAlive(6, yCoor: 2)
            c?.setCellAlive(6, yCoor: 3)
            c?.setCellAlive(6, yCoor: 12)
            c?.setCellAlive(6, yCoor: 18)
            c!.setCellAlive(6, yCoor: 22)
            c!.setCellAlive(6, yCoor: 23)
            
            c?.setCellAlive(7, yCoor: 2)
            c?.setCellAlive(7, yCoor: 3)
            c?.setCellAlive(4, yCoor: 14)
            c?.setCellAlive(4, yCoor: 15)
            c?.setCellAlive(5, yCoor: 13)
            c?.setCellAlive(5, yCoor: 17)
            c?.setCellAlive(7, yCoor: 12)
            c?.setCellAlive(7, yCoor: 16)
            c?.setCellAlive(7, yCoor: 19)
            c?.setCellAlive(8, yCoor: 12)
            c?.setCellAlive(8, yCoor: 18)
            c?.setCellAlive(9, yCoor: 13)
            c?.setCellAlive(10, yCoor: 14)
            c?.setCellAlive(10, yCoor: 15)
            c?.setCellAlive(4, yCoor: 22)
            c?.setCellAlive(4, yCoor: 23)
            c?.setCellAlive(5, yCoor: 22)
            c?.setCellAlive(5, yCoor: 23)
            c?.setCellAlive(3, yCoor: 24)
            c?.setCellAlive(3, yCoor: 26)
            c?.setCellAlive(2, yCoor: 26)
            c?.setCellAlive(7, yCoor: 24)
            c?.setCellAlive(7, yCoor: 26)
            c?.setCellAlive(8, yCoor: 26)
            c?.setCellAlive(4, yCoor: 36)
            c?.setCellAlive(4, yCoor: 37)
            c?.setCellAlive(5, yCoor: 36)
            c?.setCellAlive(5, yCoor: 37)
            c?.setCellAlive(9, yCoor: 17)
            c?.setCellAlive(7, yCoor: 18)
            
        
        case "Basic":
            c?.resetColony()
            c?.setCellAlive(3, yCoor: 4)
            c?.setCellAlive(3, yCoor: 5)
            c?.setCellAlive(3, yCoor: 6)
            c?.setCellAlive(4, yCoor: 5)
            
        default:
            c?.resetColony()
        }
        makeView()
    }
    
    func makeView(){
        ColonyView.subviews.forEach({$0.removeFromSuperview() })
        let thisView = BoardView(frame: CGRect(x: X_LOCATION, y: Y_LOCATION, width: BOARD_EDGE, height: BOARD_EDGE), colony: c!)
        ColonyView.addSubview(thisView)
        self.configureView()
    }
    
    func evolve(){
        c!.evolve()
        makeView()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    
    func touchToPoint(touch: UITouch) -> (Int, Int)? {
        let location = touch.location(in: self.ColonyView)
        let xVal = Int((Double(location.x) - X_LOCATION)/(BOARD_EDGE/60.0))
        let yVal = Int((Double(location.y) - Y_LOCATION)/(BOARD_EDGE/60.0))
        if xVal < 0 || xVal > 59 || yVal < 0 || yVal > 59 {
            return nil
        } else {
            coordinates.text = "(" + String(xVal) + ", " + String(yVal) + ")"
            return (xVal, yVal)
        }
    }
    
    
    var isKilling: Bool = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touches began!")
        super.touchesBegan(touches, with: event)
        
        for t in touches {
            let location = touchToPoint(touch: t)
            if (location != nil){
                isKilling = c!.setCellOpposite(location: location!)
            }
        }
        self.makeView()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches moved!")
        super.touchesMoved(touches, with: event)
        let t = touches.first
        let location = touchToPoint(touch: t!)
        if (location != nil){
            if isKilling {
                c!.setCellDead(location!.0, yCoor: location!.1)
            } else {
                c!.setCellAlive(location!.0, yCoor: location!.1)
            }
        }
        
        self.makeView()
    }


}

