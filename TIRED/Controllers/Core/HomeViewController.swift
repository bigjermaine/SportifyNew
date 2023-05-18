//
//  HomeViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//


import UIKit


enum broswerSectionType {
    case newReleases(viewmodel:[NewreleasesCellViewModel])
    case FeaturedPlaylist(viewmodel:[FeaturedPlayListCellViewModel])
    case  recommendedTracks(viewmodel:[RecommendedPlaylistCellViewModel])
    var title:String {
        switch self {
            
        case .newReleases(viewmodel:_):
            return "New Releases"
        case .FeaturedPlaylist(viewmodel: _):
            return "FeaturedPlaylist"
        case .recommendedTracks(viewmodel:_):
            return "recommendedTracks"
        }
    }
    
}
class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    private var scollectionView:UICollectionView = UICollectionView(frame: .zero,collectionViewLayout:    UICollectionViewCompositionalLayout { sectionindex, _ -> NSCollectionLayoutSection? in
        return   HomeViewController.createSectionLayout(section: sectionindex)
    })
    
    private let spinner:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped  = true
        return spinner
    }()
    
    private var sections = [broswerSectionType]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        // Do any additional setup after loading the view.
        
        
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(image: UIImage(systemName: "gear"),
                        style: .done, target: self,
                        action: #selector(didTapSettings))
        fecthData()
        configureCollection()
        view.addSubview(spinner)
        
    }
    
    private  func configureCollection() {
        view.addSubview(scollectionView)
       
        scollectionView.register( NewReleasesCollectionViewCell.self, forCellWithReuseIdentifier:  NewReleasesCollectionViewCell.identifier)
        scollectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        scollectionView.register( RecomenededCollectionViewCell.self, forCellWithReuseIdentifier:  RecomenededCollectionViewCell.identifier)
        scollectionView.register( TitleHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier:  TitleHeaderCollectionView.identifier)
        scollectionView.delegate =  self
        scollectionView.dataSource = self
        scollectionView.backgroundColor = .systemBackground
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scollectionView.frame = view.bounds
    }
    
     
    private func fecthData() {
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases:       NewReleasesResponse?
        
        var FeaturedPlayList:  FeaturedPlayListsResponse?
        
        var recommendations:  RecommendationResponse?
        
        
        APICaller.shared.getfeaturedPlaylist { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    defer {
                        group.leave()
                    }
                    
                    FeaturedPlayList =    model
                case .failure(let error):
                    defer {
                        group.leave()
                    }
                    print(error.localizedDescription)
                }
            }
        }
        APICaller.shared.getNewRelaseses { result in
            switch result {
                
                
            case.success(let model):
                defer {
                    group.leave()
                }
                newReleases = model
                
            case .failure(let error):
                defer {
                    group.leave()
                }
                print(error.localizedDescription)
            }
        }
        
        
        
        APICaller.shared.getRecommendationsSeeds{ result in
            switch result {
                
            case .success(let data):
                
                let genres = data.genres
                var seeds = Set<String>()
                
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                
                APICaller.shared.getRecommendations(genres: seeds) { results in
                    switch results {
                    case .success(let data2):
                        defer {
                            group.leave()
                        }
                        recommendations = data2
                      //  print(data)
                    case .failure(let error):
                        defer {
                            group.leave()
                        }
                        print(error.localizedDescription)
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            guard let  releases = newReleases?.albums.items,
                  let  playlist = FeaturedPlayList?.playlists.items,
                  let  recommendations  = recommendations?.tracks
            else {
                return}
            self.configureModels(album:releases,track: recommendations,playlist: playlist)
            
        }
    }
    
    private var newAlbums:[Album] = []
    private var playlist: [Playlist]  = []
    private var track:[AudioTrack] = []
    
    
    private func configureModels(album:[Album],track:[AudioTrack],playlist:[Playlist]) {
        self.newAlbums = album
        self.playlist = playlist
        self.track = track
        
        
        
        sections.append(.newReleases(viewmodel: album.compactMap({
            
            return  NewreleasesCellViewModel(name: $0.name, artWorkUrl: URL(string: $0.images.first?.url ?? ""), numberoftrcaks: $0.total_tracks, artistName: $0.artists.first?.name ?? "")
                })))
        sections.append(.FeaturedPlaylist(viewmodel:playlist .compactMap({
            return FeaturedPlayListCellViewModel(name: $0.name, artworkUrl: URL(string: $0.images.first?.url ?? ""), creatorName: $0.owner.display_name )
            
            
        })))
        sections.append(.recommendedTracks(viewmodel: track.compactMap({
            return RecommendedPlaylistCellViewModel(artistName: $0.artists.first?.name ?? "", artworkUrl: URL(string: $0.album?.images.first?.url ?? ""), name: $0.name)
        })
        ))
        scollectionView.reloadData()
    }
    
    @objc func  didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        HapticManager.shared.vibrateForSelection()
        let section = sections[indexPath.section]
        
        switch section {case .newReleases(viewmodel:_):
            let album = newAlbums[indexPath.row]
            let vc  = AlbumViewUIViewControllerl(album: album)
            vc.title = album.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .FeaturedPlaylist(viewmodel: _):
            let playlist = playlist[indexPath.row]
            let vc  = PlaylistViewController(playlist:  playlist)
            vc.title = playlist.name
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
            
        case .recommendedTracks(viewmodel: _):
            let track = track[indexPath.row]
            PlaybackPresenter.shared.startplayback(from: self, track:  track )
            print("")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
            
        case .newReleases(viewmodel: let viewmodel):
           return viewmodel.count
        case .FeaturedPlaylist(viewmodel: let viewmodel):
            return viewmodel.count
        case .recommendedTracks(viewmodel: let viewmodel):
            return viewmodel.count
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:  TitleHeaderCollectionView.identifier, for: indexPath) as?  TitleHeaderCollectionView
                        ,kind == UICollectionView.elementKindSectionHeader else {
                    return UICollectionReusableView()
                }
       let section = indexPath.section
        let title = sections[section].title
        header.configure(with: title)
        return header
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            
        case .newReleases(viewmodel: let viewmodel):
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleasesCollectionViewCell.identifier, for: indexPath) as? NewReleasesCollectionViewCell else  {  return UICollectionViewCell()}
            cell.configure(with: viewmodel[indexPath.row])
           
            return cell
        case .FeaturedPlaylist(viewmodel: let viewmodel):
            guard    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath)
            as? FeaturedPlaylistCollectionViewCell else  {return UICollectionViewCell()}
            cell.configure(with:  viewmodel[indexPath.row])
           
            return cell
            
        case .recommendedTracks(viewmodel: let viewmodel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomenededCollectionViewCell.identifier, for: indexPath)as? RecomenededCollectionViewCell else  {  return UICollectionViewCell()}
            cell.configure(with:  viewmodel[indexPath.row])
            return cell
        }
}
    private static  func createSectionLayout(section:Int) -> NSCollectionLayoutSection {
        
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment:.top)
        
    
        ]
        switch section {
        case 0 :
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
            //group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250)), subitem: item,count: 3)
            
            
            //group
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(250)), subitems:[group])
            
            
            
            //section
            let section = NSCollectionLayoutSection(group: group1)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1:
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
          
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300)), subitems:[item,item])
            
            
           
            //group
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4), heightDimension: .absolute(300)), subitems:[group])
            
            
            
            //section
            let section = NSCollectionLayoutSection(group: group1)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        case 2:
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
            //group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200)), subitem: item,count: 5)
            
            
            
            
            //section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        default:
            
            //item
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1.0)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
            //group
            let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(400)), subitem: item,count: 3)
            
            
            //group
            let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(400)), subitems:[group])
            
            
            
            //section
            let section = NSCollectionLayoutSection(group: group1)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
    
  
}

