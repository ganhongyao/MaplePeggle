//
//  CGSize+AspectRatio.swift
//  PeggleClone
//
//  Created by Hong Yao on 26/2/22.
//

import CoreGraphics

extension CGSize {
    var aspectRatio: CGFloat {
        width / height
    }
}
