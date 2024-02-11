//
//  SplashViewController.swift
//  MarvelApp
//
//  Created by Omayma Marouf on 11/02/2024.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        image.loadGif(name: "splash")
        start()
    }
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
            let vc = AppStoryboard.Home.viewController(viewControllerClass: HomeViewController.self)
            let vcWithNavigation = UINavigationController(rootViewController: vc)
            keyWindow?.rootViewController = vcWithNavigation
        }
    }
}
