//
//  ContentBodyViewModel.swift
//  GameOfLife
//
//  Created by Praveen V on 10/05/25.
//

struct Cell: Hashable {
    var index: Int?
    var isAlive = false
}

import Foundation
import Combine

class GameOfLifeViewModel: ObservableObject {
    @Published var cells: [Cell] = []
    var timer: AnyCancellable?
    var previouslyModifiedCells: [Int] = []
    var surroundingCells: [Int:[Int]] = [:]
    
    var count: Int
    var columnsCount: Int
    
    init(count: Int = 0, columnsCount: Int = 0) {
        self.count = count
        self.columnsCount = columnsCount
        initialize()
    }
    
    private func initialize() {
        var temp: [Cell] = []
        for index in 0..<count {
            temp.append(Cell(index: index))
        }
        cells = temp
    }
    
    
    func updateState() {
//        print("previouslyModifiedCells are")
//        print(previouslyModifiedCells)
        
        var cellsToCheck: [Int] = []
        for modifiedCell in previouslyModifiedCells {
            cellsToCheck.append(modifiedCell)
            cellsToCheck.append(contentsOf: surroundingCells[modifiedCell] ?? getSurroundingCells(around: modifiedCell))
        }
        cellsToCheck = Array(Set(cellsToCheck))
        previouslyModifiedCells.removeAll()
        for index in getCellsToToggle(cellsToCheck: cellsToCheck) {
            cells[index].isAlive.toggle()
        }
    }
    
    func getCellsToToggle(cellsToCheck: [Int]) -> [Int] {
        var cellsToModify: [Int] = []
        for index in cellsToCheck {
            let numberOfLivingNeighbors = (surroundingCells[index] ?? getSurroundingCells(around: index)).filter { cells[$0].isAlive }.count
            print("living neighbors of \(index) is \(numberOfLivingNeighbors)")
            if cells[index].isAlive {
                if numberOfLivingNeighbors < 2 || numberOfLivingNeighbors > 3 {
                    cellsToModify.append(index)
                    previouslyModifiedCells.append(index)
                }
            } else {
                if numberOfLivingNeighbors == 3 {
                    cellsToModify.append(index)
                    previouslyModifiedCells.append(index)
                }
            }
        }
        return cellsToModify
    }
    
    enum Edge {
        case Top
        case Bottom
        case Left
        case Right
    }
    
    func getSurroundingCells(around center: Int) -> [Int] {
        let top = center - columnsCount
        let bottom = center + columnsCount
        let left = center - 1
        let right = center + 1
        let topLeft = center-1-columnsCount
        let topRight = center+1-columnsCount
        let bottomLeft = center-1+columnsCount
        let bottomRight = center+1+columnsCount
        
        if center == 0 {
            return [right,bottom,bottomRight]
        }
        if center == columnsCount-1 {
            return [left,bottomLeft,bottom]
        }
        if center == count-1 {
            return [left,topLeft,top]
        }
        if center == count-columnsCount+1 {
            return [right,top,topRight]
        }
        
        // Adding 4 directional cells
        var edge: Edge?
        var result: [Int] = []
        if !(center % columnsCount == 0) {
            // Not on left edge
            result.append(left)
        } else {
            edge = .Left
        }
        if !((center + 1) % columnsCount == 0) {
            // Not on right edge
            result.append(right)
        } else {
            edge = .Right
        }
        if !(0...columnsCount-1).contains(center) {
            // Not on Top edge
            result.append(top)
        } else {
            edge = .Top
        }
        if !((count-columnsCount+1)...(count-1)).contains(center) {
            // Not on Bottom edge
            result.append(bottom)
        } else {
            edge = .Bottom
        }
        
        // Adding 4 diagonal cells
        let topdiagonals: [Int] = [center-1-columnsCount, center+1-columnsCount]
        if let edge = edge {
            switch edge {
                case .Left:
                result.append(contentsOf: [topRight, bottomRight])
            case .Right:
                result.append(contentsOf: [topLeft, bottomLeft])
            case .Top:
                result.append(contentsOf: [bottomLeft, bottomRight])
            case .Bottom:
                result.append(contentsOf: [topLeft, topRight])
            }
        } else {
            // Not on any of the edges
            result.append(contentsOf: [topLeft, topRight, bottomLeft, bottomRight])
        }
        result.removeAll(where: {$0 >= count})
        surroundingCells[center] = result
        return result
    }
    
    
    
    //MARK: Events
    
    func cellTapped(index: Int) {
        cells[index].isAlive.toggle()
        previouslyModifiedCells.append(index)
        surroundingCells[index] = getSurroundingCells(around: index)
    }
    
    func startTimer() {
        timer = Timer.publish(every: 0.25, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.updateState()
            })
    }
    
    func stop() {
        timer?.cancel()
    }
    
    func clearAll() {
        timer?.cancel()
        timer = nil
        for index in cells.indices {
            cells[index].isAlive = false
        }
    }
}
