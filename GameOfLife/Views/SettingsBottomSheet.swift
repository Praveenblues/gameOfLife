//
//  BottomSheet.swift
//  GameOfLife
//
//  Created by Praveen V on 11/05/25.
//

import SwiftUI
import Foundation

struct SettingsBottomSheet: View {
    var showingSheet: Binding<Bool>
    var sliderValue: Binding<Float>
    var doneAction: () -> Void
    var resetAction: (() -> Void)?
    var previewAction: (() -> Void)
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Settings")
                .foregroundStyle(Color.black.opacity(0.5))
            HStack {
                Text("Speed:")
                    .foregroundStyle(Color.black.opacity(0.5))
                Slider(value: sliderValue, in: 0...1) { editingChanged in
                    print("editingChanged", editingChanged)
                    if !editingChanged {
                        previewAction()
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 40)
                .tint(Color.lime)
            }
            HStack(spacing: 50) {
                Spacer()
                if let resetAction {
                    GenericButton(textLabel: "Reset") {
                        resetAction()
                    }
                }
                GenericButton(textLabel: "Done") {
                    doneAction()
                    showingSheet.wrappedValue = false
                }
                Spacer()
            }
        }
        .padding()
        .background(content: {
            Color.lime.opacity(0.2)
        })
        
    }
}
