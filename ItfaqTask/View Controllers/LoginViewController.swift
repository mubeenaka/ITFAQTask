//
//  LoginViewController.swift
//  ItfaqTask
//
//  Created by Mubeena Thahir on 4/7/21.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var usernameTF: UITextField!

    enum CredentialsInputStatus {
        case Correct
        case Incorrect
    }
    
    private var username = ""
    private var password = ""
    
    private var credentials = Credentials() {
        didSet {
            username = credentials.username
            password = credentials.password
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        usernameTF.delegate = self
        passwordTF.delegate = self
    }


    @IBAction func onLoginBtnClick(_ sender: Any) {
        
        //Here we update with existing credentials from text fields
       updateCredentials(username: usernameTF.text!, password: passwordTF.text!)
        
        //Here we check user's credentials input empty or not
        let status = credentialsInput()
        switch status {
        case .Correct:
            self.errorLabel.isHidden = true
            login()
        case .Incorrect:
            self.errorLabel.isHidden = false
            return
        }
    }
    
    func updateCredentials(username: String, password: String, otp: String? = nil) {
        credentials.username = username
        credentials.password = password
    }
    
    func credentialsInput() -> CredentialsInputStatus {
        
        if username.isEmpty || password.isEmpty {
            return .Incorrect
        }
                    
        return .Correct
    }
    
    func login() {
        if checkLogin(){
            self.performSegue(withIdentifier: "showProducts", sender: nil)
        }
    }
    
    func checkLogin() -> Bool {
        //Here we check the credentials with the users in Users.json
        //If user exist, will allow to login to the application. Else, show the error message
        if let filepath = Bundle.main.path(forResource: "Users", ofType: "json") {
            do {
                    let contents = try String(contentsOfFile: filepath)
                    do {
                        let users = try JSONDecoder().decode([D_User].self, from: contents.data(using: .utf8)!)
                        for user in users {
                            if user.username == username && user.password == password {
                                self.updateLoggedInUser(user: user)
                                self.errorLabel.isHidden = true
                                return true
                            }
                        }
                        self.errorLabel.isHidden = false
                        return false
                        
                    } catch {
                        print(error)
                        self.errorLabel.isHidden = false
                        return false
                    }
                
                } catch {
                    // contents could not be loaded
                    self.errorLabel.isHidden = false
                    return false
                }
        }
        
        return false
    }
    
    func updateLoggedInUser(user : D_User) {
        //update user id and logged in status
        UserDefaults.standard.set(Int16(user.id), forKey: "LOGGED_IN_USER_ID")
        UserDefaults.standard.synchronize()
        
        UserDefaults.standard.set(true, forKey: "LOGGED_IN")
        UserDefaults.standard.synchronize()
        
        //Save user to DB and assign a cart to the user(if user is not already existing)
        CoredataManager.insertUser(user: user)
    }
}

//MARK: - Text Field Delegate Methods
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        usernameTF.layer.borderWidth = 0
        passwordTF.layer.borderWidth = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

