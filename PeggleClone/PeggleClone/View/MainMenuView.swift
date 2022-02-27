//
//  MainMenuView.swift
//  PeggleClone
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

                VStack(alignment: .leading) {
                    NavigationLink(destination: LevelDesignerView(levelDesignerViewModel: LevelDesignerViewModel())) {
                        Text(ViewConstants.mainMenuCreateLevelText)
                    }

                    NavigationLink(destination: LevelSelectorView()) {
                        Text(ViewConstants.mainMenuLoadLevelText)
                    }
                }
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
