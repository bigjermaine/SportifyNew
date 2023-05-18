//
//  NewReleasesCollectionViewCell.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit
import SDWebImage

class NewReleasesCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "NewReleasesCollectionViewCell"
    
    
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private var albumNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 16,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10,weight: .light)
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
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(albumNameLabel)
        contentView.clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        albumCoverImageView.image = nil
        let imagesize:CGFloat = contentView.height-10
        
        albumCoverImageView.frame = CGRect(x: 5, y: 5, width: imagesize, height: imagesize)
        numberOfTracksLabel.frame = CGRect(x: Int(albumCoverImageView.width)+10, y: Int(albumCoverImageView.bottom)-40, width: Int(numberOfTracksLabel.width), height: 50)
        artistNameLabel.frame = CGRect(x: Int(albumCoverImageView.width)+10, y: 5, width: Int( artistNameLabel.bottom)+70, height:min(80,Int(artistNameLabel.height)+10))
        albumNameLabel.frame = CGRect(x: Int(  artistNameLabel.right)+10, y: 5, width:Int( albumNameLabel.width)+70, height:min(80,Int(artistNameLabel.height)))
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = ""
        artistNameLabel.text = ""
        numberOfTracksLabel.text = ""
        albumCoverImageView.image = nil
    }
    
    func configure(with viewmodel:NewreleasesCellViewModel) {
        albumNameLabel.text = viewmodel.name
        artistNameLabel.text = viewmodel.artistName
        numberOfTracksLabel.text = "tracks:\(viewmodel.numberoftrcaks)"
        albumCoverImageView.sd_setImage(with: viewmodel.artWorkUrl,completed: nil)
        
         
    }
}
