//
//  BoardObject.swift
//  PeggleClone
//
//  Created by Hong Yao on 22/2/22.
//

import Foundation
import PhysicsEngine

protocol BoardObject: Shape {
    var id: UUID? { get }
}
