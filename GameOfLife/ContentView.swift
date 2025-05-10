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


extension Color {
    static let lime: Color = .init(red: 203/255, green: 232/255, blue: 100/255)
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
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(Color.lime)
                        .clipShape(Circle())
                }
                Spacer()
                Button {
                    viewModel.clearAll()
                } label: {
                    Text("X")
                        .frame(width: 50, height: 50, alignment: .center)
                        .foregroundStyle(Color.white)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(y: 15)
                }
                Spacer()
                Button {
                    viewModel.stop()
                } label: {
                    Text("Pause")
                        .padding(5)
                        .frame(width: 60, height: 60, alignment: .center)
                        .background(Color.lime)
                        .clipShape(Circle())
                }

            }
            .opacity(0.75)
            .padding()
        }
    }
    
    @ViewBuilder func makeGrid(columns: [GridItem]) -> some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(viewModel.cells, id: \.self) { item in
                Button {
                    print("tapped \(item.index)")
                    viewModel.cellTapped(index: item.index)
                } label: {
                    Rectangle()
                        .fill(item.isAlive ? Color(red: 255/255, green: 200/255, blue: 150/255) : Color.white)
                }
                .frame(width: itemSize, height: itemSize)
                .overlay {
                    Rectangle()
                        .stroke(Color.gray, lineWidth: 1)
                        .opacity(0.25)
                        .background(Color.clear)
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
