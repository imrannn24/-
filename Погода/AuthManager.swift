//
//  AuthManager.swift
//  Погода
//
//  Created by imran on 17.09.2023.
//

import UIKit
import VK

class AuthManager{
    
    private var sharedVK: VK.Type2<App, VKID>?
    
    static func build() -> VK.Type2<App, VKID>? {
        let manager = AuthManager()
        return manager.sharedVK
    }
    
    private init() {
        do {
            
                sharedVK = try VK {
                    App(credentials: .init(clientId: "value", clientSecret: "value"))
                    VKID()
                }
            
        } catch {
            fatalError("Couldn't initialze VK with error: \(error)")
        }
    }
    
}
