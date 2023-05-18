//
//  PlayerViewController.swift
//  TIRED
//
//  Created by Apple on 14/05/2023.
//

import UIKit
import SDWebImage

struct PlayerViewmodel {
    var title:String
    var Subtitle:String
}

protocol PlayerViewControllerDelegate:AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    
    
}
class PlayerViewController: UIViewController, PlayerControlsViewDelegate {
    weak var dataSource:PlayerDataSource?
    weak var delegate:PlayerViewControllerDelegate?
    private let PlayerViewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let controlView =  PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(PlayerViewImageView)
        view.addSubview(controlView)
        controlView.delegate = self
       
        configure()
    }
    
    func update() {
        configure()
    }
    func   configure() {
        PlayerViewImageView.sd_setImage(with: dataSource?.imageUrl)
        controlView.configure(viewmodel: PlayerViewmodel(title: dataSource?.songName ?? "",
                                                         Subtitle: dataSource?.sutitle ?? ""))
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        PlayerViewImageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height:  view.width)
        controlView.frame = CGRect(x: 10, y:  PlayerViewImageView.bottom+10, width: view.width-20, height:400)
    }
    
    private func configureBarButton() {
        navigationItem.leftBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShare() {
       // dismiss(animated: true)
    }
    func PlayerControlsViewDidTapForward(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()
    }
    
    func PlayerControlsViewDidTapPlay(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()
    }
    
    func PlayerControlsViewDidTapBackward(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()
    }
}
