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
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
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
    
    @IBAction func onButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.imageView.removeFromSuperview()
        }
        else {
            self.view.addSubview(self.imageView)
        }
    }
}
