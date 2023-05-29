//
//  PlaylistViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit

class PlaylistViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PlaylistHeaderCollectionViewDelegate {
    
    
     public  var isOwner = false 
    private let playlist:Playlist
    private var tracks = [AudioTrack]()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_ ->
        NSCollectionLayoutSection? in
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
        //group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), subitem: item,count:1)
        
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize:NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension:  .fractionalWidth(1.0)) , elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }))
    init(playlist:Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var viewModel = [RecommendedPlaylistCellViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(collectionView)
        collectionView.register(RecomenededCollectionViewCell.self, forCellWithReuseIdentifier: RecomenededCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getplaylistDetails(for: playlist)  {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let result):
                    self?.tracks = result.tracks.items.compactMap({ $0.track
                    })
                   
                    self?.viewModel = result.tracks.items.compactMap({
                        return RecommendedPlaylistCellViewModel(artistName: $0.track.artists.first?.name ?? "", artworkUrl:URL(string:  $0.track.album?.images.first?.url ?? ""), name: $0.track.name)
                    })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didlongpress))
        collectionView.addGestureRecognizer(gesture)
        
    }
    @objc func didlongpress(_ gesture:UITapGestureRecognizer) {
        guard gesture.state == .began else {return}
        let touchpoint  = gesture.location(in: collectionView)
        guard let indexpath = collectionView.indexPathForItem(at: touchpoint) else {return}
        let trackToDelete = tracks[indexpath.row]
        let actionsheet = UIAlertController(title: "Remove\(trackToDelete.name)", message: "would like to remove this from playlist", preferredStyle: .actionSheet)
        actionsheet.addAction(UIAlertAction(title: "cancel", style: .cancel))
        actionsheet.addAction(UIAlertAction(title: "Rekove", style: .destructive,handler: {[weak self] _ in
            guard let strongSelf = self else {return}
            APICaller.shared.removeTrack(track: trackToDelete, playlist: strongSelf.playlist  ) { [weak self ]done in
                if done {
                    self?.tracks.remove(at: indexpath.row)
                    self?.viewModel.remove(at: indexpath.row)
                    self?.collectionView.reloadData()
                }
            }
        }))
        present(actionsheet, animated: true)
    }
    
    @objc func didTapShare() {
        print(playlist.external_urls)
        guard let url = URL(string: playlist.external_urls["spotify"] ?? "") else {return}
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    func PlaylistHeaderCollectionViewDelegateDidTap(_ header: PlaylistHeaderCollectionViewCell) {
        PlaybackPresenter.shared.startplaybacks(from: self, track: tracks)
    }
    
}


extension PlaylistViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomenededCollectionViewCell.identifier, for: indexPath)  as? RecomenededCollectionViewCell  else {return UICollectionViewCell()}
       // cell.backgroundColor = .red
        cell.configure(with: viewModel[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startplayback(from: self, track: track)
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionViewCell.identifier, for: indexPath) as?  PlaylistHeaderCollectionViewCell
                ,kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        header.configure(with: PlaylistHeaderViewModel(Name: playlist.name, description: playlist.description, OwnerName: playlist.owner.display_name, artworkUrl: URL(string:playlist.images.first?.url ?? "")))
        header.delgate = self
        return header
    }
}
