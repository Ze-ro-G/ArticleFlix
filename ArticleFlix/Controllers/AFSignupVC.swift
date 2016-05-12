//
//  SignupViewController.swift
//  ArticleFlix
//
//  Created by Shaher Kassam on 18/02/16.
//  Copyright © 2016 Shaher Kassam. All rights reserved.
//

import UIKit
//import Firebase
import MBProgressHUD
import SCLAlertView
import Parse


class AFSignupVC: UIViewController, UITextFieldDelegate {

    // MARK: - Var
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var repasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var newsletterSwitch: UISwitch!
    @IBOutlet weak var conditionsSwitch: UISwitch!
    
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Abonnement au delegate de UITextField
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField == emailTextField {
            //demande au clavier de passer au champs pwd
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            repasswordTextField.becomeFirstResponder()
        }
        else {
            // Demande au clavier de disparaitre
            textField.resignFirstResponder()
        }

        return true
    }
    
    
    
    @IBAction func signup(sender: AnyObject) {
        
        let email = emailTextField.text!
        let pwd = passwordTextField.text!
        let repwd = repasswordTextField.text!
        let cond = conditionsSwitch
        
        
        // MARK: - Sauvegarde Local
        /*
        let userDic: [String:String] = ["email":email, "pwd":pwd]
        let userDef = NSUserDefaults.standardUserDefaults()
        
        userDef.setObject(userDic, forKey: email)
        userDef.setBool(true, forKey: "SignedIn")
 
        self.performSegueWithIdentifier("gotoHome", sender: nil)
        //print(userDic)
        */
        
        
        // MARK: - Gestion de widget de loading
        //
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelText = "Connexion"
        
        
        // MARK: - FIREBASE Signup
        /*
         firebaseRef.createUser(email, password: pwd) { (error: NSError!) in
         
         hud.hide(true)
         
         if error == nil {
         
         firebaseRef.authUser(email, password: pwd,
         withCompletionBlock: { (error, auth) -> Void in
         
         self.performSegueWithIdentifier("gotoHome", sender: nil)
         })
         }
         }
         */

    
        // MARK: - PARSE Signup
        
        let user = PFUser()
        user.email = email
        user.username = email
        user.password = pwd
        
        
        if email == "" {
            SCLAlertView().showError("User Email Missing", subTitle: "User Email Missing")
        }
        else if pwd == "" {
            SCLAlertView().showError("Password Missing", subTitle: "Password Missing")
        }
        else if repwd != pwd {
            SCLAlertView().showError("Password Not Identical", subTitle: "Password Not Identical")
        }
        else if cond.on != true {
            SCLAlertView().showError("Conditions not accepted", subTitle: "Veuillez accepter les conditions générales")
        }
        else {
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                
                hud.hide(true)
                
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                    switch (error.code) {
                    case 200:
                        SCLAlertView().showError("User Email Missing", subTitle: "Error Code \(error.code)")
                    case 125:
                        SCLAlertView().showError("User Email Invalid", subTitle: "Error Code \(error.code)")
                    case 201:
                        SCLAlertView().showError("Password Missing", subTitle: "Error Code \(error.code)")
                    case 203:
                        SCLAlertView().showError("User Email Taken", subTitle: "Error Code \(error.code)")
                    case 205:
                        SCLAlertView().showError("User Email Not Found", subTitle: "Error Code \(error.code)")
                    case 208:
                        SCLAlertView().showError("User Already Exist", subTitle: "Error Code \(error.code)")
                    default:
                        SCLAlertView().showError("Handle default situation", subTitle: "Error Code \(error.code)")
                    }
                } else {
                    // Hooray! Let them use the app now.
                    SCLAlertView().showSuccess("Connexion reussi", subTitle: "Compte cree")
                    self.performSegueWithIdentifier("gotoHome", sender: nil)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
