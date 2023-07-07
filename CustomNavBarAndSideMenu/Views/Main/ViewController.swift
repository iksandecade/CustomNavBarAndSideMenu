//
//  ViewController.swift
//  CustomNavBarAndSideMenu
//
//  Created by MCOMM00042 on 06/07/23.
//

import UIKit

class ViewController: BaseController {
    @IBOutlet weak var mainTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopBar(title: "CustomBar")
        mainTableview.dataSource = self
        mainTableview.delegate = self
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        return cell
    }
    
    
    //MARK: When tableview/scrollview scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateTopBar(offsetY: scrollView.contentOffset.y)
    }
    
    
    //MARK: When tableview/scrollview ended scrolling
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //MARK: when ended scrolling, check if searchTextField height > 25% then searchTextField normal height else hide textfield
        //MARK: if BigTitleLabel > 25% then BigTitleLabel normal height else hide bigTitleLabel and subTopBar
        updateTopBar(offsetY: scrollView.contentOffset.y, isEndedDragging: true)
    }
}

