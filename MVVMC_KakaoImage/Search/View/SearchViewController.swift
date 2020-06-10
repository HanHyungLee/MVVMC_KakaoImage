//
//  SearchViewController.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class SearchViewController: BaseViewController, ViewModelBindableType {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var viewModel: SearchViewModel!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func bindViewModel() {
        
        viewModel.dataSource$
            .drive(self.collectionView.rx.items) { collectionView, row, cellViewModel -> SearchItemCollectionViewCell in
                // cell
                let indexPath: IndexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
//                let cellViewModel: SearchItemViewModel = .init(display_sitename: document.display_sitename, image_url: document.image_url)
                cell.configure(cellViewModel)
                cell.imageView.kf.setImage(with: URL(string: cellViewModel.image_url))
                return cell
        }.disposed(by: disposeBag)
    }
    
    // MARK: - Private Function
    
    private func setupUI() {
        self.navigationItem.title = "검색"
        
        self.collectionView.delegate = self
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.autocapitalizationType = .none
        self.searchBar.keyboardType = .default
        self.searchBar.enablesReturnKeyAutomatically = true
        self.searchBar.keyboardAppearance = .dark
    }
    
    private func updateUI() {
        self.collectionView.reloadData()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//extension SearchViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.viewModel.numberOfRows()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
//        let document = self.viewModel.documents[indexPath.row]
//        let cellViewModel = SearchItemViewModel(document: document)
//        cell.configure(cellViewModel)
//        cell.imageView.kf.setImage(with: URL(string: document.image_url))
//        return cell
//    }
//}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.saveSearch(indexPath: indexPath)
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked \(searchBar.text ?? "nil")")
        if let text: String = searchBar.text {
            self.viewModel.fetchSearch(text: text, page: 1)
        }
        searchBar.resignFirstResponder()
    }
}
