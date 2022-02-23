//
//  GameMaster.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

struct GameMaster {
    static let availableGameMasters = [
        GameMaster(name: "Kaboom Owner", description: ViewConstants.loremIpsum, powerup: .kaboom),
        GameMaster(name: "Spooky Ball Owner", description: ViewConstants.loremIpsum, powerup: .spookyBall)
    ]

    let name: String

    let description: String

    let powerup: GameEffectDescriptor
}
