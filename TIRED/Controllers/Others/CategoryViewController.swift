//
//  CategoryViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//


import  UIKit

class CategogryViewController: UIViewController {
    
    private let collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection?   in
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 1.0, bottom: 1.0, trailing: 1.0)
      
       
        //group
        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250)), subitem:item,count:2)
        
       
        
        
        
        //section
        let section = NSCollectionLayoutSection(group: group1)
   
        return section
    }))
    
    let category:Category
    
    init(category:Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var playlists = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeaturedPlaylistCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier)
        APICaller.shared.getCategoriesPlaylist(category: category) { result in
            DispatchQueue.main.async { [weak self] in
                
                switch result {
                    
                case .success(let model):
                    self?.playlists = model
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension CategogryViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        print(playlists.count)
        return playlists.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier, for: indexPath)
                as? FeaturedPlaylistCollectionViewCell else {
           return UICollectionViewCell()
       }
        let playlst = playlists[indexPath.row]
        cell.configure(with: FeaturedPlayListCellViewModel(name: playlst.name, artworkUrl: URL(string: playlst.images.first?.url ?? ""), creatorName: playlst.owner.display_name))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
