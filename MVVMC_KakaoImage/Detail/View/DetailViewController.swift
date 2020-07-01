//
//  DetailViewController.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/06/16.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var viewModel: DetailViewModel!
    
    
    // MARK: - View lifecycle
    
    deinit {
        print("\(#function)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func bindViewModel() {
        self.imageView.kf.setImage(with: URL(string: viewModel.model.image_url))
        self.label.text = viewModel.model.display_sitename
    }
    
    // MARK: - IBAction Function
    
}
