//
//  SearchBlogAPI.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/24.
//

import Foundation

struct SearchBlogAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/search/"
    
    func searchBlog(query : String) -> URLComponents{
        var componets = URLComponents()
        componets.scheme = SearchBlogAPI.scheme
        componets.host = SearchBlogAPI.host
        componets.path = SearchBlogAPI.path + "blog"
        
        componets.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        return componets
    }
}
