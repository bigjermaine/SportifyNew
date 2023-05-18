//
//  FeaturedPlayListCollectionViewCell.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//


import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let  identifier = "FeaturedPlaylistCollectionViewCell"
    

    private let PlaylistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var PlaylistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
  
    private var artistNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize:12,weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(PlaylistCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(PlaylistNameLabel)
        contentView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        PlaylistNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        let imagesize:CGFloat = contentView.height/2
        
        PlaylistCoverImageView.frame = CGRect(x:contentView.width/4, y: contentView.height/3.0, width: imagesize, height: imagesize)
    
        artistNameLabel.frame = CGRect(x:Int(contentView.left)+2, y:  Int(PlaylistCoverImageView.top) - 45, width: Int (PlaylistCoverImageView.height) * 3/2 , height:Int(PlaylistCoverImageView.height) * 1/3)
        PlaylistNameLabel.frame = CGRect(x:Int(contentView.left)+2, y:  Int(PlaylistCoverImageView.top) - 30, width: Int (PlaylistCoverImageView.height) * 2/Int(1.2), height:Int(PlaylistCoverImageView.height) * 1/3)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        PlaylistNameLabel.text = ""
        artistNameLabel.text = ""
        PlaylistCoverImageView.image = nil
    }
    
    func configure(with viewmodel:FeaturedPlayListCellViewModel) {
        PlaylistNameLabel.text = viewmodel.name
        artistNameLabel.text = viewmodel.creatorName
        PlaylistCoverImageView.sd_setImage(with: viewmodel.artworkUrl,completed: nil)
        
         
    }
}
