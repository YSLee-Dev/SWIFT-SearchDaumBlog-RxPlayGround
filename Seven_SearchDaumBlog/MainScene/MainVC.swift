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
        
    }
    
    // View의 꾸미는 함수
    private func attribute(){
        self.title = "Daum Blog Search"
        self.view.backgroundColor = .white
    }
    
    // layout(snap kit) 함수
    private func layout(){
        
    }
}
