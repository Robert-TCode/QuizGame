//  Created by TCode on 16/01/2021.

import Foundation
import QEngine

class DatabaseManager {
    private let persistenceDatabase: GameFetching
    private let useRemoteDatabase: Bool

    private let newworkReachability = NetworkReachability.shared

    init(persistentDatabase: GameFetching, useRemoteDatabase: Bool = false) {
        self.persistenceDatabase = persistentDatabase
        self.useRemoteDatabase = useRemoteDatabase
    }

    func fetchGameDataSet(completion: @escaping (GameFetching.GameDataSet) -> Void) {
        if newworkReachability.isOnlineConnectionAvailable && useRemoteDatabase {
            fetchGameDataSetFromRemote(completion: completion)
        } else {
            fetchGameDataSetFromPersistence(completion: completion)
        }
    }

    private func fetchGameDataSetFromRemote(completion: @escaping (GameFetching.GameDataSet) -> Void) {
        // No remote database available.
        completion(([], [:], [:]))

        // A networking layer would be the next step here.
        // It would require caching into the persistence databse and a system for error handling.
    }

    private func fetchGameDataSetFromPersistence(completion: @escaping (GameFetching.GameDataSet) -> Void) {
        persistenceDatabase.fetchGameDataSet(completion: completion)
    }
}

