//
//  ServiceLocator.swift
//  Test_Map_App_ios
//
//  Created by PeCheRukiN on 26.08.17.
//  Copyright © 2017 PeCheRukiN. All rights reserved.
//

import Foundation

class ServiceLocator: NSObject {
    private(set) var networkService: NetworkService
    
    class func shared() -> ServiceLocator {
        return AppDelegate.shared().serviceLocator!
    }
    
    override init() {
        networkService = NetworkService()
    }
}
