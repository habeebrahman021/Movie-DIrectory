//
//  ViewController.swift
//  Movie DIrectory
//
//  Created by Habeeb Rahman on 30/05/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var movieListCollectionView: UICollectionView!
    var movieList: [Movie] = []
    var totalCount: Int?
    var page: Int = 1
    var numberOfItemsPerRow = 3
    let margin: CGFloat = 10
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib.init(nibName: "MovieListCollectionViewCell", bundle: nil)
        self.movieListCollectionView.register(cellNib, forCellWithReuseIdentifier: "MovieListCollectionViewCell")
        guard let collectionView = movieListCollectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        movieListCollectionView.delegate = self
        movieListCollectionView.dataSource = self
        loadJson()
    }
    
    func loadJson() {
        if let url = Bundle.main.url(forResource: "CONTENTLISTINGPAGE-PAGE\(page)", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(MovieList.self, from: data)
                self.totalCount = Int(jsonData.page.totalContentItems)
                self.movieList.append(contentsOf: jsonData.page.contentItems.movies)
                movieListCollectionView.reloadData()
            } catch {
                print("error:\(error)")
            }
        }
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCollectionViewCell", for: indexPath) as! MovieListCollectionViewCell
        cell.movieNameLabel.text = movieList[indexPath.row].name
        cell.movieImageView.image = UIImage(named: movieList[indexPath.row].posterImage.replacingOccurrences(of: ".jpg", with: ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3   //number of column you want
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        let height = Int(CGFloat(size) * 1.75)
        return CGSize(width: size, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let totalCount = totalCount else {
            return
        }
        if indexPath.row == movieList.count - 1 && movieList.count < totalCount {
            page += 1
            loadJson()
        }
    }
}

