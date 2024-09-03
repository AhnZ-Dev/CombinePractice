//
//  Code.swift
//  CombineVinecentPradeilles
//
//  Created by Jihoon on 6/27/24.
//

import Foundation

func fetchUserId(_ completionHandler: @escaping (Int) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
        let result = 42
        completionHandler(42)
    }
}

func fetchName(for userId: Int,_ completionHandler: @escaping (String) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
        let result = "AhnZ"
        completionHandler("AhnZ" + String(userId))
    }
}

func run() {
    fetchUserId { userId in
        fetchName(for: userId) { name in
            print(name)
        }
    }
}
