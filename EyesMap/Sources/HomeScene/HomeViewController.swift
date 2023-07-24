//
//  ViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/07/24.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

//MARK: - Properties
    private let mapView = MKMapView()
    
    private let locationManager = LocationHandler.shared.locationManager
    
//MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        setUIandConstraints()
        
        
    }

//MARK: - set UI
    func setUIandConstraints() {
        configureMapView()
    }
    
    // MapView Setting
    func configureMapView() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.mapView.showsUserLocation = true
        self.mapView.setUserTrackingMode(.follow, animated: true)
        self.mapView.delegate = self
    }
    
    
}

//MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    

}

extension HomeViewController: CLLocationManagerDelegate {
    // 위치 권한 설정
    func enableLocationServices() {
        locationManager?.delegate = self
         
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            print("DEBUG: 거절 됨")
            showAlertForLocationAuthorization()
        case .notDetermined:
            print("DEBUG: 위치 정보 없을 때 권한 정보 물음")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            print("DEBUG: 항상 위치정보 권한 사용중")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: 앱을 사용할 때만 위치정보 권한 사용중")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
    }
    
    // 거부 시 재 실행하면 권한 요청을 위한 설정으로 이동
    func showAlertForLocationAuthorization() {
        let alertController = UIAlertController(
            title: "위치 권한 설정",
            message: "이 앱에서 위치 정보를 사용하려면 위치 권한이 필요합니다. 설정에서 위치 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            // 위치 권한 설정 화면으로 이동
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}
