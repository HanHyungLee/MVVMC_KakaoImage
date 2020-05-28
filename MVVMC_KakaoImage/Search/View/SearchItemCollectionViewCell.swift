//
//  SearchItemCollectionViewCell.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/28.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

class SearchItemCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(_ searchItemCellViewModel: SearchItemCellViewModelProtocol) {
        // TODO: 이미지 캐싱 다운
        self.label.text = searchItemCellViewModel.display_sitename
    }
}
