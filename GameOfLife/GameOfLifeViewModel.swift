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
        var cellsToModify: [Int] = []
        for modifiedCell in previouslyModifiedCells {
            cellsToModify.append(modifiedCell)
            cellsToModify.append(contentsOf: surroundingCells[modifiedCell] ?? [])
        }
        cellsToModify = Array(Set(cellsToModify))
        cellsToModify.forEach { modifyCell(index: $0) }
    }
    
    func modifyCell(index: Int) {
        let numberOfLivingNeighbors = getSurroundingCells(around: index).filter { cells[$0].isAlive }.count
        if cells[index].isAlive {
            if numberOfLivingNeighbors < 2 || numberOfLivingNeighbors > 3 {
                cells[index].isAlive = false
                previouslyModifiedCells.append(index)
            }
        } else {
            if numberOfLivingNeighbors == 3 {
                cells[index].isAlive = true
                previouslyModifiedCells.append(index)
            }
        }
    }
    
    func getSurroundingCells(around center: Int) -> [Int] {
        []
    }
    
    
    
    //MARK: Events
    
    func cellTapped(index: Int) {
        cells[index].isAlive.toggle()
        previouslyModifiedCells.append(index)
    }
    
    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.previouslyModifiedCells.removeAll()
                self?.updateState()
            })
    }
    
    func stop() {
        timer?.cancel()
    }
}
