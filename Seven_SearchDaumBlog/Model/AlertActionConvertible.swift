//
//  AlertActionConvertible.swift
//  Seven_SearchDaumBlog
//
//  Created by 이윤수 on 2022/10/20.
//

import UIKit

protocol AlertActionConvertible{
    var title : String {get}
    var style : UIAlertAction.Style {get}
}
