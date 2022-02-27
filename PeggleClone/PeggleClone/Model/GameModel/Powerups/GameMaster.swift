//
//  GameMaster.swift
//  PeggleClone
//
//  Created by Hong Yao on 23/2/22.
//

struct GameMaster {
    static let availableGameMasters = [archer, magician, thief, warrior]

    static let archer = GameMaster(name: "Archer", description: ViewConstants.loremIpsum, powerup: .kaboom)
    static let magician = GameMaster(name: "Magician", description: ViewConstants.loremIpsum, powerup: .spookyBall)
    static let thief = GameMaster(name: "Thief", description: ViewConstants.loremIpsum, powerup: .kaboom)
    static let warrior = GameMaster(name: "Warrior", description: ViewConstants.loremIpsum, powerup: .kaboom)

    let name: String

    let description: String

    let powerup: PowerupDescriptor
}

extension GameMaster: Equatable {

}
