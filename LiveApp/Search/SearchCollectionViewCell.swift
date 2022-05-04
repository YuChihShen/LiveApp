//
//  SearchCollectionViewCell.swift
//  LiveApp
//
//  Created by Class on 2022/4/11.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var LiveView: UIImageView!
    @IBOutlet weak var PeopleCount: UILabel!
    @IBOutlet weak var NickName: UILabel!
    @IBOutlet weak var RoomName: UILabel!
   
    var peoPlecount = 0
    var urlString = ""
    var tagsText = ""
    var task:URLSessionTask?
    var streamer_id = 0
    
    override func prepareForReuse() {
        task?.cancel()
        task = nil
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
    func createTags(){
        let cellWidth = self.layer.bounds.width
        var tagNum = 88
        var x = cellWidth * 0.08
        let y = cellWidth * 0.7
        var width = cellWidth * 0.4
        let height = cellWidth * 0.1
        
        if tagsText.count != 0  {
            let tags = tagsText.components(separatedBy: ",")
            DispatchQueue.main.async { [self] in
                for tag in tags {
                    if  self.viewWithTag(tagNum) != nil{
                        self.viewWithTag(tagNum)?.removeFromSuperview()
                        createLabel(tag: tagNum,text: tag, x: x, y: y, width: width, height: height)
                    }else{
                        createLabel(tag: tagNum,text: tag, x: x, y: y, width: width, height: height)
                    }
                    width = self.viewWithTag(tagNum)?.frame.width ?? width
                    x += width + cellWidth * 0.04
                    tagNum += 1
                    if self.viewWithTag(tagNum) != nil{
                        self.viewWithTag(tagNum)?.removeFromSuperview()
                    }
                }
            }
        }
    }
    func createLabel(tag:Int,text:String,x:Double,y:Double,width:Double,height:Double){
        let tagLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        tagLabel.text = " #\(text) "
        tagLabel.textColor = UIColor.white
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = .darkGray
        tagLabel.alpha = 0.68
        tagLabel.font = UIFont.systemFont(ofSize: 14)
        tagLabel.tag = tag
        let size = tagLabel.sizeThatFits(CGSize(width: width, height: height))
        tagLabel.frame.size = size
        tagLabel.clipsToBounds = true
        tagLabel.layer.cornerRadius = 3
        self.addSubview(tagLabel)
    }
    
    func update() {
        LiveView.image = UIImage(named: "paopao")
        LiveView.clipsToBounds = true
        LiveView.layer.cornerRadius = 20
        let imageSizeRef = self.frame.width / 2
        let PeopleCountText = NSMutableAttributedString()
        let PeopleCountAtt = NSTextAttachment()
        let PeopleCountNum = NumberFormatter.localizedString(
            from: NSNumber(value: peoPlecount), number: .decimal)
        PeopleCountAtt.image = UIImage(named:"iconPersonal")

        PeopleCountAtt.bounds = CGRect(x: imageSizeRef / 40,
                                       y: imageSizeRef / -30,
                                       width: imageSizeRef / 5.5 ,
                                       height: imageSizeRef / 5.5)
        

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
