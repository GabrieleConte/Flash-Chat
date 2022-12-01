
import UIKit
import Firebase
class RegisterViewController: UIViewController {

    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    
    @IBAction func registerPressed(_ sender: UIButton) {
        //Creazione Utente
        if let email=emailTextfield.text, let password=passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error{
                    self.warningLabel.text=e.localizedDescription
                    self.warningLabel.alpha=1
                }else{
                    //Navigate to ChatViewController
                    self.warningLabel.alpha=0
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
   
}
