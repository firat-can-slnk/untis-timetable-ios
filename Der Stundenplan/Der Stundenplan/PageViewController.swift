//
//  PageViewController.swift
//  Der Stundenplan
//
//  Created by Firat Sülünkü on 21.03.19.
//  Copyright © 2019 Firat Sülünkü. All rights reserved.
//

import Foundation
import UIKit
import Pageboy

class PageViewController: PageboyViewController, PageboyViewControllerDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
}
