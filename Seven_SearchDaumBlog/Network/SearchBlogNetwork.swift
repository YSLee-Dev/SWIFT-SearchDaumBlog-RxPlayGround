//
//  SearchBlogNetwork.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/24.
//

import Foundation

import RxSwift

enum SearchNetworkError : Error{
    case jsonError
    case urlError
    case networkError
}

class SearchBlogNetwork {
    private let session : URLSession
    let api = SearchBlogAPI()
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    func searchBlog(query : String) -> Single<Result<DKBlogModel, SearchNetworkError>>{
        guard let url = api.searchBlog(query: query).url else{
            return .just(.failure(.urlError))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK ee4d7d4ed81b615d3e6a046468666b0e", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map{
                do{
                    let blogData = try JSONDecoder().decode(DKBlogModel.self, from: $0)
                    return .success(blogData)
                }catch{
                    return .failure(.jsonError)
                }
            }
            .catch{ _ in
                .just(.failure(.networkError))
            }
            .asSingle()
    }
}
