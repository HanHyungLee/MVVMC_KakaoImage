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
//    private var currentPage: Int = 0
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
            .do(afterNext: { [weak self] models in
                guard let self = self else { return }
                print("afterNext.count = \(models.count)")
                guard models.count > 0 else { return }
                self.isMoreLoading = self.viewModel.isEndPage
                })
            .drive(collectionView.rx.items) { collectionView, row, cellViewModel -> SearchItemCollectionViewCell in
                let indexPath: IndexPath = IndexPath(row: row, section: 0)
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
                cell.configure(cellViewModel)
                cell.imageView.kf.setImage(with: URL(string: cellViewModel.image_url))
                
                // likeButton
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
            let currentPage: Int = viewModel.currentPage
            guard currentSearchText != nil,
                currentPage > 0,
                !isMoreLoading else { return }
            self.isMoreLoading = true
            print("더보기!")
            let isEnd: Bool = viewModel.meta.is_end
            if !isEnd {
                viewModel.fetchSearch(text: currentSearchText!, page: currentPage + 1)
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
        if let text: String = searchBar.text {
            self.currentSearchText = text
            viewModel.fetchSearch(text: text, page: 1)
        }
        searchBar.resignFirstResponder()
    }
}
