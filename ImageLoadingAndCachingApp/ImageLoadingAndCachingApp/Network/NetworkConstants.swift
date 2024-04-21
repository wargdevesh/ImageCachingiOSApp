//
//  NetworkConstants.swift
//  ImageLoadingAndCachingApp
//
//  Created by Devesh Pandey on 21/04/24.
//

import Foundation

class NetworkConstants{
    
    public static let shared : NetworkConstants = NetworkConstants()
    private init(){
    }

    let baseUrl : String = "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=100"
}
