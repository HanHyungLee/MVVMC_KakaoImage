//
//  SearchItemCollectionViewCell.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/28.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

final class SearchItemCollectionViewCell: UICollectionViewCell, ReusableView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    // MARK: - Private Function
    
    private func setupUI() {
        imageView.image = nil
        titleLabel.text = nil
        likeButton.isSelected = false
    }
    
    // MARK: - Public Function
    
    func configure(_ cellViewModel: SearchItemCellViewModelProtocol) {
        titleLabel.text = cellViewModel.display_sitename
        likeButton.isSelected = cellViewModel.isFavorite
    }
}
