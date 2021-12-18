//
//  GetModel.swift
//  test
//
//  Created by H, Alfatkhu on 17/12/21.
//
import Foundation

class GetModel: Model {
    
    override var _apiName: String {
        get {
            return super.apiName!
        }
        set {
            super._apiName = newValue
        }
    }
}
