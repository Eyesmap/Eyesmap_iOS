//
//  ViewController.swift
//  EyesMap
//
//  Created by 박현준 on 2023/07/24.
//

import UIKit
import SnapKit
import NMapsMap
import CoreLocation
import CoreMotion

class HomeViewController: UIViewController {

//MARK: - Properties
    private let locationManager = LocationHandler.shared.locationManager
    private var userLocation: CLLocation? // 현 위치
    private var userHeading: CLHeading? // 바라보는 방향
    private var complaints = [ComplaintModel]() // API 연결 민원들 추가 값
    
    private let mapView = NMFMapView()
    private lazy var locationOverlay = mapView.locationOverlay // 사용자 위치 표시
    
    private lazy var complaintCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 13
        cv.showsHorizontalScrollIndicator = false
        cv.allowsMultipleSelection = false
        cv.isPagingEnabled = false
        cv.decelerationRate = .fast
        cv.register(ComplaintCollectionViewCell.self, forCellWithReuseIdentifier: ComplaintCollectionViewCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
//MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        getPositions() // 서버연동 시
        setUIandConstraints()
        enableLocationServices()
    }

//MARK: - set UI
    func setUIandConstraints() {
        configureMapView()
        configureCollectionView()
    }
    
    // MapView Setting
    func configureMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentLocationCameraUpdate()
        drawMarking(positions: complaints)
    }
    
    func configureCollectionView() {
        view.addSubview(complaintCollectionView)
        
        complaintCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(400)
            make.bottom.equalToSuperview().inset(30)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // 현 위치 아이콘 & 카메라 업데이트
    func currentLocationCameraUpdate() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
        guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        
        locationOverlay.location = NMGLatLng(lat: currentUserLat, lng: currentUserlong)
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "image1")
        locationOverlay.iconWidth = 30
        locationOverlay.iconHeight = 30
        locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentUserLat, lng: currentUserlong))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
    
    // 마커 표시 & 이벤트 처리
    func drawMarking(positions: [ComplaintModel]) {
        
        for location in positions {
            let marker = NMFMarker()
            print("lat: \(location.latitude), lng: \(location.longitude)")
            marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            marker.mapView = mapView
            marker.iconImage = NMFOverlayImage(image: UIImage(systemName: "house")!)
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                
                if let marker = overlay as? NMFMarker {
                    print("DEBUG: MARKER 클릭")
                }
                
                return true
            }
        }
    }
    
    // 현재 위치와 complaints에 저장된 민원들의 주소 위치 거리 파악
    func checkComplaintsDistance() {
        guard let userLocation = userLocation,
              let userHeading = userHeading else { return }
        
        for complaint in complaints {
            let complaintLocaion = CLLocation(latitude: complaint.latitude, longitude: complaint.longitude)
            let distance = userLocation.distance(from: complaintLocaion)
            
            if distance <= 5.0 {
                let bearing = calculateBearing(location: userLocation, destination: complaintLocaion)
                let headingDifference = abs(userHeading.trueHeading - bearing)
                
                // 45도 이내인지 확인
                if headingDifference <= .pi / 4 {
                    print("DEBUG: 사용자 디바이스 방향으로 마킹의 위치에 5미터 내로 접근하였습니다.")
                }
                
            }
        }
    }
    
    // 사용자의 현재 위치와 민원의 위치 사이의 방향 각도를 계산하는 함수
    func calculateBearing(location: CLLocation, destination: CLLocation) -> Double {
        let userLat = location.coordinate.latitude.toRadians()
        let userLon = location.coordinate.longitude.toRadians()
        let destinationLat = destination.coordinate.latitude.toRadians()
        let destinationLon = destination.coordinate.longitude.toRadians()

        // 현재위치와 사용자 위치 경도 차이
        let deltaLon = destinationLon - userLon

        let y = sin(deltaLon) * cos(destinationLat)
        let x = cos(userLat) * sin(destinationLat) - sin(userLat) * cos(destinationLat) * cos(deltaLon)
        let radiansBearing = atan2(y, x)

        return radiansBearing.toDegrees()
    }
    
    // API 이후 Response 값
    func getPositions() {
        complaints = [
        ComplaintModel(latitude: 37.658649, longitude: 126.831221),
        ComplaintModel(latitude: 37.569771, longitude: 126.897160),
        ComplaintModel(latitude: 37.667478, longitude: 126.751685),
        ComplaintModel(latitude: 37.643139, longitude: 126.788088),
        ComplaintModel(latitude: 37.693203, longitude: 126.727257),
        ComplaintModel(latitude: 37.612836, longitude: 126.834498),
        ComplaintModel(latitude: 37.634592, longitude: 126.832650)
        ]
    }
}

//MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    // 사용자 위치 변경 시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        mapView.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: self.userLocation?.coordinate.latitude ?? 0,
                                                               lng: self.userLocation?.coordinate.longitude ?? 0)))
        checkComplaintsDistance()
    }
    
    // 사용자 장치 방향
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading
        locationOverlay.heading = newHeading.trueHeading
        print("trueHeading: \(newHeading.trueHeading)")
    }
    
    // GPS 사용 권한 확인
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
            locationManager?.startUpdatingHeading()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: 앱을 사용할 때만 위치정보 권한 사용중")
            locationManager?.requestAlwaysAuthorization()
            locationManager?.startUpdatingHeading()
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
            // 설정 화면으로 이동
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - NMFMapViewDelegate
extension HomeViewController: NMFMapViewDelegate, NMFMapViewTouchDelegate {
    // 지도 탭 시
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        print("탭한 지역 - ")
        print("lat: \(latlng.lat), lng: \(latlng.lng)")
        
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 212)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComplaintCollectionViewCell.identifier, for: indexPath) as? ComplaintCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}
