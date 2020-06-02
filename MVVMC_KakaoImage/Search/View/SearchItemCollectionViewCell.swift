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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ searchItemCellViewModel: SearchItemCellViewModelProtocol) {
        self.titleLabel.text = searchItemCellViewModel.display_sitename
    }
}
