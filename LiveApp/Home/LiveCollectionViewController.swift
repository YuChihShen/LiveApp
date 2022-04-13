//
//  LiveCollectionViewController.swift
//  storyboard
//
//  Created by Class on 2022/3/30.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "LiveCell"

class LiveCollectionViewController: UICollectionViewController {
    var handle: AuthStateDidChangeListenerHandle?
    var roomResult = try? JSONDecoder().decode(Rooms.self, from: data)
    var user = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
            self.viewDidLoad()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = (collectionView.bounds.width - 8 * 3) / 2
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout?.estimatedItemSize = .zero
        if user == nil {
            flowLayout?.headerReferenceSize.height = 0
        }else{
            flowLayout?.headerReferenceSize.height = 50
        }
        self.collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    // Section 數量
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // Header 設定
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let  reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader",
                        withReuseIdentifier: "Head", for: indexPath) as! HeaderCollectionReusableView
        reusableview.userEmail = user?.email ?? ""
        reusableview.userNickName = user?.displayName ?? ""
        reusableview.update()
        return reusableview
    }
    // Cell 總數設定
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomResult?.stream_list.count ?? 0
    }
    // Cell 設定 -> 宣告 Cell 為自製 Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LiveCollectionViewCell
        cell.NickName.text = String(roomResult?.stream_list[indexPath.item].nickname ?? "")
        cell.peoPlecount = roomResult?.stream_list[indexPath.item].online_num ?? 0
        cell.urlString = roomResult?.stream_list[indexPath.item].head_photo ?? ""
        cell.tagsText = roomResult?.stream_list[indexPath.item].tags ?? ""
        cell.createTags()
        cell.update()
        return cell
    }
    // Cell 可被選取
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Cell 被選中的事件
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mediaView =  (self.storyboard?.instantiateViewController(withIdentifier: "MediaView"))!
        present(mediaView, animated: false)
    }
    
}
