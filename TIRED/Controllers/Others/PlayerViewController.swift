//
//  PlayerViewController.swift
//  TIRED
//
//  Created by Apple on 14/05/2023.
//

import UIKit
import SDWebImage
import AVFoundation
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
    private var songTotalLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private var SongCurrentLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 10,weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    private let controlView =  PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(PlayerViewImageView)
        view.addSubview(controlView)
        view.addSubview(songTotalLabel)
        view.addSubview(SongCurrentLabel)
        controlView.delegate = self
       
        configure()
        //Get the minimum Value
        controlView.volumeSliders.minimumValue = 0
        
        //Get the mxaimum Seconds
        controlView.volumeSliders.maximumValue = Float(PlaybackPresenter.shared.getDurationInSeconds())
        
        //Get the value of the volumeSilder
        controlView.volumeSliders.addTarget(self, action: #selector (PlayerViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
    
        PlaybackPresenter.shared.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if PlaybackPresenter.shared.player?.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds((PlaybackPresenter.shared.player?.currentTime())!);
                self.SongCurrentLabel.text = stringFromTimeInterval(interval: time)
                self.controlView.volumeSliders.value = Float ( time );
            }
        }
    }
    
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        PlaybackPresenter.shared.player?.seek(to: targetTime)
        
        if PlaybackPresenter.shared.player?.rate == 0
        {
            PlaybackPresenter.shared.player?.play()
        }
    }
    
    
    func update() {
        configure()
    }
    
    
    func  configure() {
        PlayerViewImageView.sd_setImage(with: dataSource?.imageUrl)
        songTotalLabel.text = dataSource?.playerDuration
        SongCurrentLabel.text = dataSource?.playerCurrent
        controlView.configure(viewmodel: PlayerViewmodel(title: dataSource?.songName ?? "",
                                                         Subtitle: dataSource?.sutitle ?? ""))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        PlayerViewImageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height:  view.width)
        controlView.frame = CGRect(x: 10, y:  PlayerViewImageView.bottom+10, width: view.width-20, height:400)
        songTotalLabel.frame  = CGRect(x: view.width - 120, y:  controlView.top, width: 100, height:100)
        SongCurrentLabel.frame  = CGRect(x: 20, y:  controlView.top, width: 100, height:100)
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
