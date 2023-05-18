//
//  SearchViewController.swift
//  TIRED
//
//  Created by Apple on 13/05/2023.
//

import UIKit
import SafariServices

class SerachViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate, SearchResultViewControllerDelegate{
    
    func didTapResult(_result: SearchResult) {
        switch _result {
                
            case .artist(model: let model):
            guard let model = URL(string: model.external_urls["spotify"] ?? "") else {return}
            let vc  = SFSafariViewController(url: model)
           present(vc, animated: true)
            
            case .album(model: let model):
                let vc = AlbumViewUIViewControllerl(album: model)
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
              
            case .track(model: let model): 
           
            PlaybackPresenter.shared.startplayback(from: self, track:model)
            case .playlist(model: let model):
                let vc = PlaylistViewController(playlist: model)
                vc.navigationItem.largeTitleDisplayMode = .never
                navigationController?.pushViewController(vc, animated: true)
               
            
        }
    }
    
    
    
    
    
   
    private var categories = [Category]()
    let searchController:UISearchController = {
        let results = SearchResultViewController()
        let vc = UISearchController(searchResultsController: results)
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _,_ ->
        NSCollectionLayoutSection? in
        //item
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        //group
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100)), subitem: item,count:2)
         //section
        let section = NSCollectionLayoutSection(group: group)
       
        return section
    }))
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater =  self
        searchController.searchBar.delegate = self
        view.addSubview(collectionView)
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
       collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        APICaller.shared.getAllCategories { [weak self ]results in
            DispatchQueue.main.async {
                switch results {

                case .success(let model):
                    self?.categories = model
                    self?.collectionView.reloadData()
                    print(model)
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultControllers = searchController.searchResultsController as? SearchResultViewController, let query = searchBar.text,!query.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        resultControllers.delegate = self
         APICaller.shared.search(with: query) { results in
            DispatchQueue.main.async {[weak self] in
                switch results {
                    
                case .success(let model):
                    print(model)
                    resultControllers.update(with: model)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        print(query)
    }
    func updateSearchResults(for searchController: UISearchController) {
       
    }
  
    
 }

extension  SerachViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else { return UICollectionViewCell()}

        let category = categories[indexPath.row]
        cell.configure(with:CategoryCollectionViewCellViewModel(title:  category.name, artworkURL: URL(string: category.icons.first?.url ?? "")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let category = categories[indexPath.row]
        let vc = CategogryViewController(category: category)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
