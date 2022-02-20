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
            .gesture(DragGesture().onChanged { value in
                pegViewModel.movePeg(to: value.location)
            })
    }
}
