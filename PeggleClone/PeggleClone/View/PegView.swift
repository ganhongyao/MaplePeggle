//
//  PegView.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import SwiftUI

struct PegView: View {
    @ObservedObject var pegViewModel: PegViewModel

    @State var rotation: CGFloat = .zero

    var body: some View {
        ZStack {
            ZStack {
                getPegImage(color: pegViewModel.color)
                    .resizable()
                    .frame(width: pegViewModel.diameter, height: pegViewModel.diameter)
                    .rotationEffect(.radians(pegViewModel.facingAngle))
                    .position(pegViewModel.center)

                if pegViewModel.isSelected {
                    Circle()
                        .fill(.blue)
                        .frame(width: ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter,
                               height: ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter)
                        .position(pegViewModel.center)
                }
            }
            .gesture(DragGesture().onChanged { value in
                pegViewModel.selectPeg()
                pegViewModel.movePeg(to: value.location)
            })
            .onLongPressGesture {
                pegViewModel.removePeg()
            }

            if pegViewModel.isSelected {
                Image(systemName: "arrow.clockwise.circle")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter,
                           height: ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter)
                    .position(x: pegViewModel.center.x,
                              y: pegViewModel.center.y + pegViewModel.radius +
                              ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter)
            }

        }

    }
}
