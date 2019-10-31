//
//  LoginVC.swift
//  PodcastNotifications
//
//  Created by C4Q on 10/29/19.
//  Copyright © 2019 Iram Fattah. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    //MARK: UI Objects
    
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "applepodcast")
        iv.layer.cornerRadius = 6
        return iv
    }()
    
    
    lazy var emailTextField: UITextField = {
        let myTextField = UITextField()
        myTextField.placeholder = "email"
        myTextField.layer.cornerRadius = 5
        myTextField.layer.borderWidth = 2
        myTextField.layer.borderColor = UIColor.black.cgColor
        myTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        myTextField.delegate = self
        return myTextField
    }()
    
    lazy var passwordTextField: UITextField = {
        let myTextField = UITextField()
        myTextField.placeholder = "Password"
        myTextField.layer.cornerRadius = 5
               myTextField.layer.borderWidth = 2
               myTextField.layer.borderColor = UIColor.black.cgColor
        myTextField.isSecureTextEntry = true
        myTextField.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        myTextField.delegate = self
        return myTextField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
               button.setTitle("Login", for: .normal)
               button.setTitleColor(.white, for: .normal)
               button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
               button.layer.cornerRadius = 5
               button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: properties
    
    
    private let myEmail = "Iramfattah94@gmail.com"
    private let myPassword = "6.1rocks"
    private var containerViewBottomConstraint = NSLayoutConstraint()
    private var containerViewTopConstraint = NSLayoutConstraint()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadUserDefaults()
        addObservers()
        setupContainerView()
        configureLogoImageView()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginButton()

    }
    
    
    //MARK: Objc Selector functions
    
    
    @objc func formValidation() {
         guard emailTextField.hasText, passwordTextField.hasText else {
         loginButton.isEnabled = false
         loginButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return}
        loginButton.isEnabled = true
        loginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
       }
    
    
    @objc func handleLogin() {
        guard let email = emailTextField.text?.lowercased(), let password = passwordTextField.text else {return}
        
        guard email == myEmail.lowercased(), password == myPassword else {
            showAlert()
            return
        }
        
        let podcastsVC = PodcastsVC()
        podcastsVC.modalPresentationStyle = .fullScreen
        present(podcastsVC, animated: true) {
            UserDefaults.standard.set(email, forKey: "EmailKey")
            UserDefaults.standard.set(password, forKey: "PasswordKey")
        }
        
    
    }
    
    
    //MARK TODO: refactor to use enum instead of two functions
    @objc func handleKeyboardShowing(sender notification: Notification) {
        guard let infoDict = notification.userInfo else {return}
        guard let keyboardFrame = infoDict[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        guard let duration = infoDict[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        self.containerViewBottomConstraint.constant = -(keyboardFrame.height)
        self.containerViewTopConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardHiding(sender notification: Notification) {
        guard let infoDict = notification.userInfo else {return}
               guard let duration = infoDict[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        containerViewBottomConstraint.constant = CGRect.zero.height
        containerViewTopConstraint.constant = 200 
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
       
    
    
    //MARK: Private Methods
    
    private func showAlert() {
        let alertController = UIAlertController(title: "Invalid Login", message: "Incorrect email and/or password", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShowing(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHiding(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func loadUserDefaults() {
        if let email = UserDefaults.standard.object(forKey: "EmailKey") as? String, let password = UserDefaults.standard.object(forKey: "PasswordKey") as? String {
            emailTextField.text = email
            passwordTextField.text = password
             loginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
            
        }
    }
    
    
    
    
    //MARK: Constraint functions:
    
    
    private func setupContainerView() {
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
             
             containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
        self.containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomConstraint.isActive = true
        self.containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200)
        containerViewTopConstraint.isActive = true
        
    }
    
    private func configureLogoImageView() {
        containerView.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [logoImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
                logoImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.75),
                logoImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                logoImageView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor, multiplier: 0.48)])
        
    }
    
    private func configureEmailTextField() {
        containerView.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
             emailTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
             emailTextField.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.72),
                emailTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.085)])
    }
    
    private func configurePasswordTextField() {
        containerView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
             passwordTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
             passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor),
             passwordTextField.heightAnchor.constraint(equalTo: emailTextField.heightAnchor)])
    }
    
    
    private func configureLoginButton() {
        containerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
                loginButton.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor, multiplier: 0.34),
                loginButton.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor, multiplier: 0.8),
                loginButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)])
    }

  

}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
