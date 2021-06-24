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
    

    func loginRequests(loginNumber: Int, username: String, email: String, password: String, completion: @escaping (Bool,String?)->()){//Post Request
        var url : URL?
        if(loginNumber == 1){//Sign In Request
            url = URL(string: "http://localhost:5001/api/v1/Auth/signin")
        }
        else{//Sign Up Request
            url = URL(string: "http://localhost:5001/api/v1/Auth/signup")
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

                
                if httpResponse.statusCode == 200 {
                    guard let token = result["token"] as? String else { return completion(false,nil)}
                    User.setUser(username: username, email: email, password: password,token: token)
                    completion(true,nil)
                }
                else{
                    guard let message = result["title"] as? String else { return completion(false,nil)}
                    completion(false,message)
                }
            }
            else{
                completion(false,error?.localizedDescription)
            }
        }.resume()

    }
    

    func findPlayerRequest(completion: @escaping (Bool,Player?)->()){//Get Request
        guard let username = User.getUser()?.username else { return }

        guard var components = URLComponents(string: "http://localhost:5001/api/v1/GameScene/matchmaking") else {return }
        components.queryItems = [URLQueryItem(name: "username", value: username )]
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    
    
    func levelUpRequest(completion: @escaping (Bool,Player?)->()) {//Patch Request
        guard let username = User.getUser()?.username else { return }
        guard var components = URLComponents(string: "http://localhost:5001/api/v1/GameScene/levelup") else {return }
        components.queryItems = [URLQueryItem(name: "username", value: username),URLQueryItem(name: "token", value: User.getUser()?.sessionToken)]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "PATCH"
        
        session.dataTask(with: request) { data, response, error in
            if error == nil && data != nil{
                let decoder = JSONDecoder()
                let player = try? decoder.decode(Player.self, from: data!)
                completion(true,player)
            }
            else{
                completion(false,nil)
            }
        }.resume()
        
    }
    
    private init(){}
}
