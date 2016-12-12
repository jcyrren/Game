//
//  BoardView.swift
//  GameLife2
//
//  Created by Bhavik Nagda on 11/26/16.
//  Copyright © 2016 stulinProject. All rights reserved.
//

import UIKit
import Foundation

class BoardView: UIView{
    
    
    var c: Colony
    var height: Double = 0.0
    var width: Double = 0.0
    
    init(frame: CGRect, colony: Colony) {
        c = colony
        super.init(frame: frame)
        self.backgroundColor = UIColor.green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect){
        self.subviews.forEach({$0.removeFromSuperview()})
        let square_height = Double(rect.height)/60
        let square_width = Double(rect.width)/60
        
        
        height = square_height
        width = square_width
        
        for cell in c.colonyCells {
            let rect = CGRect(x: Double(cell.xCoor) * square_width, y: Double(cell.yCoor) * square_height, width: square_width, height: square_height)
            let thisView = UIView(frame: rect)
            thisView.backgroundColor = UIColor.red
            self.addSubview(thisView)
        }
        
        /*
        for x in 0...59{
            for y in 0...59{
                let rect = CGRect(x: Double(x) * square_width, y: Double(y) * square_height, width: square_width, height: square_height)
                                
                if(c.isCellAlive(x, yCoor: y)){
                    let thisView = UIView(frame: rect)
                    thisView.backgroundColor = UIColor.blue
                    self.addSubview(thisView)
                } else {
                    let thisView = UIView(frame: rect)
                    thisView.backgroundColor = UIColor.yellow
                    self.addSubview(thisView)
                }
            }
 
        }
    */
    
       
    }
}
