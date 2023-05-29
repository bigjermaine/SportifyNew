//
//  PlayBackPresenter.swift
//  TIRED
//
//  Created by Apple on 14/05/2023.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName:String? {get}
    var sutitle:String?  {get}
    var imageUrl:URL? {get}
    var playerDuration:String {get}
    var playerCurrent:String {get}
}
final class PlaybackPresenter: PlayerViewControllerDelegate {
  
    var index:Int = 0
    var playervc:PlayerViewController?
    static let shared = PlaybackPresenter()
    private var track:AudioTrack?
    private var tracks = [AudioTrack]()
    var player:AVPlayer?
    var playerQueue:AVQueuePlayer?
    var currentTracks:AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }else if let player = self.playerQueue, !tracks.isEmpty {
               return tracks[index]
        }
      
      return nil
    }
   func startplayback(from viewcontrolller:UIViewController,track:AudioTrack) {
   
       guard let url  = URL(string: track.preview_url ?? "") else {return }
       
       player = AVPlayer(url: url)
       player?.volume = 0.5
       self.tracks = []
       self.track = track
     
        let vc =  PlayerViewController()
         vc.title = track.name
       vc.dataSource = self
       vc.delegate = self
       viewcontrolller.present(UINavigationController(rootViewController: vc),animated: true,completion: { [weak self ] in
           self?.player?.play()
       }
 
        )
       self.playervc = vc
       
    }
   func startplaybacks(from viewcontrolller:UIViewController,track:[AudioTrack]) {
       self.tracks = track
       self.track = nil

    
    
       self.playerQueue = AVQueuePlayer(items:tracks.compactMap ({
           guard let url = URL(string: $0.preview_url ?? ""  ) else {
               return nil
           }
         return  AVPlayerItem(url: url)
       }))
       self.playerQueue?.play()
       
       
       
        let vc =  PlayerViewController()
        vc.dataSource = self
        vc.title = track.first?.album?.name
        viewcontrolller.present(UINavigationController(rootViewController: vc),animated: true,completion: nil)
       
        self.playervc = vc
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if  player.timeControlStatus == .paused{
                player.play()
            }
        }else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }else if  player.timeControlStatus == .paused{
                player.play()
            }
        }
    }
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        }else if let player = playerQueue?.items().first {
            index += 1
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [player])
            playervc?.update()
            playerQueue?.play()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            player?.pause()
            player?.play()
        }else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
            index += 1
            playervc?.update()
        }
    }
}

extension PlaybackPresenter:PlayerDataSource {
    var songName: String? {
        return currentTracks?.name
    }
    
    var sutitle: String? {
        return currentTracks?.artists.first?.name
    }
    
    var imageUrl: URL? {
        return URL(string: currentTracks?.album?.images.first?.url ?? "" )
    }
    
    
    var playerDuration: String
    {
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: track?.preview_url ?? "")!)
        player = AVPlayer(playerItem: playerItem)
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
       return stringFromTimeInterval(interval: seconds)
    }
    
    var  playerCurrent:String {
        let playerItem:AVPlayerItem = AVPlayerItem(url: URL(string: track?.preview_url ?? "")!)
        player = AVPlayer(playerItem: playerItem)
        let duration1 : CMTime = playerItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        return    stringFromTimeInterval(interval: seconds1)
        
        
    }
    
    func getDurationInSeconds() -> Double {
            let playerItem: AVPlayerItem = AVPlayerItem(url: URL(string: track?.preview_url ?? "")!)
            let duration: CMTime = playerItem.asset.duration
            let seconds: Double = CMTimeGetSeconds(duration)
            return seconds
        }
    
}

func stringFromTimeInterval(interval: TimeInterval) -> String {
    
    let interval = Int(interval)
    let seconds = interval % 60
    let minutes = (interval / 60) % 60
    let hours = (interval / 3600)
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}
