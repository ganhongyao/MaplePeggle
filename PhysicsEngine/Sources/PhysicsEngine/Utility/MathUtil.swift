//
//  MathUtil.swift
//  
//
//  Created by Hong Yao on 22/2/22.
//

import Foundation

struct MathUtil {
    static func isOverlapping<T: Comparable>(interval1: (T, T), interval2: (T, T)) -> Bool {
        let (start1, end1) = interval1
        let (start2, end2) = interval2

        return start1 < end2 && start2 < end1
    }
}
