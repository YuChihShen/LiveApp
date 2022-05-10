//
//  LikeListViewController.swift
//  LiveApp
//
//  Created by yu-chih on 2022/5/5.
//

import UIKit
import RxCocoa
import RxSwift

class LikeListViewController: UIViewController ,UICollectionViewDelegate,UICollectionViewDataSource{
    let firebaseSupport = FireBaseSupport()
    var items = 0
    var roomResult = try? JSONDecoder().decode(Rooms.self, from: data)
    var likeList: [Room] = []
    var documents:[String] = []
    @IBOutlet weak var collectionview: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = collectionview.collectionViewLayout as? UICollectionViewFlowLayout
        let width = collectionview.bounds.width / 5.5
        flowLayout?.itemSize = CGSize(width: width, height: width)
        flowLayout!.scrollDirection = .horizontal
        
        
        let presentingVC = self.presentingViewController as! ChatRoomViewController
        documents = presentingVC.likeList
        for streamerID in documents{
            likeList += (roomResult?.lightyear_list.filter({Room in String(Room.streamer_id).contains(streamerID)}))!
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likeList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LikeListCollectionViewCell
        let url = likeList[indexPath.item].head_photo
        cell.nickname = likeList[indexPath.item].nickname
        cell.streamerID = likeList[indexPath.item].streamer_id
        cell.update(url: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LikeListCollectionViewCell
        let image = cell.likeListImage.image
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let window = sceneDelegate?.window
        let mediaView = window?.rootViewController!.presentedViewController! as! MediaAVViewController
        mediaView.roomHostNickname = cell.nickname
        mediaView.roomHostPhoto = image!
        mediaView.streamer_id = cell.streamerID
        mediaView.isChatRoomExist = true
        mediaView.viewDidLoad()
        
        
    }

}
