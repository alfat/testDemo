//
//  ViewController.swift
//  test
//
//  Created by H, Alfatkhu on 17/12/21.
//

import UIKit
import Alamofire
import SVProgressHUD

extension ViewController: ModelDelegate {
    func starting(model: Model) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    func modeldoneWithData(model: Model, result: Any) {
        if model.isMember(of: Model.self) {
            print(model)
            let response = result as! NSDictionary
        }
        else if model.isMember(of: GetModel.self) {
            let response = result as! NSArray
            SVProgressHUD.dismiss()

            arrMasterData = response as! [Any]
            print("master data", arrMasterData.count)
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

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblTittle: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var arrMasterData: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.txtUsername.delegate = self
        self.txtPassword.delegate = self

        let getUsers = GetModel()
        getUsers._apiName = "users"
        getUsers.fetchWithDelegate(_delegate: self)
    }
    
    func validationText(){
        if(txtUsername.text?.isEmpty ?? true  && txtPassword.text?.isEmpty ?? true)
        {
            let alert = UIAlertController(title: "Error", message: "input tidak boleh kosong!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
        else if (txtUsername.text?.isEmpty ?? true){
            let alert = UIAlertController(title: "Error", message: "Username tidak boleh kosong!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
        else if (txtPassword.text?.isEmpty ?? true){
            let alert = UIAlertController(title: "Error", message: "Password tidak boleh kosong!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
        else
        {
            var isTrue: Bool = false
            
            for var i in (0..<arrMasterData.count)
            {
                let value = arrMasterData[i] as AnyObject
                let username = value.object(forKey: "username") as? String ?? ""
                if(txtUsername.text == username){
                    isTrue = true
                }
                
                if (isTrue == true){
                    let userDefaults = UserDefaults.standard
                    userDefaults.removeObject(forKey: "master")
                    userDefaults.set(value, forKey: "master")
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "homeTabbar")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.setRootViewController(mainTabBarController)
                    break
                }
            }
            
            if(isTrue == false){
                    txtUsername.text = ""
                    txtPassword.text = ""

                    let alert = UIAlertController(title: "Error", message: "username tidak terdaftar!!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
    
    @IBAction func btnLogin(_ sender: Any) {
        self.validationText()
    }
}

