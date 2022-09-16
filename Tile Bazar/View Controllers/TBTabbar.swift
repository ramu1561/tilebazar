//
//  TBTabbar.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit

class TBTabbar: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
            tabBarAppearance.backgroundImage = UIImage(named: "botton_tab_bg")
            tabBarAppearance.shadowImage = nil
            tabBarAppearance.shadowColor = nil
        }
        else{
            tabBar.shadowImage = UIImage()
            let image = UIImage(named: "botton_tab_bg")
            if let image = image {
                var resizeImage: UIImage?
                let size = CGSize(width: UIScreen.main.bounds.size.width, height: 49)
                UIGraphicsBeginImageContextWithOptions(size, false, 0)
                image.draw(in: CGRect(origin: CGPoint.zero, size: size))
                resizeImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                tabBar.backgroundImage = resizeImage?.withRenderingMode(.alwaysOriginal)
            }
            
        }
        
    }
}
