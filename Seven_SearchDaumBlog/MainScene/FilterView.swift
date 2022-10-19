//
//  FilterView.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/19.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

class FilterView : UITableViewHeaderFooterView{
    let bag = DisposeBag()
    
    let sortBtn = UIButton().then{
        $0.setImage(UIImage(named: "list.bullet"), for: .normal)
    }
    
    let border = UIView().then{
        $0.backgroundColor = .gray
    }
    
    // 외부에서 관찰하는 옵저버블
    var sortBtnClick = PublishRelay<Void>()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.bind()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        self.sortBtn.rx.tap
            .bind(to: sortBtnClick)
            .disposed(by: bag)
            
    }
    
    private func layout(){
        [self.sortBtn, self.border]
            .forEach{
                self.addSubview($0)
            }
        
        self.sortBtn.snp.makeConstraints{
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(25)
        }
        self.border.snp.makeConstraints{
            $0.leading.bottom.trailing.equalToSuperview()
            $0.top.equalTo(self.sortBtn.snp.bottom)
            $0.height.equalTo(0.5)
        }
    }
}
