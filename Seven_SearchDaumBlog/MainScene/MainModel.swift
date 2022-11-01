//
//  MainModel.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/11/01.
//

import Foundation

import RxSwift

struct MainModel{
    let network = SearchBlogNetwork()
    
    func searchBlog(query : String) -> Single<Result<DKBlogModel, SearchNetworkError>>{
        network.searchBlog(query: query)
    }
    
    func getBlogValue(result : Result<DKBlogModel, SearchNetworkError>) -> DKBlogModel? {
        guard case .success (let value) = result else {return nil}
        return value
    }
    
    func getBlogError(result : Result<DKBlogModel, SearchNetworkError>) -> String? {
        guard case .failure (let error) = result else {return nil}
        return error.localizedDescription
    }
    
    func getBlogListCellData(value : DKBlogModel) -> [BlogDataModel]{
        value.documents.map{
            let thumbnail = URL(string: $0.thumbnail ?? "")
            return BlogDataModel(thumnailURL: thumbnail, name: $0.name, title: $0.title, datetime: $0.datetime)
            
        }
    }
    
    func sort(type: MainVC.AlertAction, data: [BlogDataModel]) -> [BlogDataModel] {
        switch type {
        case .title:
            return data.sorted { $0.title ?? "" < $1.title ?? "" }
        case .datetime:
            return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
        case .cancel, .confirm:
            return data
        }
    }
}
