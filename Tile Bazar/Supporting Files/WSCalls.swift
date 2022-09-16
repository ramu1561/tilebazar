//
//  WSCalls.swift
//  Tile Bazar
//
//  Created by Apple on 8/15/22.
//

import UIKit
import Alamofire

typealias SuccessCompletionBlock = ((_ reponse : [String : AnyObject],_ statuscode : Int?) ->())
typealias ErrorCompletionBlock = ((String) ->())
typealias ImageDownlodingBlock = ((_ image : UIImage?,_ statuscode : Int,_ errormsg : String) ->())

class WSCalls: NSObject {

    static let sharedInstance = WSCalls()
    
    func uploadImagewithData(image : UIImage,imageName : String,url : String,param : [String : String],header : [String:String]?,successHandler : @escaping SuccessCompletionBlock,erroHandler : @escaping SuccessCompletionBlock,failureHandler : @escaping ErrorCompletionBlock){
        print("WSURL = \(url)")
        print("Parameter = \(param)")
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in param {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
            if let imageData = image.jpegData(compressionQuality: 1.0){
                multipartFormData.append(imageData, withName: imageName, fileName: self.getImageName(), mimeType: "image/png")
            }
            }, to: url, method: .post, headers: header,
                encodingCompletion: { encodingResult in
                switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON {
                            response in
                            switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    if let jsonResponse = data as? [String : AnyObject]{
                                        print("Response \(jsonResponse)")
                                        if let success = jsonResponse["IsSuccess"] as? Bool{
                                            if success{
                                            successHandler(jsonResponse,response.response?.statusCode)
                                            }
                                            else{
                                                erroHandler(jsonResponse,response.response?.statusCode)
                                            }
                                        }
                                    }
                                }
                                break
                                
                            case .failure(_):
                                if let data = response.data {
                                    let json = String(data: data, encoding: String.Encoding.utf8)
                                    //print("Failure Response: \(String(describing: json))")
                                }
                                failureHandler(response.result.error!.localizedDescription)
                                break
                            }
                        }
                    case .failure(let encodingError):
                        failureHandler(encodingError.localizedDescription)
                    }
        })
    }

    func apiCall(url : String,method : HTTPMethod,param : [String : Any],successHandler : @escaping SuccessCompletionBlock,erroHandler : @escaping SuccessCompletionBlock,failureHandler : @escaping ErrorCompletionBlock){
        print("WSURL = \(url)")
        print("Parameter = \(param)")
        Alamofire.request(url, method:method, parameters: param, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    if let jsonResponse = data as? [String : AnyObject]{
                        if let success = jsonResponse["IsSuccess"] as? Bool{
                            if success{
                                successHandler(jsonResponse,response.response?.statusCode)
                            }
                            else{
                                erroHandler(jsonResponse,response.response?.statusCode)
                            }
                        }
                    }
                }
                break
                
            case .failure(_):
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    //print("Failure Response: \(json)")
                }
                failureHandler(response.result.error!.localizedDescription)
                break
            }
        }
    }
    
    func apiCallWithHeader(url : String,method : HTTPMethod,param : [String : Any],headers : [String:String],successHandler : @escaping SuccessCompletionBlock,erroHandler : @escaping SuccessCompletionBlock,failureHandler : @escaping ErrorCompletionBlock){
        print("WSURL = \(url)")
        print("Parameter = \(param)")
        print("Header = \(headers)")
        Alamofire.request(url, method: method, parameters: param, headers: headers).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    if let jsonResponse = data as? [String : AnyObject]{
                        if let success = jsonResponse["IsSuccess"] as? Bool{
                            if success{
                                successHandler(jsonResponse,response.response?.statusCode)
                            }
                            else{
                                erroHandler(jsonResponse,response.response?.statusCode)
                            }
                        }
                    }
                }
                break
                
            case .failure(_):
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    //print("Failure Response: \(json)")
                }
                failureHandler(response.result.error!.localizedDescription)
                break
            }
        }
    }
    func apiCallWithoutParams(url : String,method : HTTPMethod,headers : [String:String],successHandler : @escaping SuccessCompletionBlock,erroHandler : @escaping SuccessCompletionBlock,failureHandler : @escaping ErrorCompletionBlock){
        print("WSURL = \(url)")
        print("Header = \(headers)")
        Alamofire.request(url, method: method, headers: headers).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    if let jsonResponse = data as? [String : AnyObject]{
                        if let success = jsonResponse["IsSuccess"] as? Bool{
                            if success{
                                successHandler(jsonResponse,response.response?.statusCode)
                            }
                            else{
                                erroHandler(jsonResponse,response.response?.statusCode)
                            }
                        }
                    }
                }
                break
                
            case .failure(_):
                if let data = response.data {
                    let json = String(data: data, encoding: String.Encoding.utf8)
                    //print("Failure Response: \(json)")
                }
                failureHandler(response.result.error!.localizedDescription)
                break
            }
        }
    }
    func postImageuploading(image : UIImage,url : String,method : HTTPMethod,param : NSMutableDictionary,block : @escaping SuccessCompletionBlock){
        print("WSURL = \(url)")
        print("Parameter = \(param)")
        let param = param as! [String : Any]
        Alamofire.request(url, method: method, parameters: param, headers: nil).responseJSON { (response) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    print(data)
                    block(data as! [String : AnyObject],(response.response?.statusCode))
                }
                break
                
            case .failure(_):
                print(response.result.error ?? "")
                break
            }
        }
    }

    func getImageName() -> String{
        return "\(NSTimeIntervalSince1970).png"
    }
}
