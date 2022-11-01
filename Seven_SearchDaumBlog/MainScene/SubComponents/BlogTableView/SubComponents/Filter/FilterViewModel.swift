//
//  FilterViewModel.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/11/01.
//

import Foundation

import RxSwift
import RxCocoa

struct FilterViewModel{
    let sortBtnClick = PublishRelay<Void>()
}
