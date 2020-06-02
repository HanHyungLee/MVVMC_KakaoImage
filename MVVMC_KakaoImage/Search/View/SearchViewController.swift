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

final class SearchViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: SearchViewModel!
//    {
//        didSet {
//            updateUI()
//        }
//    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func bindViewModel() {
        viewModel.didChange$
            .share()
            .subscribe(onNext: { [weak self] model in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private Function
    
    private func setupUI() {
        self.navigationItem.title = "검색"
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: SearchItemCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier)
        
        let spacing: CGFloat = 5.0
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.bounds.width / 2 - spacing * 3, height: 180.0)
        layout.sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
//        layout.minimumLineSpacing = 5.0
//        layout.minimumInteritemSpacing = 5.0
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
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

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
        let document = self.viewModel.documents[indexPath.row]
        let cellViewModel = SearchItemViewModel(document: document)
        cell.configure(cellViewModel)
        cell.imageView.kf.setImage(with: URL(string: document.image_url))
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
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
