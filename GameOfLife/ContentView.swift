//
//  ContentView.swift
//  GameOfLife
//
//  Created by Praveen V on 10/05/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
        var itemSize: CGFloat = 20
        var body: some View {
            GeometryReader { geometry in
                let (totalWidth, totalHeight) = (geometry.size.width, geometry.size.height)
                let spacing: CGFloat = 0
                let columnsCount = max(Int((totalWidth + spacing) / (itemSize + spacing)), 1)
                let rowsCount = max(Int((totalHeight + spacing) / (itemSize + spacing)), 1)
                ZStack(alignment: .bottom) {
                    BodyView(count: rowsCount * columnsCount, columnsCount: columnsCount)
                    
                }
                
            }
            .ignoresSafeArea()
        }
}


struct BodyView: View {
    var itemSize: CGFloat = 20
    var count = 0
    var columnsCount = 1
    
    @ObservedObject var viewModel: GameOfLifeViewModel
    
    init(itemSize: CGFloat = 20, count: Int, columnsCount: Int) {
        self.itemSize = itemSize
        self.count = count
        self.columnsCount = columnsCount
        self.viewModel = GameOfLifeViewModel(count: count, columnsCount: columnsCount)
    }
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: columnsCount)
        ZStack(alignment: .bottom) {
            makeGrid(columns: columns)
            HStack {
                Button {
                    viewModel.startTimer()
                } label: {
                    Text("Start")
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                Spacer()
                Button {
                    viewModel.stop()
                } label: {
                    Text("Stop")
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.green)
                        .clipShape(Circle())
                }

            }
            .padding()
        }
    }
    
    @ViewBuilder func makeGrid(columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(Array(viewModel.cells.enumerated()), id: \.element) { (index, item) in
                Button {
                    print("tapped \(index)")
                    viewModel.cellTapped(index: index)
                } label: {
                    Rectangle().fill(item.isAlive ? Color.red : Color.white)
                }
                .frame(width: itemSize, height: itemSize)
                .overlay {
                    Rectangle()
                        .stroke(Color.gray, lineWidth: 1)
                        .opacity(0.25)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(0)
    }
}

#Preview {
    ContentView()
}
