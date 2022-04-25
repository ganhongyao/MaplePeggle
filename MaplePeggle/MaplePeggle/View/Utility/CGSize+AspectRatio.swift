//
//  CGSize+AspectRatio.swift
//  MaplePeggle
//
//  Created by Hong Yao on 26/2/22.
//

import CoreGraphics

extension CGSize {
    var aspectRatio: CGFloat {
        width / height
    }
}
