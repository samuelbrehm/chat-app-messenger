//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Samuel Brehm on 18/05/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    public func test() {
        database.child("foo").setValue(["something": true])
    }
}
