//
//  BlockView.swift
//  PeggleClone
//
//  Created by Hong Yao on 21/2/22.
//

import SwiftUI

struct LevelDesignerBlockView: View {
    @ObservedObject var blockViewModel: LevelDesignerBlockViewModel

    var yOffset: CGFloat = 0

    private var verticesWithOffset: [CGPoint] {
        blockViewModel.vertices.map { $0.offset(y: yOffset) }
    }

    private var blockShapeView: Path {
        Path { path in
            path.addLines(verticesWithOffset)
            path.closeSubpath()
        }
    }

    private var mainBlockView: some View {
        ZStack {
            blockShapeView.fill(.brown)
            blockShapeView.stroke(.black, lineWidth: ViewConstants.blockOutlineLineWidth)
        }
    }

    var body: some View {
        ZStack {
            mainBlockView

            if blockViewModel.isSelected {
                ForEach(verticesWithOffset.indices) { idx in
                    let vertex = verticesWithOffset[idx]
                    Circle()
                        .fill(ViewConstants.levelDesignerSelectionColor)
                        .frame(width: ViewConstants.blockVertexCircleDiameter,
                               height: ViewConstants.blockVertexCircleDiameter)
                        .position(vertex)
                        .gesture(DragGesture().onChanged { value in
                            blockViewModel.moveVertex(vertexIdx: idx, to: value.location)
                        })
                }
            }
        }
        .onLongPressGesture {
            blockViewModel.removeBlock()
        }
    }
}
