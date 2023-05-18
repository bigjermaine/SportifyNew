//
//  SearchResultSubTitle.swift
//  TIRED
//
//  Created by Apple on 14/05/2023.
//

import UIKit
import SDWebImage

class SearchResultTitlesSubtitleTableViewCell: UITableViewCell {
    
    static let  identifier = "SearchResultTitlesSubtitleTableViewCell"
    
    private let label:UILabel =   {
        let label = UILabel()
        label.textColor =  .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 15,weight: .bold)
        return label
    }()
    private let subLabel:UILabel =   {
        let label = UILabel()
        label.textColor =  .secondaryLabel
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12,weight: .bold)
        return label
    }()
    private let SearchResultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(SearchResultImageView)
        contentView.addSubview(label)
        contentView.addSubview(subLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            SearchResultImageView.frame = CGRect(x: 10, y: 0, width:contentView.height-10,height: contentView.height-10)
            label.frame = CGRect(x:  SearchResultImageView.right+10, y: 0, width: contentView.width - SearchResultImageView.right - 15, height: contentView.height/2)
            subLabel.frame = CGRect(x:  SearchResultImageView.right+10, y:label.bottom, width: contentView.width - SearchResultImageView.right - 15, height: contentView.height/2)
        }
        func configure(with viewModel: SearchResultTitlesSubtitleViewModel) {
            label.text = viewModel.title
            SearchResultImageView.sd_setImage(with:viewModel.image)
            subLabel.text = viewModel.subTitle
        }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        SearchResultImageView.image = nil
        subLabel.text = nil
    }
    }
