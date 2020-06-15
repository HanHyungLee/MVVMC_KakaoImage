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
    
    // searchBar
    private lazy var currentSearchText: String? = nil
    
    // paging
    private var currentPage: Int = 0
    private var isMoreLoading: Bool = false
    
    // rx
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - View lifecycle
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func bindViewModel() {
        
        viewModel.dataSource$
            .do(onNext: { models in
                print("models.count = \(models.count)")
//                self?.isMoreLoading = false
            })
            .drive(collectionView.rx.items) { collectionView, row, cellViewModel -> SearchItemCollectionViewCell in
                let indexPath: IndexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
                cell.configure(cellViewModel)
                cell.imageView.kf.setImage(with: URL(string: cellViewModel.image_url))
                
                cell.likeButton.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        self?.viewModel.saveSearch(indexPath: indexPath)
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reloadData()
    }
    
    // MARK: - Private Function
    
    private func setupUI() {
        self.title = "검색"
        
        self.collectionView.delegate = self
        
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.searchBar.autocapitalizationType = .none
        self.searchBar.keyboardType = .default
        self.searchBar.enablesReturnKeyAutomatically = true
        self.searchBar.keyboardAppearance = .dark
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

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.saveSearch(indexPath: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffSetY: CGFloat = scrollView.contentOffset.y
        if contentOffSetY >= (scrollView.contentSize.height - scrollView.bounds.height * 2) {
            guard currentSearchText != nil,
                currentPage > 0,
                !isMoreLoading else { return }
            self.isMoreLoading = true
            print("더보기!")
            let isEnd: Bool = viewModel.meta.is_end
            if !isEnd {
                self.currentPage += 1
                viewModel.fetchSearch(text: currentSearchText!, page: currentPage)
            }
        }
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.currentPage = 1
        
        if let text: String = searchBar.text {
            self.currentSearchText = text
            viewModel.fetchSearch(text: text, page: currentPage)
        }
        searchBar.resignFirstResponder()
    }
}
