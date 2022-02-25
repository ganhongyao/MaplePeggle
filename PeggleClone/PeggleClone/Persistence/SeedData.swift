//
//  SeedData.swift
//  PeggleClone
//
//  Created by Hong Yao on 25/2/22.
//

import Foundation
import CoreGraphics

 struct SeedData {
     private static let seedBoards = [seedBoard1, seedBoard2, seedBoard3]

     private static let seedBoard1 = Board(id: UUID(),
                                   name: "Preloaded 1",
                                   size: CGSize(width: 700, height: 800),
                                   snapshot: nil,
                                   pegs: [],
                                   blocks: [],
                                   isSeedData: true)

     private static let seedBoard2 = Board(id: UUID(),
                                   name: "Preloaded 2",
                                   size: CGSize(width: 700, height: 800),
                                   snapshot: nil,
                                   pegs: [],
                                   blocks: [],
                                   isSeedData: true)

     private static let seedBoard3 = Board(id: UUID(),
                                   name: "Preloaded 3",
                                   size: CGSize(width: 700, height: 800),
                                   snapshot: nil,
                                   pegs: [],
                                   blocks: [],
                                   isSeedData: true)

     static func seedAllBoards(database: PersistenceManager) throws {
         for board in [seedBoard1, seedBoard2, seedBoard3] {
             try database.save(model: board)
         }
     }

 }
