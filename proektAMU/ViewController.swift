//
//  ViewController.swift
//  proektAMU
//
//  Created by Sara Stojanoska on 8/20/21.
//  Copyright © 2021 Sara Stojanoska. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var Guest: UILabel!
    @IBOutlet weak var GuestOrHostess: UISwitch!
    @IBOutlet weak var TitleImage: UIImageView!
    @IBOutlet weak var Hostess: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var signUpMode = false
    
    var activityIndicator = UIActivityIndicatorView()
    
    @IBAction func GuestOrHostess(_ sender: Any) {
        if signUpMode {
            signUpMode = false
            signInButton.setTitle("Sign In", for: .normal)
            registerButton.setTitle("Switch to Register", for: .normal)
            NameTextField.isHidden = true
            SurnameTextField.isHidden = true
            PhoneTextField.isHidden = true
            Guest.isHidden = true
            Hostess.isHidden = true
            GuestOrHostess.isHidden = true
        }
        else{
            signUpMode = true
            signInButton.setTitle("Register", for: .normal)
            registerButton.setTitle("Switch to Sign In", for: .normal)
            NameTextField.isHidden = false
            SurnameTextField.isHidden = false
            PhoneTextField.isHidden = false
            Guest.isHidden = false
            Hostess.isHidden = false
            GuestOrHostess.isHidden = false
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if signUpMode == false{
            NameTextField.isHidden = true
            SurnameTextField.isHidden = true
            PhoneTextField.isHidden = true
            Guest.isHidden = true
            Hostess.isHidden = true
            GuestOrHostess.isHidden = true
        }
        else{
            NameTextField.isHidden = false
            SurnameTextField.isHidden = false
            PhoneTextField.isHidden = false
            Guest.isHidden = false
            Hostess.isHidden = false
            GuestOrHostess.isHidden = false
        }
    }
    
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func signInpressed(_ sender: Any) {
        if emailTextField.text == "" || passTextField.text == "" || NameTextField.text == "" || SurnameTextField.text == "" || PhoneTextField.text == "" {
            displayAlert(title: "Error in form", message: "You must provide all information")
        }
        else{
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            view.addSubview(activityIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signUpMode{
                let user = PFUser()
                user.username = emailTextField.text
                user.password = passTextField.text
                user.email = emailTextField.text
                
                user["firstName"] = NameTextField.text
                user["lastName"] = SurnameTextField.text
                user["phoneNumber"] = PhoneTextField.text
                
                if GuestOrHostess.isOn{
                    user["userType"] = "Hostess"
                    user["reqSeat"] = "Table"
                    user["reqSeat"] = "Bar"
                }
                else{
                    user["userType"] = "Guest"
                }
                
                user.signUpInBackground{(success,error ) in
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error{
                        let errorString = error.localizedDescription
                        self.displayAlert(title: "Error signing up", message: errorString)
                    }
                    else{
                        //print("Sign up success")
                        if PFUser.current()!["userType"] as! String == "Hostess" {
                            self.performSegue(withIdentifier: "toReviewSeg", sender: self)
                            //print("Signed-up - Hostess")
                        }else {
                            self.performSegue(withIdentifier: "UserSeg", sender: self)
                        }
                    }
                }
            }
            else{
                if emailTextField.text == "" || passTextField.text == ""{
                    displayAlert(title: "Error in form", message: "You must provide both email and password")
                }else{
                    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    activityIndicator.center = view.center
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.style = UIActivityIndicatorView.Style.gray
                    view.addSubview(activityIndicator)
                    UIApplication.shared.beginIgnoringInteractionEvents()

                    PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passTextField.text!) { (user, error) in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if let error = error{
                            let errorString = error.localizedDescription
                            self.displayAlert(title: "Error signing in", message: errorString)
                            
                        }else{
                            if user!["userType"] as! String == "Hostess" {
                                self.performSegue(withIdentifier: "toReviewSeg", sender: self)
                            }
                            else if user!["userType"] as! String == "Guest" {
                                self.performSegue(withIdentifier: "UserSeg", sender: self)
                            }
                        }
                    }
                    
                }
                
            }
        }
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if signUpMode{
            signUpMode = false
            signInButton.setTitle("Sign In", for: .normal)
            registerButton.setTitle("Switch to Register", for: .normal)
            NameTextField.isHidden = true
            SurnameTextField.isHidden = true
            PhoneTextField.isHidden = true
            Guest.isHidden = true
            Hostess.isHidden = true
            GuestOrHostess.isHidden = true
        }
        else{
            signUpMode = true
            signInButton.setTitle("Register", for: .normal)
            registerButton.setTitle("Switch to Sign In", for: .normal)
            NameTextField.isHidden = false
            SurnameTextField.isHidden = false
            PhoneTextField.isHidden = false
            Guest.isHidden = false
            Hostess.isHidden = false
            GuestOrHostess.isHidden = false
        }
    }
 
}

