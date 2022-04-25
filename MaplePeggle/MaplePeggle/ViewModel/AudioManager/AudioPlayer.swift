//
//  AudioPlayer.swift
//  MaplePeggle
//
//  Created by Hong Yao on 26/2/22.
//

import AVFoundation

class AudioPlayer {
    private static let mp3FileExtension = "mp3"

    static let sharedInstance = AudioPlayer()

    /// Shared music
    private var titlePlayer: AVAudioPlayer?
    private var floralLifePlayer: AVAudioPlayer?
    private var goPicnicPlayer: AVAudioPlayer?

    /// GameMaster-specific music
    private var restNPeacePlayer: AVAudioPlayer?
    private var nightmarePlayer: AVAudioPlayer?
    private var whenTheMorningComesPlayer: AVAudioPlayer?
    private var badGuysPlayer: AVAudioPlayer?

    /// Shared sound effects
    private var bouncePlayer: AVAudioPlayer?
    private var tapPlayer: AVAudioPlayer?
    private var victoryPlayer: AVAudioPlayer?
    private var defeatPlayer: AVAudioPlayer?

    private var soundToPlayerMap: [Sound: AVAudioPlayer?] {
        [
            .title: titlePlayer,
            .floralLife: floralLifePlayer,
            .goPicnic: goPicnicPlayer,

            .restNPeace: restNPeacePlayer,
            .nightmare: nightmarePlayer,
            .whenTheMorningComes: whenTheMorningComesPlayer,
            .badGuys: badGuysPlayer,

            .bounce: bouncePlayer,
            .tap: tapPlayer,
            .victory: victoryPlayer,
            .defeat: defeatPlayer
        ]
    }

    private init() {
        titlePlayer = initializePlayerForSound(sound: .title)
        floralLifePlayer = initializePlayerForSound(sound: .floralLife)
        goPicnicPlayer = initializePlayerForSound(sound: .goPicnic)

        restNPeacePlayer = initializePlayerForSound(sound: .restNPeace)
        nightmarePlayer = initializePlayerForSound(sound: .nightmare)
        whenTheMorningComesPlayer = initializePlayerForSound(sound: .whenTheMorningComes)
        badGuysPlayer = initializePlayerForSound(sound: .badGuys)

        bouncePlayer = initializePlayerForSound(sound: .bounce, soundWillLoop: false)
        tapPlayer = initializePlayerForSound(sound: .tap, soundWillLoop: false)
        victoryPlayer = initializePlayerForSound(sound: .victory, soundWillLoop: false)
        defeatPlayer = initializePlayerForSound(sound: .defeat, soundWillLoop: false)
    }

    private func initializePlayerForSound(sound: Sound, soundWillLoop: Bool = true) -> AVAudioPlayer? {
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

        if soundWillLoop {
            player.numberOfLoops = -1
        }

        return player
    }

    func play(sound: Sound, withFadeDuration fadeDuration: Double = 0.0) {
        guard let optionalPlayer = soundToPlayerMap[sound],
              let player = optionalPlayer else {
                  return
              }

        // Cancel any current plays
        player.stop()

        let initialVolume = player.volume

        player.volume = .zero
        player.play()
        player.setVolume(initialVolume, fadeDuration: fadeDuration)
    }

    func stop(sound: Sound, withFadeDuration fadeDuration: Double = 0.0) {
        guard let optionalPlayer = soundToPlayerMap[sound],
              let player = optionalPlayer else {
                  return
              }

        let initialVolume = player.volume

        player.setVolume(.zero, fadeDuration: fadeDuration)
        player.stop()
        player.currentTime = 0

        player.volume = initialVolume
    }

}
