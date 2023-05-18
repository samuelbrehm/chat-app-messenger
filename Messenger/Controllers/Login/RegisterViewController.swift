//
//  RegisterViewController.swift
//  Messenger
//
//  Created by Samuel Brehm on 30/05/22.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
   
   private let scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.clipsToBounds = true
      return scrollView
   }()
   
   private let imageView: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(systemName: "person")
      imageView.tintColor = .gray
      imageView.contentMode = .scaleAspectFit
      return imageView
   }()
   
   private let firstNameField: UITextField = {
      let field = UITextField()
      field.autocorrectionType = .no
      field.autocapitalizationType = .none
      field.returnKeyType = .continue
      field.layer.cornerRadius = 12
      field.layer.borderWidth = 1
      field.layer.borderColor = UIColor.lightGray.cgColor
      field.placeholder = "First Name..."
      field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
      field.leftViewMode = .always
      field.backgroundColor = .white
      return field
   }()
   
   private let lastNameField: UITextField = {
      let field = UITextField()
      field.autocorrectionType = .no
      field.autocapitalizationType = .none
      field.returnKeyType = .continue
      field.layer.cornerRadius = 12
      field.layer.borderWidth = 1
      field.layer.borderColor = UIColor.lightGray.cgColor
      field.placeholder = "Last Name..."
      field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
      field.leftViewMode = .always
      field.backgroundColor = .white
      return field
   }()
   
   private let emailField: UITextField = {
      let field = UITextField()
      field.autocorrectionType = .no
      field.autocapitalizationType = .none
      field.returnKeyType = .continue
      field.layer.cornerRadius = 12
      field.layer.borderWidth = 1
      field.layer.borderColor = UIColor.lightGray.cgColor
      field.placeholder = "Email Address..."
      field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
      field.leftViewMode = .always
      field.backgroundColor = .white
      return field
   }()
   
   private let passwordField: UITextField = {
      let field = UITextField()
      field.autocorrectionType = .no
      field.autocapitalizationType = .none
      field.returnKeyType = .continue
      field.layer.cornerRadius = 12
      field.layer.borderWidth = 1
      field.layer.borderColor = UIColor.lightGray.cgColor
      field.placeholder = "Password..."
      field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
      field.leftViewMode = .always
      field.backgroundColor = .white
      field.isSecureTextEntry = true
      return field
   }()
   
   private let registerButton: UIButton = {
      let button = UIButton()
      button.setTitle("Register", for: .normal)
      button.backgroundColor = .systemGreen
      button.setTitleColor(.white, for: .normal)
      button.layer.cornerRadius = 12
      button.layer.masksToBounds = true
      button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
      return button
   }()
   
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      scrollView.frame = view.bounds
      
      let size = view.width / 3
      imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                               y: 20,
                               width: size,
                               height: size)
      
      firstNameField.frame = CGRect(x: 30,
                                y: imageView.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52)
      lastNameField.frame = CGRect(x: 30,
                                y: firstNameField.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52)
      emailField.frame = CGRect(x: 30,
                                y: lastNameField.bottom + 10,
                                width: scrollView.width - 60,
                                height: 52)
      passwordField.frame = CGRect(x: 30,
                                   y: emailField.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52)
      registerButton.frame = CGRect(x: 30,
                                 y: passwordField.bottom + 10,
                                 width: scrollView.width - 60,
                                 height: 52)
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      title = "Log In"
      view.backgroundColor = .white
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                          style: .done,
                                                          target: self,
                                                          action: #selector(didTapRegister))
      
      registerButton.addTarget(self,
                            action: #selector(registerButtonTapped),
                            for: .touchUpInside)
      
      emailField.delegate = self
      passwordField.delegate = self
      
      // add subViews
      view.addSubview(scrollView)
      scrollView.addSubview(imageView)
      scrollView.addSubview(emailField)
      scrollView.addSubview(passwordField)
      scrollView.addSubview(registerButton)
      scrollView.addSubview(firstNameField)
      scrollView.addSubview(lastNameField)
      
      imageView.isUserInteractionEnabled = true
      scrollView.isUserInteractionEnabled = true
      
      let gesture = UITapGestureRecognizer(target: self,
                                           action: #selector(didTapChangeProfilePic))
      imageView.addGestureRecognizer(gesture)
   }
   
   @objc private func didTapChangeProfilePic() {
      print("@Change Pic called")
   }
   
   @objc private func registerButtonTapped() {
      firstNameField.resignFirstResponder()
      lastNameField.resignFirstResponder()
      emailField.resignFirstResponder()
      passwordField.resignFirstResponder()
      
      guard let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            let email = emailField.text,
            let password = passwordField.text,
            !firstName.isEmpty,
            !lastName.isEmpty,
            !email.isEmpty,
            !password.isEmpty,
            password.count >= 6 else {
         alertUserLoginError()
         return
      }
      
      // Firebase login
       FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { res, error in
           guard let result = res, error == nil else {
               print("@@ Error creating user")
               return
           }
           
           let user = result.user
           print("@@ Created user \(user)")
       }
   }
   
   func alertUserLoginError() {
      let alert = UIAlertController(title: "Woops",
                                    message: "Please enter all information to create a new account.",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Dismiss",
                                    style: .cancel,
                                    handler: nil))
      present(alert, animated: true)
   }
   
   @objc private func didTapRegister() {
      let vc = RegisterViewController()
      vc.title = "Create Account"
      navigationController?.pushViewController(vc, animated: true)
   }
}

extension RegisterViewController: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailField {
         passwordField.becomeFirstResponder()
      } else if textField == passwordField {
         registerButtonTapped()
      }
      return true
   }
}
