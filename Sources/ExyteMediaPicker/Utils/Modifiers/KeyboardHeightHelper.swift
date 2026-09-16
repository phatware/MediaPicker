//
//  KeyboardHeightHelper.swift
//  Example-iOS
//
//  Created by Alisa Mylnikova on 23.08.2023.
//

import SwiftUI

@MainActor
class KeyboardHeightHelper: ObservableObject {

    static let shared = KeyboardHeightHelper()

    @Published var keyboardHeight: CGFloat = 0
    @Published var keyboardDisplayed: Bool = false

    init() {
        self.listenForKeyboardNotifications()
    }

    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self = self else { return }

            // Extract the value before crossing actors; Notification is not Sendable.
            guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            Task { @MainActor in
                self.keyboardHeight = keyboardRect.height
                self.keyboardDisplayed = true
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            DispatchQueue.main.async {
                self.keyboardHeight = 0
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: .main) { (notification) in
            DispatchQueue.main.async {
                self.keyboardDisplayed = false
            }
        }
    }

    private func handleKeyboardWillShow(_ notification: Notification) {
           guard let userInfo = notification.userInfo,
                 let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
               return
           }
           self.keyboardHeight = keyboardRect.height
           self.keyboardDisplayed = true
       }
}
