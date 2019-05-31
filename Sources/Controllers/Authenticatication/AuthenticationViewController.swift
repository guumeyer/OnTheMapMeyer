//
//  AuthenticationViewController.swift
//  OnTheMapMeyer
//
//  Created by Meyer, Gustavo on 5/23/19.
//  Copyright © 2019 Gustavo Meyer. All rights reserved.
//

import UIKit

typealias UserSessionResult = (UIViewController, Authenticaticaion, UserSession, User) -> Void

final class AuthenticationViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singUpTextField: UILabel!
    @IBOutlet weak var activeIndicator: UIActivityIndicatorView!

    private var udacityService: Authenticaticaion!
    private var openURLHandler: ((String) -> Void)?
    private var alertView: AlerViewHandler?
    private var userSessionHandler: UserSessionResult?


    convenience init(udacityService: Authenticaticaion,
                     openURLHandler: @escaping (String) -> Void,
                     alertView: @escaping AlerViewHandler,
                     userSessionHandler: @escaping UserSessionResult) {
        self.init()
        self.udacityService = udacityService
        self.openURLHandler = openURLHandler
        self.alertView = alertView
        self.userSessionHandler = userSessionHandler
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 4

        setupActiveIndicator()
        setupSingUpLabel()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    // MARK: Actions
    @IBAction func loginButtonDidTouch(_ sender: Any) {
        do {
            let userCredential = try UserCredential.Builder()
                .user(emailTextField.text ?? "")
                .password(passwordTextField.text ?? "")
                .build()

            showActiveIndicator()
            udacityService?.authorize(credential: userCredential) { [weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.authorizeHandler(result)
            }

        } catch (let error)  {
            alertView?(self, nil, error.localizedDescription)
        }
    }

    @objc private func singUpAction() {
        openURLHandler?("https://auth.udacity.com/sign-up")
    }

    public func authorizeHandler(_ result: AuthenticaticaionResult) {
        switch result {
        case .failure(let error):
            DispatchQueue.main.async {
                self.hideActiveIndicator()
                self.alertView?(self, nil, error.localizedDescription)
            }
        case .success(let userSession):
            getUserDetail(userSession)
        }
    }

    private func getUserDetail(_ userSession: UserSession) {

        udacityService.userDetail(userSession) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.hideActiveIndicator()
                strongSelf.userDetailHandler(result, userSession)
            }

        }
    }

    private func userDetailHandler(_ result: UserDetailResult, _ userSession: UserSession) {
        switch result {
        case .failure(let error):
            alertView?(self, nil, error.localizedDescription)
        case .success(let user):
            userSessionHandler?(self, udacityService, userSession, user)
        }
    }

    // MARK: Setup layout

    private func setupSingUpLabel() {
        // Don't have an account? Sing Up
        singUpTextField.attributedText = prepareSingUpTextAttribute()
        singUpTextField.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(singUpAction))
        singUpTextField.addGestureRecognizer(tap)

    }

    private func setupActiveIndicator() {
        activeIndicator.isHidden = true
        activeIndicator.hidesWhenStopped = true
        activeIndicator.stopAnimating()
    }

    private func prepareSingUpTextAttribute() -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        attributedText.append(NSAttributedString(string: "Don't have an account? ",
                                                 attributes: [.foregroundColor: UIColor.black]))
        attributedText.append(NSAttributedString(string: "Sing Up",
                                                 attributes: [.foregroundColor: UIColor(red: 80/255, green: 176/255, blue: 223/255, alpha: 1)]))
        return attributedText
    }

    private func showActiveIndicator() {
        activeIndicator.isHidden = false
        activeIndicator.startAnimating()
        singUpTextField.isHidden = true
        loginButton.isEnabled = false
        loginButton.alpha = 0.5
    }

    private func hideActiveIndicator() {
        activeIndicator.isHidden = true
        activeIndicator.stopAnimating()
        singUpTextField.isHidden = false
        loginButton.isEnabled = true
        loginButton.alpha = 1
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
