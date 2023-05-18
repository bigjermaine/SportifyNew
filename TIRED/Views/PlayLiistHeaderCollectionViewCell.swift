//
//  PlayLiistHeaderCollectionViewCell.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit

import UIKit
import SDWebImage



protocol PlaylistHeaderCollectionViewDelegate:AnyObject {
    func  PlaylistHeaderCollectionViewDelegateDidTap(_ header:PlaylistHeaderCollectionViewCell)
    
}
final class PlaylistHeaderCollectionViewCell: UICollectionViewCell {
    static let  identifier = "PlaylistHeaderCollectionViewCel"
    
    weak var delgate:PlaylistHeaderCollectionViewDelegate?
    private let PlaylistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var PlaylistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 22,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
  
    private var descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize:18,weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private var ownerLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize:18,weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private let playAllbutton:UIButton = {
       let button =  UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,weight: .regular))
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.layer.cornerRadius = 27.5
        button.layer.masksToBounds = true
        return button
    }()
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.addSubview(PlaylistCoverImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(PlaylistNameLabel)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(playAllbutton)
      
        contentView.clipsToBounds = true
        playAllbutton.addTarget(self, action: #selector(didtapplayall), for: .touchUpInside)
    }
    
    @objc private func didtapplayall() {
        delgate?.PlaylistHeaderCollectionViewDelegateDidTap(self)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagesize:CGFloat = height/1.8
        PlaylistCoverImageView.frame = CGRect(x: (width-imagesize)/2, y: 20, width: imagesize, height: imagesize)
        PlaylistNameLabel.frame = CGRect(x: 10, y: PlaylistCoverImageView.bottom, width: width-20, height: 44)
       descriptionLabel.frame = CGRect(x: 10, y: PlaylistNameLabel.bottom, width: width-20, height: 44)
      ownerLabel.frame = CGRect(x: 10, y:  descriptionLabel .bottom, width: width-20,   height: 44)
        playAllbutton.frame = CGRect(x: width-80, y:  descriptionLabel.bottom, width: 55, height: 55)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        PlaylistCoverImageView.image = nil
        PlaylistNameLabel.text = ""
        descriptionLabel.text = ""
        
    }
    
    func configure(with viewmodel:PlaylistHeaderViewModel ) {
        PlaylistNameLabel.text = viewmodel.Name
        descriptionLabel.text = viewmodel.description
        ownerLabel.text = viewmodel.OwnerName
        PlaylistCoverImageView.sd_setImage(with: viewmodel.artworkUrl)
        
    }


}
