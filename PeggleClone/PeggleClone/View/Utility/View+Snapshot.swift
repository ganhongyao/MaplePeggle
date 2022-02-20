//
//  View+Snapshot.swift
//  PeggleClone
//
//  Created by Hong Yao on 26/1/22.
//

import Foundation
import SwiftUI

extension View {
    func snapshot(capturingRect: CGRect) -> UIImage {
        let controller = UIHostingController(rootView: edgesIgnoringSafeArea(.all))
        let view = controller.view

        view?.bounds = capturingRect
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: capturingRect.size)

        return renderer.image { _ in
            view?.drawHierarchy(in: capturingRect, afterScreenUpdates: true)
        }
    }
}
