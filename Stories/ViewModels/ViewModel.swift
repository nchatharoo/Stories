//
//  ViewModel.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation

class VideoViewModel {
    var video: Video
    
    init(video: Video) {
        self.video = video
    }
}

class ViewModel {
    let remoteLoader: RemoteUsersLoader
    
    var videos: [Video] = []
    
    init(remoteLoader: RemoteUsersLoader) {
        self.remoteLoader = remoteLoader
    }
        
    func getVideos() async {
        do {
            let pexels = try await remoteLoader.getVideos()
            self.videos = pexels.videos
        } catch {
            print(error)
            // if the requests has exceeded, use the stubbed data instead
            self.videos = Pexels.stubbedVideos
        }
    }
}
