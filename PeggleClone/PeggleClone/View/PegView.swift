//
//  PegView.swift
//  PeggleClone
//
//  Created by Hong Yao on 18/1/22.
//

import SwiftUI

struct PegView: View {
    @ObservedObject var pegViewModel: PegViewModel

    var body: some View {
        ZStack {
            getPegImage(color: pegViewModel.color)
                .resizable()
                .frame(width: pegViewModel.diameter, height: pegViewModel.diameter)
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
    }
}
