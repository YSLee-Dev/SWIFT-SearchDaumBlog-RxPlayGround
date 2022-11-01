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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel : SearchBarViewModel){
        self.rx.text
            .bind(to: viewModel.tfText)
            .disposed(by: self.bag)
        
        // btn이 눌렸을 때, 키보드의 서치버튼을 눌렀을 때
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                self.btn.rx.tap.asObservable()
            )
            .bind(to: viewModel.btnClick)
            .disposed(by: bag)
        
        viewModel.btnClick
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: bag)
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
