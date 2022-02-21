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
        getPegImage(color: pegViewModel.color)
            .resizable()
            .frame(width: pegViewModel.diameter, height: pegViewModel.diameter)
            .position(pegViewModel.center)
            .modifier(TranslucentViewModifier(shouldBeTranslucent: pegViewModel.isSelected))
            .gesture(DragGesture().onChanged { value in
                pegViewModel.selectPeg()
                pegViewModel.movePeg(to: value.location)
            })
            .onLongPressGesture {
                pegViewModel.removePeg()
            }
    }
}
