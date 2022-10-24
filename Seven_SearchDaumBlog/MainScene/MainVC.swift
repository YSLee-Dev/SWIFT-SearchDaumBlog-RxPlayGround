//
//  MainVC.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/19.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

class MainVC : UIViewController{
    let bag = DisposeBag()
    
    let searchBar = SearchBarView()
    let blogTableView = BlogTableView()
    
    let alertActionClick = PublishRelay<AlertAction>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.bind()
        self.attribute()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // (Rx swift) UI에 컨트롤, 컴포넌트 관리(바인딩) 함수
    private func bind(){
        let blogResult = self.searchBar.shouldLoadResult
            .flatMapLatest{ query in
                SearchBlogNetwork().searchBlog(query: query)
            }
            .share()
        
        // 데이터만 가져옴
        let blogValue = blogResult
            .compactMap{ data -> DKBlogModel? in
                guard case .success(let value) = data else {return nil}
                return value
            }
        
        // Error만 가져옴
        let blogError = blogResult
            .compactMap{ data -> String? in
                guard case .failure(let error) = data else{return nil}
                return error.localizedDescription
            }
        
        // 네트워크를 통해 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map{ blog -> [BlogDataModel] in
                blog.documents
                    .map{
                        let thumbnail = URL(string: $0.thumbnail ?? "")
                        return BlogDataModel(thumnailURL: thumbnail, name: $0.name, title: $0.title, datetime: $0.datetime)
                    }
            }
        
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
            .combineLatest(sortedType, cellData){ type, data -> [BlogDataModel] in
                switch type{
                case .title:
                    return data.sorted{$0.title ?? "" < $1.title ?? ""}
                case .datetime:
                    return data.sorted{$0.datetime ?? Date() > $1.datetime ?? Date()}
                default:
                    return data
                }
            }
            .bind(to: self.blogTableView.cellData)
            .disposed(by: self.bag)
        
        let alertForErrorMsg = blogError
            .map{ msg -> Alert in
                return(
                    title: "에러",
                    message: msg,
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        let alertSheetForSorting = self.blogTableView.header.sortBtnClick
            .map{ _ -> Alert in
                return Alert(title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        Observable
            .merge(alertForErrorMsg, alertSheetForSorting)
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest{ alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlert(alertController: alertController, actions: alert.actions)
            }
            .emit(to: self.alertActionClick)
            .disposed(by: self.bag)
    }
    
    // View의 꾸미는 함수
    private func attribute(){
        self.title = "Daum Blog Search"
        self.view.backgroundColor = .white
    }
    
    // layout(snap kit) 함수
    private func layout(){
        [self.searchBar, self.blogTableView]
            .forEach{
                self.view.addSubview($0)
            }
        
        self.searchBar.snp.makeConstraints{
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        self.blogTableView.snp.makeConstraints{
            $0.top.equalTo(self.searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// ALERT
extension MainVC {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)

    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style : UIAlertAction.Style{
            switch self{
            case .title, .datetime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    func presentAlert<Action: AlertActionConvertible>(alertController : UIAlertController, actions: [Action]) -> Signal<Action>{
        if actions.isEmpty {return .empty()}
        return Observable
            .create{ [weak self] observer in
                guard let self = self else {return Disposables.create()}
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(title: action.title, style: action.style, handler: { _ in
                            observer.onNext(action)
                            observer.onCompleted()
                        })
                    )
                }
                self.present(alertController, animated: true)
                return Disposables.create{
                    alertController.dismiss(animated: true)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
