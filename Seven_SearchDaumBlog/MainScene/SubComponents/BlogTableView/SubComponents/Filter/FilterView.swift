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
        $0.setTitle("필터", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let border = UIView().then{
        $0.backgroundColor = .gray
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel : FilterViewModel){
        self.sortBtn.rx.tap
            .bind(to: viewModel.sortBtnClick)
            .disposed(by: bag)
            
    }
    
    private func layout(){
        [self.sortBtn, self.border]
            .forEach{
                self.addSubview($0)
            }
        
        self.sortBtn.snp.makeConstraints{
            $0.size.equalTo(45)
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
        }
        self.border.snp.makeConstraints{
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}
