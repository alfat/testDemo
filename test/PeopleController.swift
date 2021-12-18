//
//  PeopleController.swift
//  test
//
//  Created by H, Alfatkhu on 17/12/21.
//

import UIKit
import Alamofire
import SVProgressHUD

extension PeopleController: ModelDelegate {
    func starting(model: Model) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    func modeldoneWithData(model: Model, result: Any) {
        if model.isMember(of: Model.self) {
            let response = result as! NSDictionary
        }
        else if model.isMember(of: GetModel.self) {
            let response = result as! NSDictionary
            SVProgressHUD.dismiss()

            dictDataUserCall = response
            
            if(dictDataUserCall.count != 0){
                let dictAdress =  dictDataUserCall.object(forKey: "address") as! NSDictionary
                
                lbValUsername.text = String(format: ": %@", dictDataUserCall.object(forKey: "username") as? String ?? "")
                lbValEmail.text = String(format: ": %@", dictDataUserCall.object(forKey: "email") as? String ?? "")
                lbValAddress.text = String(format: ": %@", dictAdress.object(forKey: "city") as! String)
                lbValPhone.text = String(format: ": %@", dictDataUserCall.object(forKey: "phone") as? String ?? "")
            }
            else{
                let alert = UIAlertController(title: "Error", message: "Data not found!!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func modelfailedWithError(model: Model, error: NSError) {
        print("error data d ", error)
        SVProgressHUD.dismiss()
        
        let alert = UIAlertController(title: "Error", message: "Terjadi kesalahan pada server atau koneksi Anda", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}


class PeopleController: UIViewController {
    @IBOutlet weak var lbProfile: UILabel!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    
    
    @IBOutlet weak var lbValUsername: UILabel!
    @IBOutlet weak var lbValEmail: UILabel!
    @IBOutlet weak var lbValAddress: UILabel!
    @IBOutlet weak var lbValPhone: UILabel!
    
    var dictDataUser : NSDictionary!
    var dictDataUserCall : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        dictDataUser = userDefaults.object(forKey: "master") as? NSDictionary
        
        lbValUsername.text = ""
        lbValEmail.text = ""
        lbValPhone.text = ""
        lbValAddress.text = ""
        
        let getUsers = GetModel()
        let id = dictDataUser.object(forKey: "id")
        let users = "users"
        let api = String(format: "%@/%@", users ,id as! CVarArg)
        getUsers._apiName = api
        getUsers.fetchWithDelegate(_delegate: self)
    }
}
