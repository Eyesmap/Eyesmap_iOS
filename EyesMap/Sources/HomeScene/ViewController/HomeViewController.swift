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
import AVFoundation

enum SortType: String, CaseIterable {
    case dottedBlock = "DOTTED_BLOCK"
    case acousticGuidenceSystem = "ACOUSTIC_GUIDENCE_SYSTEM"
    case brailleInfoBoard = "BRAILLE_INFO_BOARD"
}

enum DamageStatusType: String, CaseIterable {
    case normal = "NORMAL"
    case bad = "BAD"
    case severe = "SEVERE"
}

class HomeViewController: UIViewController {

//MARK: - Properties
    private let locationManager = LocationHandler.shared.locationManager
    private var userHeading: CLHeading? // 바라보는 방향
    private var complaints = [ComplaintLocation]() { // API 연결 민원들 추가 값
        didSet {
            self.configureMarking(complaints: complaints)
        }
    }
    private var markers = [NMFMarker]()
    private var player: AVPlayer?
    
    private var tapedComplaint: TapedComplaintResultData? = nil
    private var selectedComplaint: ComplaintLocation? = nil
    private var selectedMarker: NMFMarker? = nil
    private var calledReportId: String = ""
    
    
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
    
    private let reportButton: UIButton = {
        $0.backgroundColor = .black
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
        $0.layer.cornerRadius = 14
        $0.addTarget(self, action: #selector(reportButtonTap), for: .touchUpInside)
        return $0
    }(UIButton())
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calledReportId = ""
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
        
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        currentLocationUpdate()
        cameraUpdate()
        configureMarking(complaints: complaints)
    }
    
    func configureOtherView() {
        view.addSubview(complaintView)
        view.addSubview(reportButton)
        view.addSubview(positionButton)
        
        complaintView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(35)
            make.leading.trailing.equalToSuperview().inset(19)
            make.height.equalTo(200)
        }
        reportButton.snp.makeConstraints { make in
            make.bottom.equalTo(complaintView.snp.top).inset(-20)
            make.leading.equalToSuperview().inset(22)
            make.height.equalTo(30)
            make.width.equalTo(90)
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
    func currentLocationUpdate() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude,
              let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        
        locationOverlay.location = NMGLatLng(lat: currentUserLat, lng: currentUserlong)
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "myPosition")
        locationOverlay.iconWidth = 38
        locationOverlay.iconHeight = 42
        locationOverlay.anchor = CGPoint(x: 0.5, y: 0.5)
        
        
    }
    
    func cameraUpdate() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude,
              let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentUserLat, lng: currentUserlong))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
    
    // 마커 표시 & 이벤트 처리
    func configureMarking(complaints: [ComplaintLocation]) {
        
        for complaint in complaints {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: complaint.gpsY, lng: complaint.gpsX)
            marker.mapView = mapView
            marker.anchor = CGPoint(x: 0.5, y: 1)
            marker.iconImage = NMFOverlayImage(image: UIImage(named: "mark")!)
            
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self,
                      let currentUserLat = locationManager?.location?.coordinate.latitude,
                      let currentUserlong = locationManager?.location?.coordinate.longitude else { return false }
                
                // 마커 선택 시
                if let marker = overlay as? NMFMarker {
                    let model = TapedComplaintRequestModel(reportId: complaint.reportId,
                                                           userGpsX: currentUserlong,
                                                           userGpsY: currentUserLat)
                    self.tapedComplaint(model: model)
                    
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
        guard let userHeading = userHeading?.trueHeading,
              let currentUserLat = locationManager?.location?.coordinate.latitude,
              let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        let userLocation = CLLocation(latitude: currentUserLat, longitude: currentUserlong)
        
        for complaint in complaints {
            let complaintLocaion = CLLocation(latitude: complaint.gpsY, longitude: complaint.gpsX)
            let distance = userLocation.distance(from: complaintLocaion)
            
            if distance <= 15.0 {
                print("DEBUG: 거리 들어옴")
                let bearing = calculateBearing(location: userLocation, destination: complaintLocaion)
                let headingDifference = abs(calculateHeadingDifference(userHeading, bearing))
                
                // 45도 이내인지 확인
                let maxAllowedDifference = 45.0 // 허용 오차 범위 (45도)
                if headingDifference <= maxAllowedDifference {
                    print("DEBUG: 사용자 디바이스 방향으로 마킹의 위치에 15미터 내로 접근하였습니다.")
                    if calledReportId == complaint.reportId {
                        print("이미 불려진 음성입니다.")
                    } else {
                        calledReportId = complaint.reportId
                        self.getVoiceRequest(reportId: complaint.reportId)
                    }
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
    
    // 음원 출력
    func playStreamingAudio(url: String) {
        guard let url = URL(string: url) else { return }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        if player?.rate == 0 {
            player?.play()
            print("음원 실행")
        } else {
            player?.pause()
            print("음원 중단")
        }
    }
    
    // 모든 complaint 지우고 다시 complaint 조회
    func resetComplaint() {
        complaints = []
        markers = []
        tapedComplaint = nil
        selectedComplaint = nil
        complaintView.alpha = 0
        selectedMarker = nil
        calledReportId = ""
        
        getComplaints()
    }
    
    //MARK: - Handler
    @objc func complaintViewTap(_ gesture: UIGestureRecognizer) {
        guard let selectedComplaint = selectedComplaint,
              let tapedComplaint = tapedComplaint else { return }
        let detailVC = DetailViewController(complaint: selectedComplaint, tapedComplaintModel: tapedComplaint)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @objc func targetTap() {
        guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
        guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: currentUserLat, lng: currentUserlong))
        cameraUpdate.animation = .easeIn
        mapView.moveCamera(cameraUpdate)
    }
    
    @objc func reportButtonTap() {
        // 액세스토큰이 없을 때
        if TokenManager.getUserAccessToken() == nil {
            let loginView = LoginViewController()
            loginView.modalPresentationStyle = .fullScreen
            self.present(loginView, animated: true)
        // 로그인 했을 때
        } else {
            guard let currentUserLat = locationManager?.location?.coordinate.latitude else { return }
            guard let currentUserlong = locationManager?.location?.coordinate.longitude else { return }
            let position = NMGLatLng(lat: currentUserLat, lng: currentUserlong)

            let vc = ReportMapViewController(location: CLLocation(latitude: position.lat, longitude: position.lng))
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true)
        }
    }
    
    //MARK: - API
    // API 이후 Response 값
    func getComplaints() {
        ReportNetworkManager.shared.getComplaintsRequest { [weak self] (error, model) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let model = model {
                self?.complaints = model.result
            }
        }
    }
    
    // 마크 탭 했을 시
    func tapedComplaint(model: TapedComplaintRequestModel) {
        ReportNetworkManager.shared.tapedComplaintRequest(parameters: model) { [weak self] (error, model) in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let model = model {
                self.complaintView.model = model.result
                self.tapedComplaint = model.result
            }
        }
    }
    
    func getVoiceRequest(reportId: String) {
        print("음원 API 호출")
        VoiceNetworkManager.shared.getVoiceRequest(reportId: reportId) { [weak self] (error, model) in
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let model = model {
                if model.message == "성공했습니다." {
                    // 음성 파일 출력
                    guard let url = model.result?.url else { return }
                    self.playStreamingAudio(url: url)
                } else {
                    print("DEBUG: TOKEN 없음 - 음성 꺼져있음")
                }
            }
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    // 사용자 위치 변경 시
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocationUpdate()
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
        print("lat: \(latlng.lat), lng: \(latlng.lng)")
        
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
