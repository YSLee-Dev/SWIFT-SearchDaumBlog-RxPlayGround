//
//  BlogTableViewModel.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/11/01.
//

import Foundation

import RxSwift
import RxCocoa

struct BlogTableViewModel{
    let filterViewModel = FilterViewModel()
    
    // 부모뷰(MainVC) 네트워크 작업 -> BlogTableView
    let blogCellData = PublishSubject<[BlogDataModel]>()
    let cellData : Driver<[BlogDataModel]>
    
    init(){
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
    
}
