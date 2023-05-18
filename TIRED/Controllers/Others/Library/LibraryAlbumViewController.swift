//
//  LibraryAlbumViewController.swift
//  TIRED
//
//  Created by Apple on 17/05/2023.
//

import UIKit

class LibraryAlbumViewController: UIViewController {

    
     var playlists = [Playlist]()
    private var noPlaylist = ActionLabelView()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(noPlaylist)
        noPlaylist.configure(with: ActionaLabelViewModel(text: "You dont have any playlists yet", actionTitle: "Create"))
       
        APICaller.shared.getCurrentUserPlaylist {[weak self] result in
            switch result {
                
            case .success(let playlists):
                self?.playlists = playlists
                self?.updateUi()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylist.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylist.center  = view.center
    }
    private func updateUi() {
       
    }
}
