//
//  SeedData.swift
//  MaplePeggle
//
//  Created by Hong Yao on 25/2/22.
//

import Foundation
import CoreGraphics

 struct SeedData {
     static func seedAllBoards(database: PersistenceManager) throws {
         for board in seedBoards {
             try database.save(model: board)
         }
     }

     private static let seedBoards = [tridentBoard, cocktailBoard, diamondBoard]

     private static var tridentBoard: Board {
         let pegs: Set<Peg> = [Peg(center: CGPoint(x: 125, y: 150.0), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 125, y: 200.1), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 125, y: 250.2), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 125, y: 300.3), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 125, y: 350.4), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 125, y: 400.5), radius: 25, color: .blue),

                               Peg(center: CGPoint(x: 335, y: 150.0), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 200.1), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 250.2), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 300.3), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 350.4), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 400.5), radius: 25, color: .orange),

                               Peg(center: CGPoint(x: 545, y: 150.0), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 545, y: 200.1), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 545, y: 250.2), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 545, y: 300.3), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 545, y: 350.4), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 545, y: 400.5), radius: 25, color: .blue),

                               Peg(center: CGPoint(x: 178, y: 400.5), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 231, y: 400.5), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 284, y: 400.5), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 388, y: 400.5), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 441, y: 400.5), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 494, y: 400.5), radius: 25, color: .blue),

                               Peg(center: CGPoint(x: 335, y: 450.6), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 500.7), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 550.8), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 600.9), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 651.0), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 701.1), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 751.2), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 801.3), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 851.4), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 901.5), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 951.6), radius: 25, color: .blue),
                               Peg(center: CGPoint(x: 335, y: 1_001.7), radius: 25, color: .blue)]

         let board = Board(name: "Trident",
                           baseSize: CGSize(width: 700, height: 800), size: CGSize(width: 700, height: 1_100),
                           snapshot: nil, pegs: pegs, blocks: [],
                           id: UUID(), isSeedData: true)

         return board
     }

     private static var cocktailBoard: Board {

         let pegs: Set<Peg> = [Peg(center: CGPoint(x: 401.5, y: 349.5), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 379.5, y: 576.5), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 269.0, y: 395.5), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 332.0, y: 351.0), radius: 44.0, color: .green),
                               Peg(center: CGPoint(x: 306.0, y: 430.0), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 402.0, y: 402.5), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 329.5, y: 577.5), radius: 25.0, color: .orange),
                               Peg(center: CGPoint(x: 403.0, y: 293.0), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 330.0, y: 527.5), radius: 25.0, color: .orange),
                               Peg(center: CGPoint(x: 279.5, y: 576.0), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 261.5, y: 344.0), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 357.5, y: 430.5), radius: 25.0, color: .blue),
                               Peg(center: CGPoint(x: 328.5, y: 477.5), radius: 25.0, color: .green),
                               Peg(center: CGPoint(x: 269.5, y: 291.5), radius: 25.0, color: .blue)]

         let board = Board(name: "Cocktail",
                           baseSize: CGSize(width: 500, height: 650), size: CGSize(width: 500, height: 650),
                           snapshot: nil, pegs: pegs, blocks: [],
                           id: UUID(), isSeedData: true)

         return board
     }

     private static var diamondBoard: Board {
         let pegs: Set<Peg> = [
            Peg(center: CGPoint(x: 60.5, y: 415), radius: 25.0, color: .green),
            Peg(center: CGPoint(x: 129.0, y: 415), radius: 25.0, color: .green),
            Peg(center: CGPoint(x: 186.5, y: 415), radius: 25.0, color: .green),
            Peg(center: CGPoint(x: 254.0, y: 415), radius: 25.0, color: .green),

            Peg(center: CGPoint(x: 444.0, y: 415), radius: 25.0, color: .green),
            Peg(center: CGPoint(x: 513.0, y: 415), radius: 25.0, color: .green),
            Peg(center: CGPoint(x: 584.5, y: 415), radius: 25.0, color: .green),
            Peg(center: CGPoint(x: 650, y: 415), radius: 25.0, color: .green),

            Peg(center: CGPoint(x: 340, y: 60.0), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 131.0), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 189.0), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 250.0), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 307.0), radius: 25.0, color: .blue),

            Peg(center: CGPoint(x: 340, y: 489.0), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 553.5), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 619.5), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 688.5), radius: 25.0, color: .blue),
            Peg(center: CGPoint(x: 340, y: 742.5), radius: 25.0, color: .orange),

            Peg(center: CGPoint(x: 340, y: 415), radius: 25.0, color: .green)
         ]

         let blocks: Set<Block> =  [
            Block(vertices: [CGPoint(x: 275, y: 35), CGPoint(x: 275, y: 371), CGPoint(x: 5, y: 371)]),
            Block(vertices: [CGPoint(x: 275, y: 451), CGPoint(x: 275, y: 792), CGPoint(x: 5, y: 451)]),
            Block(vertices: [CGPoint(x: 675, y: 451), CGPoint(x: 405, y: 792), CGPoint(x: 405, y: 451)]),
            Block(vertices: [CGPoint(x: 405, y: 35), CGPoint(x: 405, y: 371), CGPoint(x: 675, y: 371)])
         ]

         let board = Board(name: "Diamond",
                           baseSize: CGSize(width: 700, height: 800), size: CGSize(width: 700, height: 800),
                           snapshot: nil, pegs: pegs, blocks: blocks,
                           id: UUID(), isSeedData: true)

         return board
     }

 }
