//
//  APICaller.swift
//  ImageLoadingAndCachingApp
//
//  Created by Devesh Pandey on 21/04/24.
//

import Foundation
enum  ErrorCases : String,Error{
    case UrlError = "The Url is wrong"
    case NetworkError = "Network Error "
    case ConvertionError = "Unrecognised Error"
}
class APICaller{
   static func getData( _ completionHander : @escaping(_ result : Result<APIResponse,ErrorCases>) -> Void){
        
        let urlString = NetworkConstants.shared.baseUrl
        let url = URL(string: urlString)
        guard let url = url else{
            completionHander(.failure(.UrlError))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "get"
        
        URLSession.shared.dataTask(with: urlRequest) { responseData, networkResponse, error in
            
            if error == nil , let result = responseData {
                do{
                    let data = try JSONDecoder().decode(APIResponse.self, from: result)
                    completionHander(.success(data))
                }catch{
                    completionHander(.failure(.ConvertionError))
                }
            }
            else{
                completionHander(.failure(.NetworkError))
            }
        }.resume()
        
    }
}
