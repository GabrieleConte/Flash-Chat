

import UIKit
import Firebase
class ChatViewController: UIViewController {

    @IBAction func logOut(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
       do {
         try firebaseAuth.signOut()
           navigationController?.popToRootViewController(animated: true)
       } catch let signOutError as NSError {
         print("Error signing out: %@", signOutError)
       }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db=Firestore.firestore()
    var messages: [Message] = [
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        title=K.appName
        tableView.dataSource=self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
    func loadMessages(){
        //Prende i dati dal database e li salva in querysnapshot
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.messages = []
            if let e=error{
                print("errore con la query\(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String,
                           let messageBody = data[K.FStore.bodyField] as? String{
                            let newMessage = Message(sender: sender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: (self.messages.count-1), section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text,
           let messageSender=Auth.auth().currentUser?.email{
            db.collection(K.FStore.collectionName).addDocument(data:
                [K.FStore.senderField: messageSender,
                 K.FStore.bodyField: messageBody,
                 K.FStore.dateField: Date().timeIntervalSince1970]){(error) in
                if let e = error{
                    print(" \(e)issue saving data on Firestore")
                }else{
                    print("dati salvati con successo")
                    DispatchQueue.main.async {
                        self.messageTextfield.text=""
                    }
                }
                
            }
        }
        
    }
    

}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.lable.text = messages[indexPath.row].body
        if message.sender == Auth.auth().currentUser?.email{
            //GRAFICA MSG UTENTE LOGGATO
            cell.leftIV.isHidden=true
            cell.rightIV.isHidden=false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.lable.textColor = UIColor(named: K.BrandColors.purple)
        }else{
            //GRAFICA MSG ALTRI UTENTI
            cell.leftIV.isHidden=false
            cell.rightIV.isHidden=true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.lable.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
    
        
        return cell
    }
}
