//
//  ReuseIdentifier.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/23/24.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
