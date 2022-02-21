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
            path.addLines(blockViewModel.vertices)
            path.closeSubpath()
        }
    }

    var body: some View {
        ZStack {
            shape.fill(.brown)
            shape.stroke(.black, lineWidth: ViewConstants.blockOutlineLineWidth)

            if blockViewModel.isSelected {
                ForEach(blockViewModel.vertices.indices) { idx in
                    let vertex = blockViewModel.vertices[idx]
                    Circle()
                        .fill(.blue)
                        .frame(width: ViewConstants.blockVertexCircleDiameter,
                               height: ViewConstants.blockVertexCircleDiameter)
                        .position(x: vertex.x, y: vertex.y)
                        .gesture(DragGesture().onChanged { value in
                            blockViewModel.moveVertex(vertexIdx: idx, to: value.location)
                        })
                }
            }
        }
        .gesture(DragGesture().onChanged { value in
            blockViewModel.selectBlock()
            blockViewModel.moveBlock(to: value.location)
        })
        .onLongPressGesture {
            blockViewModel.removeBlock()
        }
    }
}
