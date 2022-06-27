//
//  RemoteUsersLoader.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation

protocol UsersLoader {
    func getVideos() async throws -> Pexels
}

struct UnexpectedValuesRepresentation: Error {}

final class RemoteUsersLoader: UsersLoader {
    private let master = "$2b$10$N8KKAT0f4kTyMUKtpRSVH.CprYXKcM9C4VvsEk4D7dOYa4/S92R36"
    private let access = "$2b$10$pwl61/2G7BJ8YhEhXNLQY.o5PmLGjYd1.lCJgIMDtTi42LQ.4v6Ue"
    
    func getVideos() async throws -> Pexels {
        let url = URL(string: Endpoints.Videos.rawValue)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue(master, forHTTPHeaderField: "X-Master-Key")
        request.setValue(access, forHTTPHeaderField: "X-Access-Key")
        request.setValue("false", forHTTPHeaderField: "X-Bin-Meta")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw UnexpectedValuesRepresentation()
        }

        return try JSONDecoder().decode(Pexels.self, from: data)
    }
}
