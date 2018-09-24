//
//  Door.swift
//  Test Taxcom
//
//  Created by Pavel Sumin on 23.09.2018.
//  Copyright © 2018 For Myself Inc. All rights reserved.
//

import Foundation

enum SecretBehindDoor {
    case goat
    case car
}

struct Door {
    private(set) var secret: SecretBehindDoor = .goat
    private(set) var isSelected = false
    private(set) var isOpened = false
    
    mutating func putSecret(_ secret: SecretBehindDoor) {
        self.secret = secret
    }
    
    mutating func setSelected() {
        isSelected = true
    }
    
    mutating func openDoor() {
        isOpened = true
    }
}
