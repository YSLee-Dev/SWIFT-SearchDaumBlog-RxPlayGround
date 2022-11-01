//
//  MainVCModel.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/11/01.
//

import Foundation

import RxSwift
import RxCocoa

struct MainVCModel{
    let bag = DisposeBag()
    
    let blogTableViewModel = BlogTableViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionClick = PublishRelay<MainVC.AlertAction>()
    let shouldPresentAlert : Signal<MainVC.Alert>
    
    init(model : MainModel = MainModel()){
        let blogResult = self.searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        // 데이터만 가져옴
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
           
        
        // Error만 가져옴
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        // 네트워크를 통해 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        // FilterView를 선택했을 때 나오는 alertsheet 타입
        let sortedType = alertActionClick
            .filter{
                switch $0{
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        // tableView에 출력
        Observable
            .combineLatest(sortedType, cellData, resultSelector: (model.sort))
            .bind(to: self.blogTableViewModel.blogCellData)
            .disposed(by: self.bag)
        
        let alertForErrorMsg = blogError
            .map{ msg -> MainVC.Alert in
                return(
                    title: "에러",
                    message: msg,
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        let alertSheetForSorting = self.blogTableViewModel.filterViewModel.sortBtnClick
            .map{ _ -> MainVC.Alert in
                return MainVC.Alert(title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        self.shouldPresentAlert = Observable
            .merge(alertForErrorMsg, alertSheetForSorting)
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
