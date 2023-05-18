//
//  APICaller.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation

class APICaller {
    
    
    static let shared = APICaller()
    
    
    private init() {}
    
    struct Constants {
        static let baseaAPIURL = "https://api.spotify.com/v1/me"
        static let baseaAPIURL2 = "https://api.spotify.com/v1"
    }
    
    enum APIError:Error {
        case failedToGetData
    }
    
    enum HTTPMethod:String {
        case GET
        case POST
        
    }
    
    public func  search(with query: String,completion:@escaping(Result<[ SearchResult],Error>) -> Void ) {
        createRequest(with: URL(string: Constants.baseaAPIURL2+"/search?limit=10&type=album,artist,playlist,track&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return}
                do {
                    
                   
                    
                    let result = try JSONDecoder().decode(  SearchResultResponse.self, from: data)
                    var searchResults:[SearchResult] = []
                    searchResults.append(contentsOf: result.tracks.items.compactMap({.track(model: $0)}))
                    searchResults.append(contentsOf: result.artists.items.compactMap({.artist(model: $0)}))
                    searchResults.append(contentsOf: result.albums.items.compactMap({.album(model: $0)}))
                    
                    searchResults.append(contentsOf: result.playlists.items.compactMap({.playlist(model: $0)}))
                    completion(.success(searchResults))
                    
                 }catch{
                    print(error.localizedDescription)
                    completion(.failure(APIError.failedToGetData))
                 }
              }
            task.resume()
         }
     }
    
    
    
