//
//  AlbumViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit



class AlbumViewUIViewControllerl:  UIViewController, PlaylistHeaderCollectionViewDelegate {
    
    private var tracks = [AudioTrack]()
    private var album:Album
    
    init(album:Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    private var viewModel = [RecommendedPlaylistCellViewModel]()
    
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title =  album.name
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(RecomenededCollectionViewCell.self, forCellWithReuseIdentifier: RecomenededCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        APICaller.shared.getAlbumDetails(for: album) {[weak self] result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let result):
                    
                    self?.tracks = result.tracks.items
            self?.viewModel = result.tracks.items.compactMap({
            return RecommendedPlaylistCellViewModel(artistName: $0.artists.first?.name ?? "", artworkUrl:URL(string:  $0.album?.images.first?.url ?? ""), name: $0.name)
                                        })
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
                
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    func PlaylistHeaderCollectionViewDelegateDidTap(_ header: PlaylistHeaderCollectionViewCell) {
        let tracksWithAlbum:[AudioTrack] = tracks.compactMap({
           var track  = $0
            track.album = self.album
            return track
            
        })
        
        
        PlaybackPresenter.shared.startplaybacks(from: self, track:tracksWithAlbum)
    }
    
}

extension   AlbumViewUIViewControllerl: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomenededCollectionViewCell.identifier, for: indexPath)  as? RecomenededCollectionViewCell  else {return UICollectionViewCell()}
        cell.backgroundColor = .red
        cell.configure(with: viewModel[indexPath.row])
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
       var track = tracks[indexPath.row]
        track.album = self.album
        PlaybackPresenter.shared.startplayback(from: self, track:   track)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionViewCell.identifier, for: indexPath) as?  PlaylistHeaderCollectionViewCell
                ,kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        header.configure(with: PlaylistHeaderViewModel(Name:album.name, description:"\(album.release_date)", OwnerName: album.artists.first?.name ?? "", artworkUrl: URL(string:album.images.first?.url ?? "")))
        header.delgate = self
        return header
    }
}

