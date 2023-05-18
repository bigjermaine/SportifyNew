//
//  RecomendedCollectionViewCell.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit


class RecomenededCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecomenededCollectionViewCell"
    
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
        PlaylistCoverImageView.image = nil
       
        
        PlaylistCoverImageView.frame = CGRect(x:5, y: 2, width:contentView.height-4, height:contentView.height-4)
    
        artistNameLabel.frame = CGRect(x:  Int(PlaylistCoverImageView.right)+10, y: 0, width: Int(contentView.width-PlaylistCoverImageView.right)-15 , height:
                                        Int(contentView.height)/2)
        PlaylistNameLabel.frame = CGRect(x: Int(  artistNameLabel.right)+10, y: Int(contentView.height)/2, width:Int(contentView.width) - Int(PlaylistCoverImageView.right) - 10, height:Int(contentView.height)/2)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        PlaylistNameLabel.text = ""
        artistNameLabel.text = ""
        PlaylistCoverImageView.image = nil
    }
    
    func configure(with viewmodel: RecommendedPlaylistCellViewModel) {
        PlaylistNameLabel.text = viewmodel.name
        artistNameLabel.text = viewmodel.artistName
        PlaylistCoverImageView.sd_setImage(with: viewmodel.artworkUrl,completed: nil)
        
         
    }
  }


