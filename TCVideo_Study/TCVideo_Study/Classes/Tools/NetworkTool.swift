//
//  NetworkTool.swift
//  TCVideo_Study
//
//  Created by tcan on 17/6/19.
//  Copyright © 2017年 tcan. All rights reserved.
//

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

class NetworkTool {

    /// 请求网络
    ///
    /// - Parameters:
    ///   - type: get or post
    ///   - URLString: 请求链接
    ///   - parameters: 参数
    class func requestData(_ type : MethodType, URLString : String, parameters : [String : Any]? = nil, finishedCallback : @escaping (_ result : Any) -> ()) {
        
        //请求类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //发送请求
        Alamofire.request(URLString, method: method, parameters: parameters).validate(contentType: ["text/plain"]).responseJSON{
            (response) in
            
            //获取结果
            guard let result = response.result.value else{
                print(response.result.error!)
                return
            }
            
            //回调结果
            finishedCallback(result)
        }
    }
    
    class func getRequestWithURL(path :String,parameter:[String: Any]?, success: @escaping (_ result: Any) -> Void ,failure: @escaping (_ error: Error) -> Void ) -> Void {
        
//        Alamofire.SessionManager.defaultHTTPHeaders.updateValue("application/json", forKey: "Accept")

        //发送请求
        Alamofire.request(path, method: .get, parameters: parameter).validate(contentType: ["application/json"]).responseJSON{
            (response) in
            
            //获取结果
            guard let result = response.result.value else{
                print(response.result.error!)
                failure(response.result.error!)
                return
            }
            
            //回调结果
            success(result)
        }
    }
}
