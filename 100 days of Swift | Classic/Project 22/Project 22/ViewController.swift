//
//  ViewController.swift
//  Project 22
//
//  Created by Volodymyr Khuda on 13.03.2021.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var beaconName: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    
    var locationManager: CLLocationManager?
    
    let uuid1 = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
    let uuid2 = UUID(uuidString: "757835A0-AB31-4407-B2A8-110B783C546F")!
    
    var isBeaconDetected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        isBeaconDetected = defaults.bool(forKey: "isBeaconDetected")
        
        circleView.layer.cornerRadius = 128
        circleView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
        
    }
    
    func startScanning() {
        
        let beaconRegion1 = CLBeaconRegion(uuid: uuid1, major: 123, minor: 456, identifier: "My beacon")
        let beaconRegion2 = CLBeaconRegion(uuid: uuid2, major: 123, minor: 456, identifier: "My second beacon")
        
        let beaconIdentity1 = CLBeaconIdentityConstraint(uuid: uuid1, major: 123, minor: 456)
        let beaconIdentity2 = CLBeaconIdentityConstraint(uuid: uuid2, major: 123, minor: 456)
        
        runScan(beaconRegion: beaconRegion1, beaconIdentity: beaconIdentity1)
        runScan(beaconRegion: beaconRegion2, beaconIdentity: beaconIdentity2)
        
    }
    
    func runScan(beaconRegion: CLBeaconRegion, beaconIdentity: CLBeaconIdentityConstraint) {
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconIdentity)
    }
    
    func update(distance: CLProximity, uuid: UUID) {
        UIView.animate(withDuration: 1) {
            
            switch uuid {
            case self.uuid1:
                self.beaconName.text = "iPhone"
            case self.uuid2:
                self.beaconName.text = "Your MacBook"
            default:
                self.beaconName.text = "Here is no trusted beacons..."
            }
            
            switch distance {
            case .unknown:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconName.text = "Here is no trusted beacons..."
                self.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            case .far:
                self.view.backgroundColor = .blue
                self.distanceReading.text = "FAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = .orange
                self.distanceReading.text = "NEAR"
                self.circleView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = .red
                self.distanceReading.text = "RIGHT HERE"
                self.circleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            default:
                self.view.backgroundColor = .gray
                self.distanceReading.text = "UNKNOWN"
                self.beaconName.text = "Here is no trusted beacons..."
                self.circleView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity, uuid: beacon.uuid)
            if !isBeaconDetected {
                self.isBeaconDetected = true
                let ac = UIAlertController(title: "Beacon detected!", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { [weak self] (alert) in
                    let defaults = UserDefaults.standard
                    defaults.set(self?.isBeaconDetected, forKey: "isBeaconDetected")
                }))
                present(ac, animated: true, completion: nil)
            }
        } else {
//            update(distance: .unknown)
        }
    }
    
    
}

