//
//  ViewController.swift
//  Project 25
//
//  Created by Volodymyr Khuda on 21.03.2021.
//

import MultipeerConnectivity
import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var images = [UIImage]()
    
    var peerID: MCPeerID?
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie share"
        
        let addConenectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let sendMessageButton = UIBarButtonItem(title: "Send message", style: .plain, target: self, action: #selector(sendMessage))
        let importPictureButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let connectionListButton = UIBarButtonItem(title: "Connections", style: .plain, target: self, action: #selector(showConnections))
        
        navigationItem.leftBarButtonItems = [addConenectionButton, sendMessageButton]
        navigationItem.rightBarButtonItems = [connectionListButton, importPictureButton]
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        
        mcSession = MCSession(peer: peerID!, securityIdentity: nil, encryptionPreference: .none)
        mcSession?.delegate = self
        
    }
    
    func startHosting(alert: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "kvm-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
        
    }
    
    func joinSession(alert: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "kvm-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true, completion: nil)
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    @objc func showConnections() {
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            var connections = ""
            
            for i in 0..<mcSession.connectedPeers.count {
                connections += "\(i + 1). \(mcSession.connectedPeers[i].displayName)\n"
                
            }
            
            let ac = UIAlertController(title: "Connectins list", message: "\(connections)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            
        } else {
            let ac = UIAlertController(title: "No connections", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            
        }
        
    }
    
    @objc func sendMessage() {
        let ac = UIAlertController(title: "Send message", message: "Send your message to all conected users", preferredStyle: .alert)
        ac.addTextField(configurationHandler: nil)
        ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self] (alert) in
            guard let mcSession = self?.mcSession else { return }
            
            if mcSession.connectedPeers.count > 0 {
                if let textMessage = ac.textFields?[0].text {
                    let data = Data(textMessage.utf8)
                    do {
                        try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
                    } catch {
                        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(ac, animated: true, completion: nil)
                    }
                }
            }
            
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true, completion: nil)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        guard let mcSession = mcSession else { return }
        
        if mcSession.connectedPeers.count > 0 {
            if let imageData = image.pngData() {
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(ac, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not connected:  \(peerID.displayName)")
            DispatchQueue.main.async {  [weak self] in
                let ac = UIAlertController(title: "User \(peerID.displayName) have been disconnected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true, completion: nil)
            }
            
        @unknown default:
            print("Unkwnon state received:  \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                let ac = UIAlertController(title: "You received a message from \(peerID.displayName)!", message: String(decoding: data, as: UTF8.self), preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(ac, animated: true, completion: nil)
            }
            
        }
    }
    
    

}

