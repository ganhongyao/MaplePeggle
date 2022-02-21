//
//  BlockView.swift
//  PeggleClone
//
//  Created by Hong Yao on 21/2/22.
//

import SwiftUI

struct BlockView: View {
    @ObservedObject var blockViewModel: BlockViewModel

    private var shape: Path {
        Path { path in
            path.addLines([blockViewModel.vertex1, blockViewModel.vertex2, blockViewModel.vertex3])
            path.closeSubpath()
        }
    }

    var body: some View {
        ZStack {
            shape.fill(.brown)
            shape.stroke(.black, lineWidth: 2)
        }
    }
}
