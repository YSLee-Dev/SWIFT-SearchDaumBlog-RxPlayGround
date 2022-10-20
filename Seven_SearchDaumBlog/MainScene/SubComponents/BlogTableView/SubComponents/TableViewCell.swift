//
//  TableViewCell.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/19.
//

import UIKit

import Then
import SnapKit
import Kingfisher

class TableViewCell : UITableViewCell{
    let thumnailImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    let nameLabel = UILabel().then{
        $0.font = .boldSystemFont(ofSize: 17)
    }
    let titleLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 2
    }
    let datetimeLabel = UILabel().then{
        $0.font = .systemFont(ofSize: 13)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout(){
        [self.thumnailImageView, self.nameLabel, self.titleLabel, self.datetimeLabel]
            .forEach{
                self.addSubview($0)
            }
        
        self.thumnailImageView.snp.makeConstraints{
            $0.top.bottom.trailing.equalToSuperview().inset(5)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        self.nameLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().inset(5)
            $0.trailing.equalTo(self.thumnailImageView.snp.leading).offset(-5)
        }
        
        self.titleLabel.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.nameLabel)
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(5)
        }
        
        self.datetimeLabel.snp.makeConstraints{
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(self.nameLabel)
            $0.bottom.equalTo(self.thumnailImageView)
        }
    }
    
    func setData(data : BlogDataModel){
        self.thumnailImageView.kf.setImage(with: data.thumnailURL, placeholder: UIImage(named: "photo"))
        self.nameLabel.text = data.name
        self.titleLabel.text = data.title
        
        var datetime : String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy년 MM월 dd일"
            return formatter.string(from: data.datetime ?? Date())
        }
        
        self.datetimeLabel.text = datetime
    }
}
