//
//  CategoryCollectionViewCell.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//



import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {

    static let  identifier = "CategoryCollectionViewCell"

    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "music.quarternote.3",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .white
        return imageView
    }()
    private let colors:[UIColor] = [
        .systemGreen,
        .systemRed,
        .systemBlue,
        .systemBrown,
        .systemPink,
        .systemPurple,
        .systemOrange,
        .systemYellow


    ]
    private var descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.font = .systemFont(ofSize:18,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

        override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(searchImageView)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
        searchImageView.image =  UIImage(systemName: "music.quarternote.3",withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.frame = CGRect(x: 10, y: CGFloat(Int(contentView.height)/2), width: contentView.width - 20, height: contentView.height/2)
        searchImageView.frame = CGRect(x: contentView.width/2, y: 0, width: contentView.width/2, height: contentView.height/2)
    }

    func configure (with viewModel:CategoryCollectionViewCellViewModel) {

        descriptionLabel.text = viewModel.title
        searchImageView.sd_setImage(with: viewModel.artworkURL)
        contentView.backgroundColor = colors.randomElement()
    }
}
