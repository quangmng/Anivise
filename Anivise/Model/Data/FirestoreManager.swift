//
//  FirestoreManager.swift
//  Anivise
//
//  Created by Quang Minh Nguyen on 8/10/2024.
//

import FirebaseFirestore

class FirestoreManager {
    private let db = Firestore.firestore()

    // Save favourite genres to Firestore
    func saveFavourites(userID: String, favouriteGenres: [String], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(userID).setData([
            "favouriteGenres": favouriteGenres
        ], merge: true) { error in
            completion(error)
        }
    }

    // Fetch favourite genres from Firestore
    func fetchFavourites(userID: String, completion: @escaping ([String]?, Error?) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            let data = snapshot?.data()
            let favouriteGenres = data?["favouriteGenres"] as? [String] ?? []
            completion(favouriteGenres, nil)
        }
    }
}
