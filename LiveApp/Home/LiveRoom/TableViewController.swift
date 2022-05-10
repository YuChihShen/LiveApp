//
//  TableViewController.swift
//  LiveApp
//
//  Created by yu-chih on 2022/5/5.
//

import UIKit

class TableViewController: UITableViewController {
    var tableCells = 0
    var row:IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureTableView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath)
        
//        let infoVC = self.storyboard!.instantiateViewController(withIdentifier: "TestView")
        let mediaView = self.storyboard?.instantiateViewController(withIdentifier: "MediaView") as! MediaAVViewController
        self.addChild(mediaView)
        cell.contentView.addSubview(mediaView.view)
        // infoview autolayout
        mediaView.view.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraint(NSLayoutConstraint(item: mediaView.view as Any, attribute: .leading, relatedBy: .equal, toItem: cell.contentView, attribute: .leading, multiplier: 1.0, constant: 0.0))
        cell.contentView.addConstraint(NSLayoutConstraint(item: mediaView.view as Any, attribute: .bottom, relatedBy: .equal, toItem: cell.contentView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        cell.contentView.addConstraint(NSLayoutConstraint(item: mediaView.view as Any, attribute: .trailing, relatedBy: .equal, toItem: cell.contentView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        cell.contentView.addConstraint(NSLayoutConstraint(item: mediaView.view as Any, attribute: .top, relatedBy: .equal, toItem: cell.contentView, attribute: .top, multiplier: 1.0, constant: 0.0))
        
        mediaView.playVideo(status: 1)
        print("visibleCells:\(tableView.visibleCells)")
        
        return cell
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //下一個畫面出現
        
    }
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
        //播放下一個畫面的影片
        //切斷上一個 ws 連接
        //開始下一個 ws 連接
        //重置上一個 ＆ 下一個畫面
        
    }
    // cell 全螢幕
    private func configureTableView() {
         tableView.rowHeight = UIScreen.main.bounds.height
         tableView.estimatedRowHeight = UIScreen.main.bounds.height
         tableView.separatorStyle = .none
         tableView.isPagingEnabled = true
         tableView.bounces = false
         tableView.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
         tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
         tableView.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
         tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
         tableView.contentInsetAdjustmentBehavior = .never
         tableView.delegate = self
         tableView.dataSource = self
     }
    
  

}
