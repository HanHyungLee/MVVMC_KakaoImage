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
        self.collectionView.delegate = self
    }
    
    func bindViewModel() {
        self.viewModel.didChange$
            .drive(self.collectionView.rx.items) { collectionView, row, model in
                let indexPath: IndexPath = IndexPath(row: row, section: 0)
                let cell: SearchItemCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCollectionViewCell.reuseIdentifier, for: indexPath) as! SearchItemCollectionViewCell
                
                let display_sitename: String = model.display_sitename ?? ""
                let image_url: String = model.image_url ?? ""
                let cellViewModel: SearchItemViewModel = .init(display_sitename: display_sitename, image_url: image_url)
                cell.configure(cellViewModel)
                cell.imageView.kf.setImage(with: URL(string: image_url))
                
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
    
}
