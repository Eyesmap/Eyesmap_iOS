//
//  ReportMapViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/08/18.
//

import UIKit
import SnapKit
import NMapsMap

class ReportMapViewController: UIViewController {
    //MARK: - Properties
    
    private var targetLocation: CLLocation // 신고 위치
    private var targetMarker = NMFMarker()
    
    private let mapView = NMFMapView()
    private var locationSettingView = ReportLocationSettingView()
    
    
    //MARK: - Life Cycles
    init(location: CLLocation) {
        self.targetLocation = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    //MARK: - Set UI
    private func setUI() {
        view.backgroundColor = .white
        configureMapView()
        configureLocationSettingView()
        configureNavBar()
    }
    
    private func configureMapView() {
        let lat = targetLocation.coordinate.latitude
        let lng = targetLocation.coordinate.longitude
        print("lat: \(lat), lng: \(lng)")
        
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        mapView.zoomLevel = 17
        mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 230, right: 0)
        targetLocationCameraUpdate(lat: lat, lng: lng)
        
        targetMarker.position = NMGLatLng(lat: lat, lng: lng)
        targetMarker.iconImage = NMFOverlayImage(image: UIImage(named: "selectedMark")!)
        targetMarker.mapView = mapView
        targetMarker.anchor = CGPoint(x: 0.5, y: 1)
    }

    func configureLocationSettingView() {
        view.addSubview(locationSettingView)
        
        locationSettingView.snp.makeConstraints { make in
            make.height.equalTo(230)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        locationSettingView.locationSettingButton.addTarget(self, action: #selector(locationSettingButtonTap), for: .touchUpInside)
    }
    
    private func configureNavBar() {
        navigationItem.title = "신고하기"
        let xImage = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let deleteBtn = UIBarButtonItem(image: xImage, style: .done, target: self, action: #selector(deleteBtnTap))
        navigationItem.leftBarButtonItem = deleteBtn
        
        self.navigationController?.navigationBar.tintColor = .black
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

//MARK: - Camera
    func targetLocationCameraUpdate(lat: Double, lng: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng))
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 0.25
        mapView.moveCamera(cameraUpdate)
    }
    
//MARK: - Handler
    @objc func deleteBtnTap() {
        self.dismiss(animated: true)
    }
    
    @objc func locationSettingButtonTap() {
        guard let address = self.locationSettingView.locationLabel.text else { return }
        
        let reportVC = ReportViewController(position: targetLocation, address: address)
        self.navigationController?.pushViewController(reportVC, animated: true)
    }
}

//MARK: - NMFMapViewDelegate
extension ReportMapViewController: NMFMapViewDelegate {

    func mapViewIdle(_ mapView: NMFMapView) {
        updateMarkerPosition()
        let lat = targetLocation.coordinate.latitude
        let lng = targetLocation.coordinate.longitude
        
        GeoCodingNetworkManager.shared.reverseGeocode(latitude: lat, longitude: lng) { [weak self] location in
            self?.locationSettingView.locationLabel.text = location
        }
    }
    
    private func updateMarkerPosition() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let centerLatLng = self.mapView.cameraPosition.target
            self.targetMarker.position = centerLatLng
            self.targetLocation = CLLocation(latitude: centerLatLng.lat, longitude: centerLatLng.lng)
            print(centerLatLng)
        }
        
    }
}
