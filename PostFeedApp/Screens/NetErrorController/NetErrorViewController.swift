//
//  NetErrorViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 15.09.2023.
//

import UIKit

class NetErrorViewController: UIViewController {

    @IBOutlet weak var titleErrorLabel: UILabel!
    @IBOutlet weak var descriptionErrorLabel: UILabel!
    @IBOutlet weak var buttonTitle: UIButton!
    
    weak var delegate: NetErrorViewControllerDelegate?
    
    var descriptionError: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI() {
        titleErrorLabel.text = Constants.netErrorScreenTitle
        buttonTitle.setTitle(Constants.netErrorScreenButtonTitle, for: .normal)
        descriptionErrorLabel.text = descriptionError
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.loadNetworkData()
        navigationController?.popViewController(animated: false)
    }
}
