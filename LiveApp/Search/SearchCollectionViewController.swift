//
//  SearchCollectionViewController.swift
//  LiveApp
//
//  Created by Class on 2022/4/11.
//

import UIKit
import FirebaseAuth

private let reuseIdentifier = "SearchCell"

class SearchCollectionViewController: UICollectionViewController,UISearchBarDelegate,UICollectionViewDelegateFlowLayout {
    var handle: AuthStateDidChangeListenerHandle?
    var roomResult = try? JSONDecoder().decode(Rooms.self, from: data)
    var searchRoom: [Room]!
    var user = Auth.auth().currentUser
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            self.user = user
            self.collectionView.reloadData()
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
    }
    
    // MARK: UICollectionViewDataSource
    // Section 數量
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    // Header 設定
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let  searchReusableview = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader",
                        withReuseIdentifier: "SearchHead", for: indexPath) as! SearchHeaderCollectionReusableView
        if kind == "UICollectionElementKindSectionHeader" {
            
            searchReusableview.section = indexPath.section
            searchReusableview.update()
        }
        
        return searchReusableview
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 && searchRoom == nil{
            return CGSize(width: view.frame.width, height: 0)
        }else{
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    // Cell 總數設定
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cells: Int
        switch section{
        case 0 : cells = 0
        case 1 : cells = searchRoom?.count ?? 0
        default : cells = roomResult?.lightyear_list.count ?? 0
        }
        return cells
    }
    // Cell 設定 -> 宣告 Cell 為自製 Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCollectionViewCell
        switch indexPath.section{
        case 1:
//            cell.NickName.text = String(searchRoom[indexPath.item].nickname ?? "")
//            cell.peoPlecount = searchRoom[indexPath.item].online_num ?? 0
            cell.urlString = searchRoom[indexPath.item].head_photo
        case 2:
//            cell.NickName.text = String(roomResult?.lightyear_list[indexPath.item].nickname ?? "")
//            cell.peoPlecount = roomResult?.lightyear_list[indexPath.item].online_num ?? 0
            cell.urlString = roomResult?.lightyear_list[indexPath.item].head_photo ?? ""
        default:
            break
        }
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count ?? 0 > 0{
            searchRoom = []
            searchRoom = roomResult?.lightyear_list
                .filter({Room in Room.nickname.uppercased().contains(searchBar.text!)})
//                .filter({Room in Room.tags.uppercased().contains(searchBar.text!)})
        }else{
            searchRoom = nil
        }
        self.collectionView.reloadSections(IndexSet(1..<collectionView.numberOfSections))
    }
   
    
}
