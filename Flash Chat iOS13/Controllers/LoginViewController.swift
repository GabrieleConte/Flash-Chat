
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func loginPressed(_ sender: UIButton) {
        //Creazione Utente
        if let email=emailTextfield.text, let password=passwordTextfield.text{
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error{
                    self!.warningLabel.text=e.localizedDescription
                    self!.warningLabel.alpha=1
                }else{
                    //Navigate to ChatViewController
                    self!.warningLabel.alpha=0
                    self!.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
}
