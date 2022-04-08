//
//  LiveCollectionViewCell.swift
//  storyboard
//
//  Created by Class on 2022/3/30.
//

import UIKit

class LiveCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var LiveView: UIImageView!
    @IBOutlet weak var PeopleCount: UILabel!
    @IBOutlet weak var NickName: UILabel!
    
    var roomResult = try? JSONDecoder().decode(Rooms.self, from: data)
    var listNum : Int = -1
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
                
            } else {
                completion(nil)
            }
        }.resume()
    }
    
    
    func update() {
        LiveView.image = UIImage(named: "paopao")
        LiveView.clipsToBounds = true
        LiveView.layer.cornerRadius = 20
        let PeopleCountText = NSMutableAttributedString()
        let PeopleCountAtt = NSTextAttachment()
        let PeopleCountNum = NumberFormatter.localizedString(
            from: NSNumber(value: roomResult?.stream_list[listNum].online_num ?? 0), number: .decimal)
        PeopleCountAtt.image = UIImage(named:"iconPersonal")
        
        PeopleCountAtt.bounds = CGRect(x: (PeopleCount.bounds.width) / 40,
                                       y: (PeopleCount.bounds.width) / -60,
                                       width: (PeopleCount.bounds.width) / 5.5 ,
                                       height: (PeopleCount.bounds.width) / 5.5)
       
        PeopleCountText.append(NSAttributedString(attachment: PeopleCountAtt))
        PeopleCountText.append(NSAttributedString(string: " "))
        PeopleCountText.append(NSAttributedString(string:
                                                    String(PeopleCountNum)))
        
        PeopleCount.attributedText = PeopleCountText
        PeopleCount.layer.cornerRadius = PeopleCount.bounds.height / 2
       
        NickName.text = String(roomResult?.stream_list[listNum].nickname ?? "")
        fetchImage(url: URL(string: roomResult?.stream_list[listNum].head_photo ?? "")!) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.LiveView.image = image
            }
        }
    }
}
