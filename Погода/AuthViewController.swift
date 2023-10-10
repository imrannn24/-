//
//  AuthViewController.swift
//  Погода
//
//  Created by imran on 09.09.2023.
//

import UIKit
import Firebase

class AuthViewController: UIViewController{
    
    var signUp: Bool = true
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Регистрация"
        view.font = UIFont(name: "Comfortaa-Bold", size: 32)
        return view
    }()
    
    lazy var userName: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        view.placeholder = "Enter your name..."
        view.autocapitalizationType = .none
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.leftViewMode = .always
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var eMailTF: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        view.placeholder = "Enter email..."
        view.autocapitalizationType = .none
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.leftViewMode = .always
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var passwordTF: UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.black.cgColor
        view.placeholder = "Enter password..."
        view.autocapitalizationType = .none
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.leftViewMode = .always
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var enterBtn: UIButton = {
        let view = UIButton()
        view.setTitle("Зарегестрироваться", for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .tintColor
        view.layer.cornerRadius = 24
        view.addTarget(self, action: #selector(enterAuth), for: .touchUpInside)
        return view
    }()

    @objc func enterAuth(){
        let name = userName.text!
        let email = eMailTF.text!
        let password = passwordTF.text!
        
        if signUp {
            checkValidity(name: name, email: email, password: password) {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if error == nil{
                        if let result = result{
                            print(result.user.uid)
                            let ref = Database.database().reference().child("users")
                            ref.child(result.user.uid).updateChildValues(["name" : name, "email" : email])
                        }
                    }else{
                        self.showAlert(message: error!.localizedDescription)
                    }
                }
            }
        }else{
            checkValidity(name: name, email: email, password: password) {
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if error == nil{
                        self.dismiss(animated: true)
                    }
                }
            }
               
            
        }
    }
    
    func checkValidity(
        name: String,
        email: String,
        password: String,
        callback: () -> Void
    ) {
        if !name.isEmpty && !email.isEmpty && !password.isEmpty {
         callback()
        }else{
            showAlert(message: "Заполните все поля!")
        }
    }

    override func viewDidLoad() {
        view.backgroundColor = .white

        userName.delegate = self
        eMailTF.delegate = self
        passwordTF.delegate = self
        
        setUpView()
        
    }
    
    private func setUpView(){
        
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userName)
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(eMailTF)
        eMailTF.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTF)
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(enterBtn)
        enterBtn.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),

                                     userName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     userName.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
                                     userName.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
                                     userName.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
                                     userName.heightAnchor.constraint(equalToConstant: 45),
                                     
                                     eMailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     eMailTF.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 25),
                                     eMailTF.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
                                     eMailTF.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
                                     eMailTF.heightAnchor.constraint(equalToConstant: 45),
                                     
                                     passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     passwordTF.topAnchor.constraint(equalTo: eMailTF.bottomAnchor, constant: 25),
                                     passwordTF.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 25),
                                     passwordTF.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -25),
                                     passwordTF.heightAnchor.constraint(equalToConstant: 45),
                                     
                                     enterBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     enterBtn.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 25),
                                     enterBtn.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 50),
                                     enterBtn.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -50),
                                     enterBtn.heightAnchor.constraint(equalToConstant: 45),
                                    ])
        
    }
    
}

extension AuthViewController: UITextFieldDelegate {
    
    private func showAlert(message: String){
        let aletrController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { action in
            
        }
        
        aletrController.addAction(okAction)
        
        
        present(aletrController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
       return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
}
