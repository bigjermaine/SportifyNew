//
//  ActionView.swift
//  TIRED
//
//  Created by Apple on 18/05/2023.
//

import Foundation
import UIKit

struct ActionaLabelViewModel {
    let text:String
    let actionTitle:String
}



 protocol  ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView:ActionLabelView)
}



class ActionLabelView:UIView {
    
    weak var delegate:ActionLabelViewDelegate?
    private let label:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
       return label
    }()
    private let button:UIButton = {
       let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    override init(frame:CGRect){
        super.init(frame:frame)
     
        clipsToBounds = true
        isHidden = true
        addSubview(button)
        addSubview(label)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }
    required init?(coder:NSCoder){
        fatalError()
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: height - 40, width: width, height: 40)
        button.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
    }
   
    func configure( with viewmodel: ActionaLabelViewModel) {
        label.text = viewmodel.text
        button.setTitle(viewmodel.actionTitle, for: .normal)
    }
}
 
