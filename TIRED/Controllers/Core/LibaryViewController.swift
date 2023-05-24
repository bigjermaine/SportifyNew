//
//  LibaryViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit

class LibaryViewController: UIViewController {

    private let playListVC =  LibraryPlaylistViewController()
    private let albumsVc =   LibraryAlbumViewController()
    private let toggleView = LibraryToggleView()
    var playlists = [Playlist]()
  
    private let scrollView: UIScrollView  = {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        view.addSubview(toggleView )
        toggleView.Delegate = self
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        addChildren()
    }
    
    func configure() {
        APICaller.shared.getCurrentUserPlaylist {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success( let playlists):
                    self?.playlists = playlists
                    self?.update()
                case .failure( let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func update() {
        if playlists.isEmpty {
            
        }else {
            
        }
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 55, width: view.width, height: view.height - view.safeAreaInsets.top  - 55 - view.safeAreaInsets.bottom)
        toggleView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: 200, height: 55)
    }
    private func addChildren() {
        addChild(playListVC)
        scrollView.addSubview(playListVC.view)
        playListVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playListVC.didMove(toParent: self)
        
        
        addChild(playListVC)
        scrollView.addSubview(albumsVc.view)
        albumsVc.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVc.didMove(toParent: self)
    }
    
    private func updateBarButtons() {
        switch toggleView.State {
            
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    @objc private func didTapAdd() {
        playListVC.showCreatePlaylist()
    }
}
extension LibaryViewController:  UIScrollViewDelegate,LibraryToggleViewDelegate {
    func libraryToggleViewDidTapPlaylist(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        updateBarButtons()
    }
    
    func libraryToggleViewDidTapAlbum(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated:false)
        updateBarButtons() 
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100){
            toggleView.update(for: .album)
            updateBarButtons()
        }else {
          toggleView.update(for: .playlist)
            updateBarButtons()
        }
    }
   
}
