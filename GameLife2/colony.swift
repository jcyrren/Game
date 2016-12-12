//
//  colony.swift
//  colonyWithSets
//
//  Created by Bhavik Nagda on 9/22/16.
//  Copyright © 2016 BhavikNagda. All rights reserved.
//

import Foundation


// allows cell to conform to hashable protocol
func ==(cell1: Cell, cell2: Cell) -> Bool {
    return cell1.xCoor == cell2.xCoor && cell1.yCoor == cell2.yCoor
}

struct Cell : Hashable {
    
    init(x: Int, y: Int) {
        xCoor = x
        yCoor = y
    }
    
    let xCoor: Int
    let yCoor: Int
    
    var hashValue: Int {
        return xCoor*1000 + yCoor
    }
}



class Colony: CustomStringConvertible{
    
    // set containing cells
    var colonyCells = Set<Cell>()
    var generationNum = 0
    var wrapping: Bool = true
    
    // EXTRA CREDIT: specify size of board
    var size = 60
    
    // EXTRA CREDIT: specify print window
    var corner1 = (0, 0)
    var corner2 = (59, 59)
    
    // return true if killing cells
    func setCellOpposite(location: (Int, Int)) -> Bool {
        if location.0 >= corner1.0 && location.0 <= corner2.0 && location.1 >= corner1.1 && location.1 <= corner2.1 {
            if isCellAlive(location.0, yCoor: location.1){
                setCellDead(location.0, yCoor: location.1)
                return true
            } else {
                setCellAlive(location.0, yCoor: location.1)
                return false
            }
        }
        return false
    }
    
    
    // sets a cell with given coordinates alive
    func setCellAlive(_ xCoor: Int, yCoor: Int){
        colonyCells.insert(Cell(x: xCoor, y: yCoor))
        //print("Successfully born")
    }
    
    // sets a cell with given coordinates dead
    func setCellDead(_ xCoor: Int, yCoor: Int){
        if colonyCells.remove(Cell(x: xCoor, y: yCoor)) != nil{
            //print("Sucessfully died")
        } else {
            //print("Didn't die: ERROR")
        }
    }
    
    // resets entire colony
    func resetColony(){
        colonyCells.removeAll()
    }
    
    // graphically represents colony with print window
    var description: String {
        // print generation number
        var string = "Generation Number: \(generationNum) \n\n"
        
        // loop through coordinate system
        for x in corner1.0 ... corner2.0 {
            for y in corner1.1 ... corner2.1{
                if colonyCells.contains(Cell(x: x, y: y)) {
                    string += "*"
                } else {
                    string += " "
                }
            }
            string += "\n"
        }
        return string
    }
    
    // checks if cell is alive
    func isCellAlive(_ xCoor: Int, yCoor: Int) -> Bool {
        return colonyCells.contains(Cell(x: xCoor, y: yCoor))
    }
    
    // evolves to next generation
    func evolve(){
        
        // set of cells for next generation
        var newCells = Set<Cell>()
        
        // loops through all living cells
        for cell in colonyCells{
            
            // stores number of surrounding cells
            let surroundings = surroundCellNum(cell)
            let cellNum = surroundings.0
            
            // cells with 2 or 3 neighbors live on
            if cellNum == 2 || cellNum == 3 {
                newCells.insert(cell)
            }
            
            // array of surrounding cells
            let surrounding = surroundings.1
            
            // loops through surrounding cells
            for sur in surrounding {
                
                print(sur)
                
                // if 3 neighbors and within board, cell is born
                if surroundCellNum(sur).0 == 3 && inBoard(sur) {
                    newCells.insert(sur)
                }
            }
        }
        
        // sets new colony, increase generation
        colonyCells = newCells
        generationNum += 1
    }
    
    // checks if given cell is within board dimensions
    func inBoard(_ workCell: Cell) -> Bool{
        return workCell.xCoor < size && workCell.xCoor >= 0 && workCell.yCoor < size && workCell.yCoor >= 0
    }
    
    // returns number of living cells surrounding given cell
    func surroundCellNum(_ workCell: Cell)-> (Int, [Cell]){
        let xCoor = workCell.xCoor
        let yCoor = workCell.yCoor
        
        var surroundCell = 0
        
        // array containing boolean of surrounding cells (living vs dead)
        
        var leftX: Int
        var rightX: Int
        var upY: Int
        var downY: Int

        
        if wrapping {
            print("wrap")
            leftX = (xCoor - 1 + size) % size
            rightX = (xCoor + 1 + size) % size
            upY = (yCoor - 1 + size) % size
            downY = (yCoor + 1 + size) % size
        } else {
            leftX = xCoor - 1
            rightX = xCoor + 1
            upY = yCoor - 1
            downY = yCoor + 1
        }
        
        let cellArray = [Cell(x: leftX, y: upY),
                         Cell(x: xCoor, y: upY),
                         Cell(x: rightX, y: upY),
                         Cell(x: leftX, y: yCoor),
                         Cell(x: rightX, y: yCoor),
                         Cell(x: leftX, y: downY),
                         Cell(x: xCoor, y: downY),
                         Cell(x: rightX, y: downY)]
        
        
        // loops through array, counts living cells
        for cell in cellArray{
            if (colonyCells.contains(cell)) {
                surroundCell += 1
            }
        }
        
        return (surroundCell, cellArray)
    }
    
    // EXTRA CREDIT: returns tuple of bounding coordinates (xMin, yMin), (xMax, yMax)
    func boundingCoord()-> ((Int, Int), (Int, Int)){
        var minX = size - 1
        var minY = size - 1
        var maxX = 0
        var maxY = 0
        
        for cell in colonyCells{
            if(cell.xCoor < minX){
                minX = cell.xCoor
            }
            if(cell.yCoor < minY){
                minY = cell.yCoor
            }
            if(cell.xCoor > maxX){
                maxX = cell.xCoor
            }
            if(cell.yCoor > maxY){
                maxY = cell.yCoor
            }
        }
        return ((minX, minY), (maxX, maxY))
    }
    
    func copy() -> Colony {
        var c = Colony()
        c.colonyCells = colonyCells
        return c
    }
}
