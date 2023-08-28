//
//  HallOfFameViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/28.
//

import UIKit
import SnapKit

class HallOfFameViewController: UIViewController {
    // MARK: - Properties
    
    
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    
    // MARK: - Set UI
    private func setUI() {
        view.setGradient(color1: .fametopColor, color2: .fameBottomColor)
    }
    
    // MARK: - Functions
    
    
}
