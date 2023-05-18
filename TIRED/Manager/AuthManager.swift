//
//  AuthManager.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation



struct Constants {
  static let clientID = "87510d91dc934b108f95939901ce613b"
  static let sharedSecret = "1f89ee6154e44913927b503299cbc37d"
  static let tokenApiUrl = "https://accounts.spotify.com/api/token"
}

//1fd34febd311451e97200b08734164d5
final class AuthManager {
    
    static let shared = AuthManager()
    
    private var refreshingToken = false
  
    private init () {
        
    }
    public var signedURL: URL? {
        let redirectuli = "https://www.iosacademy.io"
        let scopes = "user-read-private%20playlist-modify-public%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
        let baseUrl = "https://accounts.spotify.com/authorize"
        let string = "\(baseUrl)?response_type=code&client_id=\(Constants.clientID)&scope=\(scopes)&redirect_uri=\(redirectuli)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
      private var accessToken:String? {
          return   UserDefaults.standard.string(forKey: "access_token")
      }
    
    
    private var refreshToken:String? {
        return   UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    
    private var tokenExpirationDate:Date? {
        return  UserDefaults.standard.object(forKey:"expires_in") as? Date
    }
    
    
    
   public var shouldRefreshToken:Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
            
        }
        let currentDate = Date()
        let fiveMinutes:TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    
    
    public func exchangeCodeForToken(code:String,completion:@escaping(Bool)->Void) {
        guard let url = URL(string:Constants.tokenApiUrl) else {return}
        
         
        var components = URLComponents()
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "authorization_code"),
        URLQueryItem(name: "code", value: code),
        URLQueryItem(name: "redirect_uri", value:"https://www.iosacademy.io"),
        
        
        
        ]
        var request = URLRequest(url: url)
       
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.sharedSecret
        let data = basicToken.data(using: .utf8)
        let base64String = data?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            guard let data = data , error == nil else {
                
                completion(false)
                return}
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: result)
                completion(true)
                
//                let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//                print("\(json)")
            }catch{
                completion(false)
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    private var onRefreshBlocks = [((String)-> Void)]()
    
     func withvalidtoken(completion:@escaping(String)->Void) {
        
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if  shouldRefreshToken {
            
            refreshIfNeeded { [weak self]  sucess in
                if let token = self?.accessToken,sucess {
                    completion(token)
                }
            }
            
            
        }else if let token = accessToken {
            completion(token)
        }
    }
    
   func refreshIfNeeded(completion:((Bool)->Void)?){
        guard !refreshingToken else {return}
        guard shouldRefreshToken else {
            completion?(true)
            return}

        guard let refreshToken =  self.refreshToken else {return}
        guard let url = URL(string:Constants.tokenApiUrl) else {return}
        
         refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
        URLQueryItem(name: "grant_type", value: "refresh_token"),
        URLQueryItem(name: "refresh_token", value:refreshToken),
        
        
        
        ]
        var request = URLRequest(url: url)
       
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let basicToken = Constants.clientID+":"+Constants.sharedSecret
        let data = basicToken.data(using: .utf8)
        let base64String = data?.base64EncodedString() ?? ""
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data , error == nil else {
                
                completion?(false)
                return}
            do {
                
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("sucess")
                self?.onRefreshBlocks.forEach{($0(result.access_token))}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true)

            }catch{
                completion?(false)
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    private func cacheToken(result:AuthResponse) {
        UserDefaults().set(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults().set(refresh_token, forKey: "refresh_token")
        }
        UserDefaults().set(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")
    }
    public func signOut(completion:(Bool)->Void) {
        UserDefaults().set(nil, forKey: "access_token")
     
        UserDefaults().set(nil, forKey: "refresh_token")
      
        UserDefaults().set(nil, forKey: "expires_in")
        completion(true)
    }
}

