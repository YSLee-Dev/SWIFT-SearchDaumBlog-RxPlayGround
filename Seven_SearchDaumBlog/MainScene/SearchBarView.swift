//
//  SearchBarView.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/19.
//

import UIKit

import RxSwift
import RxCocoa
import Then

class SearchBarView : UISearchBar{
    let bag = DisposeBag()
    
    let btn = UIButton().then{
        $0.setTitle("검색", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
    }
    
    // SearchBar btn tap 이벤트
    let btnClick = PublishRelay<Void>()
    
    // SearchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.bind()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        // btn이 눌렸을 때, 키보드의 서치버튼을 눌렀을 때
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                self.btn.rx.tap.asObservable()
            )
            .bind(to: self.btnClick)
            .disposed(by: bag)
        
        self.btnClick
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: bag)

        
        self.shouldLoadResult = btnClick
            .withLatestFrom(self.rx.text){$1 ?? ""}
            .filter{!$0.isEmpty}
            .distinctUntilChanged()
    }
    
    
    private func layout(){
        self.addSubview(self.btn)
        
        self.searchTextField.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(self.btn.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
        }
        self.btn.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}

extension Reactive where Base : UISearchBar{
    var endEditing : Binder<Void>{
        return Binder(base){base, _ in
            base.endEditing(true)
        }
    }
}
