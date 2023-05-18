//
//  TitleHeaderCollectionViewCell.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import Foundation
import UIKit

class TitleHeaderCollectionView:UICollectionReusableView {
    static let identifier = " TitleHeaderCollectionView"
    
    private let label:UILabel =   {
        let label = UILabel()
        label.textColor =  .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20,weight: .bold)
       return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: 0, width: width - 20, height: height)
    }
    func configure(with title:String) {
        label.text = title
    }
}
