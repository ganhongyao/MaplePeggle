//
//  GameMaster.swift
//  MaplePeggle
//
//  Created by Hong Yao on 23/2/22.
//

struct GameMaster {
    static let availableGameMasters = [archer, magician, thief, warrior]

    static let archer = GameMaster(name: "Archer", powerup: .kaboom)
    static let magician = GameMaster(name: "Magician", powerup: .bucketExpansion)
    static let thief = GameMaster(name: "Thief", powerup: .spookyBall)
    static let warrior = GameMaster(name: "Warrior", powerup: .crossZapper)

    let name: String

    let powerup: PowerupDescriptor
}

extension GameMaster: Equatable {

}
