//
//  ViewController.swift
//  WebScrapping
//
//  Created by Alex Lopez on 05/11/2018.
//  Copyright © 2018 Cristian Lopez. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UICollectionViewController {
    
    let urlName = "https://www.apple.com/itunes/charts/songs/"
    
    var factory : SongsFactory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadItemsInCollectionView), name: NSNotification.Name("SongsUpdated"), object: nil)
        
        factory = SongsFactory(songsUrl: urlName)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return factory.songs.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongCell", for: indexPath) as! SongCell
        cell.labelSong.text = factory.songs[indexPath.row].title
        cell.labelAuthor.text = factory.songs[indexPath.row].authorName
        cell.imageViewSong.downloadedFrom(link: factory.songs[indexPath.row].imgUrl)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = URL(string: factory.songs[indexPath.row].itunesUrl) {
            UIApplication.shared.open(url, options: [:]) { (success) in
                
            }
        }
    }
    
    @objc func reloadItemsInCollectionView() {
        self.collectionView.reloadData()
    }
    
}

