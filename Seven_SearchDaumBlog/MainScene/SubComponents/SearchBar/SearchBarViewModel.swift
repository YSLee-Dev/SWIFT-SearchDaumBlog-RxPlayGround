//
//  SearchBarViewModel.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/11/01.
//

import Foundation

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    let tfText = PublishRelay<String?>()
    let btnClick = PublishRelay<Void>()
    let shouldLoadResult : Observable<String>
    
    init(){
        self.shouldLoadResult = btnClick
            .withLatestFrom(tfText){$1 ?? ""}
            .filter{!$0.isEmpty}
            .distinctUntilChanged()
    }
}
