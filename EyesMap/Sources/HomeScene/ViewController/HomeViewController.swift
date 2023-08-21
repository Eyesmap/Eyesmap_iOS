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
//import CoreMotion

class HomeViewController: UIViewController {

//MARK: - Properties
    private let locationManager = LocationHandler.shared.locationManager
    private var userLocation: CLLocation? // 현 위치
    private var userHeading: CLHeading? // 바라보는 방향
    private var complaints = [ComplaintModel]() // API 연결 민원들 추가 값
    private var markers = [NMFMarker]()
    
    private var selectedComplaint: ComplaintModel? = nil
    private var selectedMarker: NMFMarker? = nil
    
    
    private let mapView = NMFMapView()
    
    private lazy var positionButton: UIView = {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.cornerRadius = 48 / 2
        
        let imageBtn: UIButton = {
            let btn = UIButton()
            btn.setImage(UIImage(named: "target"), for: .normal)
            btn.addTarget(self, action: #selector(targetTap), for: .touchUpInside)
            return btn
        }()
        
        $0.addSubview(imageBtn)
        imageBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return $0
    }(UIView())
    
    private lazy var complaintView: HomeComplaintView = {
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(complaintViewTap(_:)))
        $0.addGestureRecognizer(tapGesture)
        return $0
    }(HomeComplaintView())
    
    private lazy var locationOverlay = mapView.locationOverlay // 사용자 위치 표시
    
    
    
//MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        getComplaints() // 서버연동 시 변경
        setUIandConstraints()
        enableLocationServices()
    }


//MARK: - set UI
    func setUIandConstraints() {
        configureMapView()
        configureOtherView()
        configureNavBar()
    }
    
    // MapView Setting
    func configureMapView() {
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:)))
        mapView.addGestureRecognizer(longTapGesture)
        
        
        view.addSubview(mapView)
                
                mapView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
        currentLocationCameraUpdate()
        configureMarking(complaints: complaints)
    }
    
    func configureOtherView() {
        view.addSubview(complaintView)
        view.addSubview(positionButton)
        
        complaintView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(200)
        }
        
        positionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(complaintView.snp.top).inset(-33)
            make.width.height.equalTo(48)
        }
    }
    
    func configureNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // 현 위치 아이콘 & 카메라 업데이트
    func currentLocationCameraUpdate() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
        guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        
        locationOverlay.location = NMGLatLng(lat: currentUserLat, lng: currentUserlong)
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "myPosition")
        locationOverlay.iconWidth = 38
        locationOverlay.iconHeight = 42
        locationOverlay.anchor = CGPoint(x: 0.5, y: 0.5)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentUserLat, lng: currentUserlong))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
    
    // 마커 표시 & 이벤트 처리
    func configureMarking(complaints: [ComplaintModel]) {
        
        for complaint in complaints {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: complaint.latitude, lng: complaint.longitude)
            marker.mapView = mapView
            marker.anchor = CGPoint(x: 0.5, y: 1)
            marker.iconImage = NMFOverlayImage(image: UIImage(named: "mark")!)
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self else { return false }
                
                // 마커 선택 시
                if let marker = overlay as? NMFMarker {
                    // 이미 선택된 마커 초기화
                    if let selectedMarker = selectedMarker {
                        selectedMarker.iconImage = NMFOverlayImage(image: UIImage(named: "mark")!)
                    }
                    
                    UIView.animate(withDuration: 0.5) {
                        self.complaintView.alpha = 1
                        marker.iconImage = NMFOverlayImage(image: UIImage(named: "selectedMark")!)
                        self.selectedMarker = marker
                        self.selectedComplaint = complaint
                    }
                    
                }
                return true
            }
        }
    }
    
    // 현재 위치와 complaints에 저장된 민원들의 주소 위치 거리 파악
    func checkComplaintsDistance() {
        guard let userLocation = userLocation,
              let userHeading = userHeading?.trueHeading else { return }
        
        for complaint in complaints {
            let complaintLocaion = CLLocation(latitude: complaint.latitude, longitude: complaint.longitude)
            let distance = userLocation.distance(from: complaintLocaion)
            
            if distance <= 30.0 {
                print("DEBUG: 거리 들어옴")
                let bearing = calculateBearing(location: userLocation, destination: complaintLocaion)
                let headingDifference = abs(calculateHeadingDifference(userHeading, bearing))
                
                // 45도 이내인지 확인
                let maxAllowedDifference = 45.0 // 허용 오차 범위 (45도)
                if headingDifference <= maxAllowedDifference {
                    print("DEBUG: 사용자 디바이스 방향으로 마킹의 위치에 5미터 내로 접근하였습니다.")
                }
            }
        }
    }
    
    // 사용자의 디바이스 방향과 마킹을 바라보는 방향 간의 차이를 계산하는 함수
    func calculateHeadingDifference(_ userHeading: Double, _ markingHeading: Double) -> Double {
        let difference = userHeading - markingHeading
        if difference > 180 {
            return 360 - difference
        } else if difference < -180 {
            return 360 + difference
        }
        return abs(difference)
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
    func getComplaints() {
        complaints = [
            ComplaintModel(latitude: 37.612836, longitude: 126.834498),
            ComplaintModel(latitude: 37.634592, longitude: 126.832650),
            ComplaintModel(latitude: 37.62146193038201, longitude: 126.83230989248261)
        ]
        
        markers = [
            NMFMarker(position: NMGLatLng(lat: 37.612836, lng: 126.834498), iconImage: NMFOverlayImage(image: UIImage(systemName: "house")!)),
            NMFMarker(position: NMGLatLng(lat: 37.634592, lng: 126.832650), iconImage: NMFOverlayImage(image: UIImage(systemName: "house")!)),
            NMFMarker(position: NMGLatLng(lat: 37.62146193038201, lng: 126.83230989248261), iconImage: NMFOverlayImage(image: UIImage(systemName: "house")!))

        ]
        
    }
    
    //MARK: - Handler
    // 길게 탭 했을 시
    @objc func handleLongTap(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: mapView)
            let latlng = mapView.projection.latlng(from: point)

            let vc = ReportMapViewController(location: CLLocation(latitude: latlng.lat, longitude: latlng.lng))
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true)
        }
    }
    
    @objc func complaintViewTap(_ gesture: UIGestureRecognizer) {
        print("tap")
        guard let complaint = selectedComplaint else { return }
        let detailVC = DetailViewController(complaint: complaint)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func targetTap() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
        guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentUserLat, lng: currentUserlong))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
}

//MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    // 사용자 위치 변경 시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
    
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
extension HomeViewController: NMFMapViewDelegate {
    // 지도 탭 시
    func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
        // 마킹 제거
        UIView.animate(withDuration: 0.5) {
            if let selectedMarker = self.selectedMarker {
                selectedMarker.iconImage = NMFOverlayImage(image: UIImage(named: "mark")!)
                self.complaintView.alpha = 0
            }
            self.selectedMarker = nil
            self.selectedComplaint = nil
        }
    }
}
