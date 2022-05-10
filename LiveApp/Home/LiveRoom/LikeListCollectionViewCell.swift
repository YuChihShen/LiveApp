//
//  LikeListCollectionViewCell.swift
//  LiveApp
//
//  Created by yu-chih on 2022/5/5.
//

import UIKit

class LikeListCollectionViewCell: UICollectionViewCell {
    var task:URLSessionTask?
    var nickname = ""
    var streamerID = 0
    @IBOutlet weak var likeListImage: UIImageView!
    func update(url:String) {
        likeListImage.image = UIImage(named: "paopao")
        fetchImage(url: URL(string: url)!) { image in
            guard let image = image else { return }
            DispatchQueue.main.async { [self] in
                self.likeListImage.image = image
                self.likeListImage.clipsToBounds = true
                self.likeListImage.layer.cornerRadius = self.likeListImage.bounds.midY
            }
        }
    }
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
            self.task = nil
        }
        task?.resume()
    }
}
