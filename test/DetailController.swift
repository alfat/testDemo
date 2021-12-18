//
//  DetailController.swift
//  test
//
//  Created by H, Alfatkhu on 18/12/21.
//

import UIKit

class ListAllChat: UITableViewCell{
    
    @IBOutlet weak var lbNama: UILabel!
    @IBOutlet weak var lbChat: UILabel!
}

class DetailController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    @IBOutlet weak var viewInti: UIView!
    @IBOutlet weak var viewSub: UIView!
    @IBOutlet weak var lbUser: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var tblDetailChat: UITableView!
    @IBOutlet weak var lbAllComent: UILabel!
    
    var dictDataUser : NSDictionary!
    var dataClicked : NSDictionary!
    var dataClickedMessage : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let userDefaults = UserDefaults.standard
        dictDataUser = userDefaults.object(forKey: "master") as? NSDictionary
  
        lbUser.text = ""
        lbMessage.text = ""
        lbUser.text = dictDataUser.object(forKey: "username") as? String ?? ""
        lbMessage.text = dataClicked.object(forKey: "body") as? String ?? ""
    
        self.setNavigationBar()
        
        self.tblDetailChat.delegate = self
    }
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "Detail Post")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(done))
        navItem.leftBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    @objc func done() { 
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblDetailChat.reloadData()
    }
    
    //MARK:- Tableview Datasource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataClickedMessage.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "allChat", for: indexPath) as! ListAllChat
            cell.lbNama.text = dataClickedMessage.object(forKey: "email") as? String ?? ""
            cell.lbChat.text = dataClickedMessage.object(forKey: "body") as? String ?? ""

            return cell
    }
}
