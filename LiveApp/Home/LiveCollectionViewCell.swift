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
    
    var peoPlecount = 0
    var urlString = ""
    var tagsText = ""
    
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
    func createTags(){
        let cellWidth = self.layer.bounds.width
        var tagNum = 88
        var x = cellWidth * 0.05
        let y = cellWidth * 0.7
        let width = cellWidth * 0.4
        let height = cellWidth * 0.1
        
        if tagsText.count != 0  {
            let tags = tagsText.components(separatedBy: ",")
            for tag in tags {
                if let label = self.viewWithTag(tagNum) as? UILabel{
                    label.text = "#\(tag)"
                }else{
                    createLabel(tag: tagNum,text: tag, x: x, y: y, width: width, height: height)
                }
                x += (width + height / 3)
                tagNum += 1
            }
        }
    }
    func createLabel(tag:Int,text:String,x:Double,y:Double,width:Double,height:Double){
        let tagLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        tagLabel.text = "#\(text)"
        tagLabel.textColor = UIColor.white
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.secondaryLabel
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        tagLabel.tag = tag
        self.addSubview(tagLabel)
    }
    
    func update() {
        LiveView.image = UIImage(named: "paopao")
        LiveView.clipsToBounds = true
        LiveView.layer.cornerRadius = 20
        let PeopleCountText = NSMutableAttributedString()
        let PeopleCountAtt = NSTextAttachment()
        let PeopleCountNum = NumberFormatter.localizedString(
            from: NSNumber(value: peoPlecount), number: .decimal)
        PeopleCountAtt.image = UIImage(named:"iconPersonal")
        
        PeopleCountAtt.bounds = CGRect(x: (PeopleCount.bounds.width) / 40,
                                       y: (PeopleCount.bounds.width) / -60,
                                       width: (PeopleCount.bounds.width) / 5.5 ,
                                       height: (PeopleCount.bounds.width) / 5.5)
       
        PeopleCountText.append(NSAttributedString(attachment: PeopleCountAtt))
        PeopleCountText.append(NSAttributedString(string: " "))
        PeopleCountText.append(NSAttributedString(string: String(PeopleCountNum)))
        
        PeopleCount.attributedText = PeopleCountText
        PeopleCount.layer.cornerRadius = PeopleCount.bounds.midY
        fetchImage(url: URL(string: urlString)!) { image in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.LiveView.image = image
            }
        }
    }
    
}
