//
//  Notification++Extensions.swift
//  HMOA_iOS
//
//  Created by 곽다은 on 4/19/24.
//

import Foundation
import UIKit

extension Notification.Name {
    static let updateBackgroundImage = Notification.Name("updateBackgroundImage")
    
    static let keyboardWillShow = UIResponder.keyboardWillShowNotification
    
    static let keyboardWillHide = UIResponder.keyboardWillHideNotification
    
}
