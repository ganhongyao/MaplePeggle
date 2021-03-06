//
//  LevelSelectorPegView.swift
//  MaplePeggle
//
//  Created by Hong Yao on 18/1/22.
//

import SwiftUI

struct LevelSelectorPegView: View {
    @ObservedObject var pegViewModel: LevelDesignerPegViewModel

    @State var rotation: CGFloat = .zero

    var body: some View {
        ZStack {
            getPegImage(color: pegViewModel.color)
                .resizable()
                .frame(width: pegViewModel.diameter, height: pegViewModel.diameter)
                .rotationEffect(.radians(pegViewModel.facingAngle))
                .position(pegViewModel.center)

            if pegViewModel.isSelected {
                Circle()
                    .fill(ViewConstants.levelDesignerSelectionColor)
                    .frame(width: ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter,
                           height: ViewConstants.pegEditingCircleFractionOfDiameter * pegViewModel.diameter)
                    .position(pegViewModel.center)
            }
        }
        .onLongPressGesture {
            pegViewModel.removePeg()
        }
    }
}
