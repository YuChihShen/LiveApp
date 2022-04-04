//
//  LiveCollectionViewController.swift
//  storyboard
//
//  Created by Class on 2022/3/30.
//

import UIKit

private let reuseIdentifier = "LiveCell"

class LiveCollectionViewController: UICollectionViewController {
    
    var roomResult = try? JSONDecoder().decode(Rooms.self, from: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        let width = (collectionView.bounds.width - 6 * 3) / 2
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero

    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return roomResult?.stream_list.count ?? 0
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LiveCollectionViewCell
        cell.listNum = indexPath.item
        cell.update()

        return cell
        
    }

}
