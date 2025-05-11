//
//  ContentView.swift
//  GameOfLife
//
//  Created by Praveen V on 10/05/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    var itemSize: CGFloat = Constants.Dimensions.cellSize
        var body: some View {
            GeometryReader { geometry in
                let (totalWidth, totalHeight) = (geometry.size.width, geometry.size.height)
                let spacing: CGFloat = 0
                let columnsCount = max(Int((totalWidth + spacing) / (itemSize + spacing)), 1)
                let rowsCount = max(Int((totalHeight + spacing) / (itemSize + spacing)), 1)
                ZStack(alignment: .bottom) {
                    BodyView(count: rowsCount * columnsCount, columnsCount: columnsCount, safeAreaTopOffset: safeAreaInsets.top)
                }
            }
            .ignoresSafeArea()
        }
}


extension Color {
    static let lime: Color = .init(red: 203/255, green: 232/255, blue: 100/255)
    static let alive: Color = Color(red: 255/255, green: 200/255, blue: 150/255)
}

struct BodyView: View {
    var itemSize: CGFloat = Constants.Dimensions.cellSize
    var count = 0
    var columnsCount = 1
    var safeAreaTopOffset: CGFloat = 0
    
    @ObservedObject var viewModel: GameOfLifeViewModel
    @State var showSettingsSheet: Bool = false
    
    init(itemSize: CGFloat = 20, count: Int, columnsCount: Int, safeAreaTopOffset: CGFloat) {
        self.itemSize = itemSize
        self.count = count
        self.columnsCount = columnsCount
        self.safeAreaTopOffset = safeAreaTopOffset
        self.viewModel = GameOfLifeViewModel(count: count, columnsCount: columnsCount)
    }
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: columnsCount)
        ZStack(alignment: .topTrailing) {
            ZStack(alignment: .bottom) {
                makeGrid(columns: columns)
                HStack {
                    PlayButton(textLabel: "Start") {
                        viewModel.startTimer()
                    }
                    Spacer()
                    DestroyButton {
                        viewModel.clearAll()
                    }
                    Spacer()
                    PlayButton(textLabel: "Pause") {
                        viewModel.stop()
                    }
                }
                .opacity(0.75)
                .padding()
            }
            GenericButton(imageName: "gearicon", action: {
                withAnimation {
                    showSettingsSheet = true
                }
            })
            .padding()
            .offset(y: safeAreaTopOffset)
        }
        .sheet(isPresented: $showSettingsSheet) {
            SettingsBottomSheet(showingSheet: $showSettingsSheet,
                        sliderValue: $viewModel.sliderValue,
                        doneAction: viewModel.saveSliderToUserDefaults,
                        resetAction: viewModel.settingDiscarded,
                        previewAction: viewModel.previewSpeed)
            .presentationDetents([.height(150)])
        }
        .onChange(of: showSettingsSheet) { oldValue, newValue in
            if !newValue {
                viewModel.settingDiscarded()
            }
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
                        .fill(item.isAlive ? Constants.Colors.alive : Constants.Colors.dead)
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
