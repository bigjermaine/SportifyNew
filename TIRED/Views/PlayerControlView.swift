//
//  PlayerControlView.swift
//  TIRED
//
//  Created by Apple on 14/05/2023.
//

import Foundation
import UIKit

protocol  PlayerControlsViewDelegate:AnyObject {
    func PlayerControlsViewDidTapForward(_ playerControlsView:PlayerControlsView)
    func PlayerControlsViewDidTapPlay(_ playerControlsView:PlayerControlsView)
    func PlayerControlsViewDidTapBackward(_ playerControlsView:PlayerControlsView)
    
}

final class PlayerControlsView:UIView {
    
    private var isplaying = true
    
    weak var delegate:PlayerControlsViewDelegate?
    private let volumeSliders: UISlider = {
        let slider  = UISlider()
        slider.value = 0.5
        
     return slider
    }()
    private var descriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize:20,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private var songLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .white
        label.font = .systemFont(ofSize:18,weight: .semibold)
        return label
    }()
    
    private let Backbutton:UIButton = {
       let button =  UIButton()
        button.tintColor = .white
        let image = UIImage(systemName: "backward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
  
        button.setImage(image, for: .normal)

  
        return button
    }()
    
    private let playAllbutton:UIButton = {
       let button =  UIButton()
        button.tintColor = .white
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
  
        button.setImage( image, for: .normal)
    
        return button
    }()
    
    private let forwardbutton:UIButton = {
       let button =  UIButton()
       button.tintColor = .white
        let image = UIImage(systemName: "forward.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(songLabel)
        addSubview(descriptionLabel)
        addSubview(forwardbutton)
        addSubview(Backbutton)
        addSubview(playAllbutton)
        addSubview(volumeSliders)
       
       
      clipsToBounds = true
        Backbutton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
        forwardbutton.addTarget(self, action: #selector( didTapFoward), for: .touchUpInside)
        playAllbutton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
    }
    
    @objc private func didTapFoward() {
        delegate?.PlayerControlsViewDidTapForward(self)
    }
    @objc private func didTapPlayPause() {
        self.isplaying = !isplaying
        delegate?.PlayerControlsViewDidTapPlay(self)
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
        let image1 = UIImage(systemName: "pause", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34,weight: .regular))
  
        playAllbutton.setImage(isplaying ?image1:image , for: .normal)
        
    }
    @objc private func didTapBackward() {
        delegate?.PlayerControlsViewDidTapBackward(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: width, height: 50)
        songLabel.frame = CGRect(x: 0, y: descriptionLabel.bottom+10, width: width, height: 50)
        volumeSliders.frame = CGRect(x: 10, y: songLabel.bottom+20, width: width - 20, height: 44)
        let buttonSize:CGFloat = 60
        playAllbutton.frame = CGRect(x: CGFloat(Int((width - buttonSize))/2), y:volumeSliders.bottom+30, width:buttonSize, height:buttonSize)
        Backbutton.frame = CGRect(x: CGFloat(playAllbutton.left - 80 -  buttonSize), y:volumeSliders.bottom+30, width:buttonSize, height:buttonSize)
        forwardbutton.frame = CGRect(x: CGFloat(playAllbutton.right+80), y:volumeSliders.bottom+30, width:buttonSize, height:buttonSize)
    
    }
  func   configure(viewmodel: PlayerViewmodel) {
        descriptionLabel.text = viewmodel.title
        songLabel.text = viewmodel.Subtitle
    }
}
