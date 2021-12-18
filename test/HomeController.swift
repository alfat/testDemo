//
//  HomeController.swift
//  test
//
//  Created by H, Alfatkhu on 17/12/21.
//\
import UIKit
import Alamofire
import SVProgressHUD

extension HomeController: ModelDelegate {
    func starting(model: Model) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    func modeldoneWithData(model: Model, result: Any) {
        if model.isMember(of: Model.self) {
            let response = result as! NSArray
        }
        else if model.isMember(of: GetModel.self) {
            let response = result as! NSArray
            SVProgressHUD.dismiss()
            
            
            
            if(response.count != 0){
                arrMasterData = response as! [Any]
            }
            else{
                arrMasterData = []
            }
            
            tblChat.reloadData()

        }
        else if model.isMember(of: GetMessageCount.self) {
            let response = result as! NSArray
            SVProgressHUD.dismiss()
            
            
            
            if(response.count != 0){
                arrMasterDataMessage = response as! [Any]
            }
            else{
                arrMasterDataMessage = []
            }
            
            tblChat.reloadData()
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

class ListChatCell: UITableViewCell{
    
    @IBOutlet weak var vewChatBorder: UIView!
    @IBOutlet weak var viewChat: UIView!
    @IBOutlet weak var lbAbit: UILabel!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbJumlahChat: UILabel!
    @IBOutlet weak var imgMessage: UIImageView!
}

class HomeController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tblChat: UITableView!
    var dictDataUser : NSDictionary!
    
    var arrMasterData: [Any] = []
    var arrMasterDataMessage: [Any] = []
    var pageNumber = 0
    var pageTotal = 10
    var pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let getMessage = GetModel()
        getMessage._apiName = "posts"
        getMessage.fetchWithDelegate(_delegate: self)
        
        let GetMessageCount = GetMessageCount()
        let userDefaults = UserDefaults.standard
        dictDataUser = userDefaults.object(forKey: "master") as? NSDictionary
        let id = dictDataUser.object(forKey: "id")
        let posts = "posts"
        let api = String(format: "%@/%@/comments", posts ,id as! CVarArg)
        GetMessageCount._apiName = api
        GetMessageCount.fetchWithDelegate(_delegate: self)
        
      
        self.tblChat.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tblChat.reloadData()
    }
    
    //MARK:- Tableview Datasource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrMasterData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListChatCell", for: indexPath) as! ListChatCell
            cell.lbAbit.text = dictDataUser.object(forKey: "username") as? String ?? ""
            cell.lbJumlahChat.text = String(arrMasterDataMessage.count)
            
            let dataMessage = arrMasterData[indexPath.row]
        cell.lbMessage.text = (dataMessage as AnyObject).object(forKey: "body") as? String ?? ""
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "detail") as! DetailController
        nextViewController.dataClicked = arrMasterData[indexPath.row] as! NSDictionary
        nextViewController.dataClickedMessage = arrMasterDataMessage[indexPath.row] as! NSDictionary
        self.present (nextViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrMasterData.count - 1{
            self.loadMoreData()
        }
        
    }
    
    func loadMoreData() {
        guard pageNumber < pageTotal else {return}
        var lastResult = pageNumber == pageTotal - 1
        if lastResult{
            //loADING
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.arrMasterData += [Int](0..<self.pageSize)
                self.tblChat.reloadData()
                self.pageNumber += 1
            }
        }
    }
}
