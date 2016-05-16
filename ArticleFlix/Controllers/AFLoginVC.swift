//
//  ViewController.swift
//  ArticleFlix
//
//  Created by Shaher Kassam on 16/02/16.
//  Copyright © 2016 Shaher Kassam. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics
import MBProgressHUD
import SCLAlertView
import Parse
import Crashlytics


class AFLoginVC: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    //let userDef = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login VDL IN")
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        emailTextField.attributedPlaceholder = NSAttributedString(string:"email",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
                print("Login VDL OUT")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // End editing when touches the screen
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            //demande au clavier de passer au champs pwd
            passwordTextField.becomeFirstResponder()
        }

        else {
            // Demande au clavier de disparaitre
            textField.resignFirstResponder()
        }
        return true
        
    }

    @IBAction func login(sender: AnyObject) {
        
        let email = emailTextField.text!
        let pwd = passwordTextField.text!
        
        
        
        /*
         // Save Local
         if userDef.objectForKey(email) != nil {
         var userDic: [String:String] = userDef.objectForKey(email) as! [String:String]
         
         
         //print (userDic)
         //print(userDef.boolForKey("SignedIn"))
         print("iSSignedInd : \(userDef.boolForKey("SignedIn"))")
         
         
         if (userDic["email"] != "") && (pwd == userDic["pwd"]){
         print("user et pwd ok")
         
         userDef.setBool(true, forKey: "SignedIn")
         
         self.performSegueWithIdentifier("gotoHome", sender: nil)
         
         }
         }
         */
        
        // MARK: - Gestion de widget de loading
        //
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Indeterminate
        hud.labelText = "Loading"

        // MARK: - PARSE Login
        //
        
        PFUser.logInWithUsernameInBackground(email, password: pwd) {
            (user: PFUser?, error: NSError?) -> Void in
            
            hud.hide(true)
            
            if user != nil {
                // Do stuff after successful login.
                print("Login Segue")
                self.performSegueWithIdentifier("gotoHome", sender: nil)
            } else {
                if let error = error {
                    //let errorString = error.userInfo["error"] as? NSString
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
                        SCLAlertView().showError("Handle default situation", subTitle: "Error Code \(error.code)")            }
                }
            }
        }
    
    
        
        // MARK: - FIREBASE Login
        //
        /*
         firebaseRef.authUser(email, password: pwd,
         withCompletionBlock: { (error, auth) in
         
         hud.hide(true)
         
         print("Login error: \(error)")
         print("Login auth: \(auth)")
         print("Login email: \(email)")
         print("Login password: \(pwd)")
         
         if (error != nil) {
         // an error occurred while attempting login
         if let errorCode = FAuthenticationError(rawValue: error.code) {
         switch (errorCode) {
         case .UserDoesNotExist:
         print("Handle invalid user")
         SCLAlertView().showError("Handle invalid user", subTitle: "User Does not exist")
         case .InvalidEmail:
         print("Handle invalid email")
         SCLAlertView().showError("Handle invalid email", subTitle: "Invalid email")
         case .InvalidPassword:
         print("Handle invalid password")
         SCLAlertView().showError("Handle invalid password", subTitle: "Invalid Password")
         default:
         print("Handle default situation")
         SCLAlertView().showError("Handle default situation", subTitle: "Default Situation")
         }
         }
         
         }
         else {
         print("Login Segue")
         self.performSegueWithIdentifier("gotoHome", sender: nil)
         }
         })
         
         */
        
    }
    
    
    @IBAction func recoverPassword() {
        //Crashlytics.sharedInstance().crash()

        print("pop")
        
        
    }
    
    
    
    
}

