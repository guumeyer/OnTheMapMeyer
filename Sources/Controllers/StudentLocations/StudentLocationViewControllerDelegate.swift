//
//  StudentLocationViewControllerDelegate.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/16/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import Foundation

/// The student information ViewController delegate.
protocol StudentLocationViewControllerDelegate {


    /// The update process will begin
    func updateWillBegin()

    /// Updates the UI based on the `result`.
    /// This method will be performed when there is some result to be update in the UI.
    func update()

    /// Shows a alert message
    ///
    /// - Parameters:
    ///   - title: The title
    ///   - message: The message
    func showAlert(title: String?, message: String)
}
