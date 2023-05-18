//
//  HomeVC.swift
//  OnePercent
//
//  Created by Jhean Carlos Pineros Diaz on 28/04/23.
//

import UIKit
import Combine

class HomeVC: UIViewController {

    var homeViewModel: HomeViewModel!
    private var cancellable: AnyCancellable?

    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.homeViewModel = viewModel

        bindView()
    }

    func bindView() {
        cancellable = homeViewModel.$goals.sink { [weak self] goals in
            print("the goals are \(goals)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }



}