    public func getCurrentUserPlaylist(completion:@escaping(Result<[Playlist], Error>)-> Void) {
        createRequest(with: URL(string: Constants.baseaAPIURL2 + "/me/playlists/?limit=50"), type:
                .GET) { request in
                    let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                        guard let data = data , error == nil else {
                            completion(.failure(APIError.failedToGetData))
                            return}
                        do{
                            let result = try JSONDecoder().decode(LibraryPlayListResponse.self, from: data)
                            completion(.success(result.items))
                        }catch{
                            print(error.localizedDescription)
                            completion(.failure(APIError.failedToGetData))
                        }
                    }
                    task.resume()
               }
          }
    public func   createPlaylist(with name:String,completion:@escaping(Bool)->Void) {
        getCurrentUserProfile {[weak self] result in
            switch result {
                
            case .success(let result):
                let urlstring = Constants.baseaAPIURL2 + "/users/\(result.id)/playlists"
                self?.createRequest(with:URL(string: urlstring), type: .POST, completion: { baserequest in
                    var request = baserequest
                    let json = [
                        "name":name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json,options: .fragmentsAllowed)
                    let task =  URLSession.shared.dataTask(with: request) { data, _ , error in
                        guard let data = data , error == nil else {
                            completion(false)
                        return}
                    do {
                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                         print(json)
                        }catch{
                            completion(false)
                            print(error.localizedDescription)
                        }
                    }
                    task.resume()
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    public func addTrackToPlaylist(track:AudioTrack,playlist:Playlist,completion:@escaping(Bool)->Void){}
    public func removeTrack(track:AudioTrack,playlist:Playlist,completion:@escaping(Bool)->Void){}
    public func getAllCategories(completion: @escaping(Result< [Category],Error>) ->Void){
        createRequest(with: URL(string: Constants.baseaAPIURL2 + "/browse/categories?limit=50" ), type:
            .GET) { request in
        let task = URLSession.shared.dataTask(with: request) { data, _ , error in
        guard let data = data , error == nil else {
        completion(.failure(APIError.failedToGetData))
        return}
        do {
                            
//                   let json = try JSONSerialization.jsonObject(with: data,options:           .allowFragments)
//                    print(json)
            let result = try JSONDecoder().decode( ALLCategoriesResponse.self, from: data)
            completion(.success(result.categories.items))
            print(result)
            }catch{
            print(error.localizedDescription)
            completion(.failure(APIError.failedToGetData))
             }
            }
            task.resume()
           }
          }
    public func getCategoriesPlaylist(category:Category,completion: @escaping(Result< [Playlist],Error>) ->Void){
        createRequest(with: URL(string: Constants.baseaAPIURL2 + "/browse/categories/\(category.id)/playlists?limit=10" ), type:
                .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _ , error in
            guard let data = data , error == nil else {
            completion(.failure(APIError.failedToGetData))
            return}
            do {
            let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
            print(json)
            let result = try JSONDecoder().decode(CategoryPlayListsResponse.self, from: data)
                completion(.success(result.playlists.items))
            print(result)
            }catch{
            print(error.localizedDescription)
            completion(.failure(APIError.failedToGetData))
                        }
                    }
                    task.resume()
                }
          }
  
   public func getAlbumDetails(for album: Album, completion: @escaping(Result< AlbumDetailsResponse,Error>) ->Void){
    createRequest(with: URL(string: Constants.baseaAPIURL2 + "/albums/" + album.id), type:
        .GET) { request in
                 let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                  guard let data = data , error == nil else {
                            completion(.failure(APIError.failedToGetData))
                            return}
                     do {
                         let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                          completion(.success(result))
                        //  print(result)
                        }catch{
                            print(error.localizedDescription)
                            completion(.failure(APIError.failedToGetData))
                        }
                    }
                    task.resume()
                }
             }
    public func getplaylistDetails(for  playlist: Playlist, completion: @escaping(Result< PlaylistDetailsResponse,Error>) ->Void){
      createRequest(with: URL(string: Constants.baseaAPIURL2 + "/playlists/" + playlist.id), type:
          .GET) { request in
                   let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                    guard let data = data , error == nil else {
                              completion(.failure(APIError.failedToGetData))
                              return}
                       do {
                           let result = try JSONDecoder().decode(  PlaylistDetailsResponse.self, from: data)
                            completion(.success(result))
                           // print(result)
                         
                          }catch{
                              print(error.localizedDescription)
                              completion(.failure(APIError.failedToGetData))
                          }
                      }
                      task.resume()
                  }
               }
    //MARK:Browser
    public func getCurrentUserProfile(completion: @escaping(Result< UserProfile,Error>) ->Void){
        createRequest(with: URL(string: Constants.baseaAPIURL), type: .GET) { baserequest in
            let task = URLSession.shared.dataTask(with: baserequest) { data, _ , error in
                guard let data = data , error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return}
                do {
                    
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
 
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(APIError.failedToGetData))
                }
            }
            task.resume()
        }
       
        
        
    }
    
    func createRequest(with url:URL?, type:HTTPMethod, completion: @escaping(URLRequest)-> Void) {
        AuthManager.shared.withvalidtoken { token in
            guard let apiURL = url else {return}
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
    
    
    
    public func getNewRelaseses(completion:@escaping((Result<NewReleasesResponse,Error>))-> Void ) {
        createRequest(with: URL(string: Constants.baseaAPIURL2+"/browse/new-releases?limit=50"), type: .GET) {  request in
            let tasks = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {return
                    completion(.failure(APIError.failedToGetData))
                }
                do {
                    
                      let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                       completion(.success(result))
//                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
//                    print(json)
                }catch {
                    completion(.failure(APIError.failedToGetData))
                    print(error.localizedDescription)
                }
            }
            tasks.resume()
          
        }
      
    }
    
    public func getfeaturedPlaylist(completion:@escaping((Result<FeaturedPlayListsResponse,Error>))-> Void ) {
        
        createRequest(with: URL(string: Constants.baseaAPIURL2+"/browse/featured-playlists?limit=50"), type: .GET) {  request in
            let tasks = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {return
                    completion(.failure(APIError.failedToGetData))
                }
                do {
                    
                    
                      let result = try JSONDecoder().decode(FeaturedPlayListsResponse.self, from: data)
                       completion(.success(result))
                    //print(result)
                }catch {
                    completion(.failure(APIError.failedToGetData))
                    print(error.localizedDescription)
                }
            }
            tasks.resume()
          
        }
      
        
    }
    
    
    public func  getRecommendations(genres:Set<String>,completion:@escaping((Result<RecommendationResponse,Error>))-> Void ) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseaAPIURL2+"/recommendations?limit=40&seed_genres=\(seeds)"),
                      type: .GET) {  request in
            let tasks = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {return
                    completion(.failure(APIError.failedToGetData))
                }
                do {
                    
                    let result = try JSONDecoder().decode(RecommendationResponse.self, from: data)
                     completion(.success(result))
                  //  print(result)
                }catch {
                    completion(.failure(APIError.failedToGetData))
                    print(error.localizedDescription)
                }
            }
            tasks.resume()
          
         }
        }
    
    
    
    public func  getRecommendationsSeeds(completion:@escaping((Result< RecommendedGenresResponse,Error>))-> Void ) {
        createRequest(with: URL(string: Constants.baseaAPIURL2+"/recommendations/available-genre-seeds"),
                      type: .GET) {  request in
            let tasks = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data , error == nil else {return
                    completion(.failure(APIError.failedToGetData))
                }
                do {
                    
                      let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                       completion(.success(result))
                  //  print(result)
                }catch {
                    completion(.failure(APIError.failedToGetData))
                    print(error.localizedDescription)
                }
            }
            tasks.resume()
          
        }
        }
        
    }
 
