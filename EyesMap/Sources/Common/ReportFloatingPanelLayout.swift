//
//  ReportFloatingPanel.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/11.
//

import UIKit
import FloatingPanel

class ReportFloatingPanelLayout: FloatingPanelLayout {

    init() {
        // 각 상태별 높이를 지정
        halfHeight = UIScreen.main.bounds.height * 0.6

        // 초기 상태를 full로 지정
        initialState = .half

        // 지원하는 상태를 지정
        supportedStates = [.half]

        // Position을 지정 (위에서 어떻게 뜰지 설정)
        position = .bottom

        // Anchors를 지정 (FloatingPanel의 상태별 앵커를 설정)
        anchors = [ .half: FloatingPanelLayoutAnchor(absoluteInset: UIScreen.main.bounds.height * 0.4, edge: .bottom, referenceGuide: .superview) ]
    }
    
    // 각 상태별 높이를 지정
    var halfHeight: CGFloat

    // 초기 상태를 full로 지정
    var initialState: FloatingPanelState

    // 지원하는 상태를 지정
    var supportedStates: Set<FloatingPanelState>

    var position: FloatingPanel.FloatingPanelPosition
    
    var anchors: [FloatingPanel.FloatingPanelState : FloatingPanel.FloatingPanelLayoutAnchoring]

}
