//
//  ReuseIdentifying.swift
//  HMOA_iOS
//
//  Created by HyoTaek on 8/29/24.
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
