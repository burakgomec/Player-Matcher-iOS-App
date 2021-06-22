//
//  WebService.swift
//  PlayerMatcher
//
//  Created by Burak on 18.06.2021.
//

import Foundation


class WebService{
    
    static let shared = WebService()
    let session = URLSession.shared
    
    
    func test(completion: @escaping (String?)->()){
        guard let url  = URL(string: "http://localhost:5001/api/v1/Home") else { return print("An error occurred in the url")}
        
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { data, response, error in
            if error == nil && data != nil{
                guard let result = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else { return completion("Json Serialization Error")}
 
                guard let message = result["message"] as? String else { return print("An error occurred in the message")}
                completion(message)
            }
            else{
                completion("Data is nil")
            }
        }.resume()
    }
    

    func loginRequests(loginNumber: Int, username: String, email: String, password: String, completion: @escaping (Bool,String?)->()){
        var url : URL?
        if(loginNumber == 1){//Sign In Request
            url = URL(string: "http://localhost:5001/api/v1/Home/signin")
        }
        else{//Sign Up Request
            url = URL(string: "http://localhost:5001/api/v1/Home/signup")
        }
    
        var request = URLRequest(url: url!)
       
        let parameterDictionary = ["username":username, "email":email, "password":password]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else { return print("An error occurred in the body data")}
        
        request.httpMethod = "POST"
        
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type") //Content-Type : Application/json
        request.httpBody = bodyData
      
        session.dataTask(with: request) { data, response, error in
            if error == nil && response != nil{
                
                guard let httpResponse = response as? HTTPURLResponse else { return completion(false,nil)}
                guard let result = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else { return completion(false,nil)}
                guard let message = result["title"] as? String else { return completion(false,nil)}
                
                if httpResponse.statusCode == 200 {
                    completion(true,message)
                }
                else{
                    completion(false,message)
                }
            }
            else{
                completion(false,error?.localizedDescription)
            }
        }.resume()

    }
    

    func findPlayerRequest(completion: @escaping (Bool,Player?)->()){
        let url = URL(string: "http://localhost:5001/api/v1/GameScene/matchmaking")
        var request = URLRequest(url: url!)
     
        guard let username = User.getUser()?.username else { return }
        let parameterDictionary = ["username":username]
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let body = try? JSONSerialization.data(withJSONObject: parameterDictionary, options: []) else{ return completion(false,nil)}
        
        request.httpBody = body
    
        session.dataTask(with: request) { data, response, error in
            if error == nil && data != nil{
                let jsonDecoder = JSONDecoder()
                let player = try? jsonDecoder.decode(Player.self, from: data!)

                completion(true,player)
            }
            else{
                completion(false, nil)
            }
        }.resume()
    }
    
    
    
    
    func levelUpRequest(){
        
        
    }
    func logoutRequest(){
        
        
    }
    
    private init(){}
}
