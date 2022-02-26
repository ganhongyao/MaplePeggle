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
                Image(ViewConstants.coralBackgroundImage)
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
                AudioPlayer.sharedInstance.play(sound: .title)
            }
            .onDisappear {
                AudioPlayer.sharedInstance.stop(sound: .title)
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
