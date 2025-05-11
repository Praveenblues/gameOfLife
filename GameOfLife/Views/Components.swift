//
//  Components.swift
//  GameOfLife
//
//  Created by Praveen V on 11/05/25.
//

import SwiftUI

struct PlayButton: View {
    var textLabel: String
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(textLabel)
                .padding(5)
                .frame(width: 60, height: 60, alignment: .center)
                .background(Constants.Colors.pause)
                .clipShape(Circle())
        }
    }
}


struct DestroyButton: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Text("X")
                .bold()
                .frame(width: 50, height: 50, alignment: .center)
                .foregroundStyle(Color.white)
                .background(Constants.Colors.close)
                .clipShape(Circle())
                .offset(y: 15)
        }
    }
}


struct GenericButton: View {
    var textLabel: String?
    var imageName: String?
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            if let textLabel {
                Text(textLabel)
                    .bold()
                    .frame(height: 20)
                    .foregroundStyle(Color.lime)
                    .padding([.all], 10)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
            } else if let imageName {
                Image(imageName)
                    .resizable()
                    .tint(Color.lime)
                    .frame(width: 30, height: 30)
                    .padding([.all], 5)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)
            }
        }
    }
}
