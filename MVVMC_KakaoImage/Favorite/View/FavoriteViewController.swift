//
//  FavoriteViewController.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/08.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit
import RxSwift

final class FavoriteViewController: BaseViewController, ViewModelBindableType {
    
    var viewModel: FavoriteViewModel!
    
    private let disposeBag: DisposeBag = .init()
    
    // MARK: - View lifecycle
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.fetchFavorite()
    }
    
    private func setupUI() {
        self.title = "즐겨찾기"
        
        self.collectionView.delegate = self
    }
    
    func bindViewModel() {
        // dataSource
        self.viewModel.dataSource$
            .drive(self.collectionView.rx.items) { collectionView, row, cellViewModel in
                let indexPath: IndexPath = IndexPath(row: row, section: 0)
                let cell: SearchItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
                cell.configure(cellViewModel)
                cell.imageView.kf.setImage(with: URL(string: cellViewModel.image_url))
                
                // didSelect
                cell.likeButton.rx.tap
                    .throttle(.microseconds(500), scheduler: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.deleteFavorite(indexPath)
                    })
                    .disposed(by: cell.disposeBag)
                
                return cell
        }.disposed(by: disposeBag)
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

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.showDetail(indexPath)
    }
}
