//
//  Pexels.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation

// MARK: - Pexels
struct Pexels: Codable {
    let videos: [Video]
}

// MARK: - Video
struct Video: Codable {
    let id, width, height, duration: Int
    let url: String
    let image: String
    let user: User
    let videoFiles: [VideoFile]

    enum CodingKeys: String, CodingKey {
        case id, width, height, duration
        case url, image
        case user
        case videoFiles = "video_files"
    }
}

// MARK: - User
struct User: Codable {
    let id: Int
    let name: String
    let url: String
}

// MARK: - VideoFile
struct VideoFile: Codable {
    let id: Int
    let quality: Quality
    let fileType: FileType
    let width, height: Int?
    let link: String

    enum CodingKeys: String, CodingKey {
        case id, quality
        case fileType = "file_type"
        case width, height, link
    }
}

enum FileType: String, Codable {
    case videoMp4 = "video/mp4"
}

enum Quality: String, Codable {
    case hd = "hd"
    case hls = "hls"
    case sd = "sd"
}

extension Pexels {
    
    static var stubbedResponse: Pexels {
        let responses: Pexels? = try? Bundle.main.loadAndDecodeJSON(filename: "response")
        return responses ?? Pexels(videos: [])
    }
    
    static var stubbedVideos: [Video] {
        stubbedResponse.videos
    }
}

