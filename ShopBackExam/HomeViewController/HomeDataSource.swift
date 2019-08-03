//
//  HomeDataSource.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 2/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import Foundation
import UIKit
extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        //        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "HomeListTableCell", for: indexPath)
        
        return cell
    }
    
}
