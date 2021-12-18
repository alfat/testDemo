//
//  Service.swift
//  test
//
//  Created by H, Alfatkhu on 17/12/21.
//

import Foundation
import Alamofire

typealias ResultStatus = NSInteger
var ResultStatusFailed:ResultStatus = 0
var ResultStatusSuccess:ResultStatus = 1


@objc protocol ModelDelegate: class {
    @objc optional func starting(model:Model)
    @objc optional func cancelForModel(model:Model)
    
    @objc func modeldoneWithData(model:Model, result:Any)
    @objc func modelfailedWithError(model:Model, error:NSError)
}

class Model: NSObject {
    weak var delegate: ModelDelegate?
    var apiName: String?
    public internal(set) var _apiName: String {
        get {
            return self.apiName!
        }
        set {
            self.apiName = newValue
        }
    }
    
    // Response
    var status: ResultStatus?
    var message: String?
    
    func createURL() -> String {
        return "https://jsonplaceholder.typicode.com/"
    }
    
    func fetchWithDelegate(_delegate: ModelDelegate) {

        delegate = _delegate
        let strUrl = String(format: "%@%@", self.createURL(), _apiName as! String)
        let userDefaults = UserDefaults.standard
        let dictDataUser = userDefaults.object(forKey: "master") as! NSDictionary
        let idUser = dictDataUser.object(forKey: "id")
        let apiComent = String(format: "posts/%@/comments", idUser as! CVarArg)
        
        // All three of these calls are equivalent
        AF.request(strUrl).responseJSON {
            response in
            if let JSON = response.value {
                
                if(self._apiName == "users" || self._apiName == "posts" || self._apiName == apiComent){
                    let response = JSON as! NSArray
                    _delegate.modeldoneWithData(model: self, result: response)
                }
                else{
                    let response = JSON as! NSDictionary
                    _delegate.modeldoneWithData(model: self, result: response)
                }
            }
            else {
                self.status = ResultStatusFailed
                _delegate.modelfailedWithError(model: self, error: NSError(domain: self.createURL(), code: 500, userInfo: nil))
            }
        }
    }
}

