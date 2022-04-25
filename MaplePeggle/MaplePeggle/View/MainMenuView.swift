//
//  MainMenuView.swift
//  MaplePeggle
//
//  Created by Hong Yao on 26/2/22.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image(ViewConstants.titleBackgroundImage)
                    .resizable()
                    .scaledToFill()

                VStack {
                    NavigationLink(destination: LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())) {
                        Label(ViewConstants.mainMenuCreateLevelText,
                              systemImage: ViewConstants.levelSelectorCreateButtonImage)
                    }.padding(.bottom)

                    NavigationLink(destination: LevelSelectorView()) {
                        Label(ViewConstants.mainMenuLoadLevelText,
                              systemImage: ViewConstants.levelSelectorCreateButtonImage)
                    }
                }
                .buttonStyle(.bordered)
                .labelStyle(.titleOnly)
            }
            .navigationBarHidden(true)
            .navigationTitle(ViewConstants.mainMenuNavTitle)
            .onAppear {
                AudioPlayer.sharedInstance.play(sound: .title, withFadeDuration: ViewConstants.audioFadeDuration)
            }
            .onDisappear {
                AudioPlayer.sharedInstance.stop(sound: .title, withFadeDuration: ViewConstants.audioFadeDuration)
            }
        }
        .navigationViewStyle(.stack)

    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
