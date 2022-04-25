//
//  PowerupDescriptor.swift
//  MaplePeggle
//
//  Created by Hong Yao on 23/2/22.
//

enum PowerupDescriptor {
    case kaboom
    case spookyBall
    case bucketExpansion
    case crossZapper

    private static var kaboomDescription: String {
        "Creates an explosion centered at the hit green peg, destroying any pegs that are nearby."
    }

    private static var spookyBallDescription: String {
        """
        Once the current ball leaves the board, it spookily reappears at the top of the board at \
        the same x-axis position.
        """
    }

    private static var bucketExpansionDescription: String {
        """
        Increases the size of the portal by a certain proportion, making it easier to earn free balls. \
        Effective only for the current ball.
        """
    }

    private static var crossZapperDescription: String {
        "Creates two streaks horizontally and vertically from the green peg, lighting up any pegs in their paths."
    }

    var description: String {
        switch self {
        case .kaboom:
            return PowerupDescriptor.kaboomDescription
        case .spookyBall:
            return PowerupDescriptor.spookyBallDescription
        case .bucketExpansion:
            return PowerupDescriptor.bucketExpansionDescription
        case .crossZapper:
            return PowerupDescriptor.crossZapperDescription
        }
    }
}
