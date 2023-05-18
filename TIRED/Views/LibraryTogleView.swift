//
//  LiabryTogleView.swift
//  TIRED
//
//  Created by Apple on 17/05/2023.
//


import UIKit



protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylist(_ toggleView:LibraryToggleView)
    func libraryToggleViewDidTapAlbum(_ toggleView:LibraryToggleView)
}
class LibraryToggleView:UIView{
    
    enum state {
        case playlist
        case album
    }
    
    var State:state = .playlist
    
    weak var Delegate:LibraryToggleViewDelegate?
    private let playListButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("Playlists", for: .normal)
        return button
    }()
    private let libraryListButton:UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.setTitle("library", for: .normal)
        return button
    }()
    
    private let indicatorView: UIView =  {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        addSubview(playListButton)
        addSubview(libraryListButton)
        addSubview(indicatorView)
        playListButton.addTarget(self, action: #selector(didTapPlaylists), for: .touchUpInside)
        libraryListButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    @objc private func didTapPlaylists() {
        State = .playlist
        Delegate?.libraryToggleViewDidTapPlaylist(self)
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        Delegate?.libraryToggleViewDidTapPlaylist(self)
    }
    @objc private func didTapAlbums() {
        State = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        Delegate?.libraryToggleViewDidTapAlbum(self)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playListButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        libraryListButton.frame = CGRect(x: playListButton.right, y: 0, width: 100, height: 50)
        indicatorView.frame = CGRect(x: 0, y:  playListButton.bottom, width: 100, height: 3)
        layoutIndicator()
    }
    func layoutIndicator() {
        
        switch State {
        case .album:
            indicatorView.frame = CGRect(x: 100, y:  playListButton.bottom, width: 100, height: 3)
        case.playlist:
            indicatorView.frame = CGRect(x: 0, y:  playListButton.bottom, width: 100, height: 3)
       
        }
    }
    func update(for state: state) {
        self.State = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
