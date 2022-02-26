//
//  AudioPlayer.swift
//  PeggleClone
//
//  Created by Hong Yao on 26/2/22.
//

import AVFoundation

class AudioPlayer {
    private static let mp3FileExtension = "mp3"

    static let sharedInstance = AudioPlayer()

    private var titlePlayer: AVAudioPlayer?

    private var soundToPlayerMap: [Sound: AVAudioPlayer?] {
        [.title: titlePlayer]
    }

    private init() {
        titlePlayer = initializePlayerForSound(sound: .title)
    }

    private func initializePlayerForSound(sound: Sound) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: sound.rawValue, ofType: AudioPlayer.mp3FileExtension)

        guard let path = path else {
            print("Could not locate sound file for sound: \(sound)")
            return nil
        }

        let url = URL(fileURLWithPath: path)

        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            print("Could not load sound: \(sound)")
            return nil
        }

        return player
    }

    func play(sound: Sound) {
        soundToPlayerMap[sound]??.play()
    }

    func stop(sound: Sound) {
        soundToPlayerMap[sound]??.stop()
    }

}
