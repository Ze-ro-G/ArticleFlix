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
        
        
        
        // MARK: - Gestion de widget de loading
        //


        // MARK: - PARSE Login
        //
        
        if(email.isEmpty || pwd.isEmpty){
            SCLAlertView().showError("Champs manquants", subTitle: "Veuillez renseigner une adresse mail et un mot de passe")
        
        }
        else {
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Loading"
            
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
                            SCLAlertView().showError("E-mail manquant", subTitle: "Code Erreur \(error.code)")
                        case 125:
                            SCLAlertView().showError("E-mail non valide", subTitle: "Code Erreur \(error.code)")
                        case 201:
                            SCLAlertView().showError("Mot de passe manquant", subTitle: "Code Erreur \(error.code)")
                        case 203:
                            SCLAlertView().showError("E-mail déjà existant", subTitle: "Code Erreur \(error.code)")
                        case 204:
                            SCLAlertView().showError("Erreur", subTitle: "Vous devez renseigner une adresse mail")
                        case 205:
                            SCLAlertView().showError("E-mail inexistant", subTitle: "Code Erreur \(error.code)")
                        case 208:
                            SCLAlertView().showError("Utilisateur déjà existant", subTitle: "Code Erreur \(error.code)")
                        case 101:
                            SCLAlertView().showError("Erreur", subTitle: "L'email ou le mot de passe renseigné est incorrect")

                            
                        default:
                            SCLAlertView().showError("Erreur de connexion", subTitle: "Code Erreur \(error.code)")
                        }
                    }
                }
            }

        }

        
    }
    
    
    @IBAction func recoverPassword() {
        //Crashlytics.sharedInstance().crash()

        
        PFUser.requestPasswordResetForEmailInBackground(emailTextField.text!, block: { (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                if succeeded { // SUCCESSFULLY SENT TO EMAIL
                    print("Reset email sent to your inbox");
                    SCLAlertView().showSuccess("Mot de passe réinitialisé", subTitle: "Un E-mail a été envoyé")
                }
            }
            else { //ERROR OCCURED, DISPLAY ERROR MESSAGE
                print(error!.description);
                
                switch (error!.code) {
                case 200:
                    SCLAlertView().showError("E-mail manquant", subTitle: "Code Erreur \(error!.code)")
                case 204:
                    SCLAlertView().showError("E-mail manquant", subTitle: "Veuillez rentrer votre e-mail")
                case 125:
                    SCLAlertView().showError("E-mail non valide", subTitle: "Code Erreur \(error!.code)")
                case 201:
                    SCLAlertView().showError("Mot de passe manquant", subTitle: "Code Erreur \(error!.code)")
                case 203:
                    SCLAlertView().showError("E-mail déjà existant", subTitle: "Code Erreur \(error!.code)")
                case 205:
                    SCLAlertView().showError("E-mail inexistant", subTitle: "Code Erreur \(error!.code)")
                case 208:
                    SCLAlertView().showError("Utilisateur déjà existant", subTitle: "Code Erreur \(error!.code)")
                default:
                    SCLAlertView().showError("Erreur de connexion", subTitle: "Code Erreur \(error!.code)")
                }
            }
        });
    }
}

