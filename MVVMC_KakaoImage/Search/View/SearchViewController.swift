//
//  SearchViewController.swift
//  MVVMC_KakaoImage
//
//  Created by Hanhyung Lee on 2020/05/25.
//  Copyright © 2020 Hanhyung Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: SearchViewModel!
//    {
//        didSet {
//            updateUI()
//        }
//    }
    
    // MARK: - View lifecycle
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func bindViewModel() {
        // search
        viewModel.fetchSearch(text: "apple", page: 1)
        
        
    }
    
    // MARK: - Private Function
    
    private func setupUI() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchItemCollectionViewCell", for: indexPath) as! SearchItemCollectionViewCell
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegate {
    
}
