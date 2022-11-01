//
//  BlogTableView.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/20.
//

import UIKit

import RxSwift
import RxCocoa

class BlogTableView : UITableView{
    let bag = DisposeBag()
    
    let header = FilterView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: UIScreen.main.bounds.width, height: 50)
        )
    )
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(viewModel : BlogTableViewModel){
        self.header.bind(viewModel: viewModel.filterViewModel)
        viewModel.cellData
            .drive(self.rx.items){ tv, row, data in
                let index = IndexPath(row: row, section: 0)
                let cell = tv.dequeueReusableCell(withIdentifier: "TableViewCell", for: index) as! TableViewCell
                cell.setData(data: data)
                
                return cell
            }
            .disposed(by: bag)
    }
    
    private func attribute(){
        self.backgroundColor = .white
        self.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = self.header
    }
}
