//
//  ViewController.swift
//  Challenge 10
//
//  Created by Volodymyr Khuda on 12.04.2021.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var capitals = [String]()
    var items = [CardCell]()
    
    var score = 0 {
        didSet {
            title = "CapitalMacher | Score: \(score)"
        }
    }
    
    var removedCards = 0
    
    var activatedCards = [CardCell]()
    
    var deletedCards = [CardCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CapitalMatcher | Score: 0"
        
        capitals = ["Paris", "Kyiv", "Moscow", "Washingotn", "Tokyo", "Warzaw", "Minsk", "Prague"]
        capitals += capitals
        capitals.shuffle()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CardCell else {
            fatalError("Can't case cell as CardCell")
            
        }
        
        item.cityName.text = capitals[indexPath.item]
        item.cardBack.image = UIImage(named: "card")
        
        items.append(item)
        
        return item
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.item]
        
        if activatedCards.count < 1 {
            activatedCards.append(item)
            item.cardBack.alpha = 0
            item.isUserInteractionEnabled = false
            
        } else {
            item.cardBack.alpha = 0
            activatedCards.append(item)
            if activatedCards[0].cityName.text == item.cityName.text {
                activatedCards[0].cityName.isHidden = true
                activatedCards[0].isUserInteractionEnabled = false
                
                item.cardBack.alpha = 0
                item.cityName.isHidden = true
                item.isUserInteractionEnabled = false
                
                deletedCards.append(activatedCards[0])
                deletedCards.append(item)
                
                activatedCards.removeAll(keepingCapacity: true)
                
                score += 100
                
                removedCards += 2
                
                if removedCards == 16 {
                    let ac = UIAlertController(title: "You have ended this game!", message: "Your score: \(score)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: { [weak self] (alert) in
                        self?.restartGame()
                    }))
                    present(ac, animated: true, completion: nil)
                }
                
                print(removedCards)
                
                
            } else {
                UIView.animate(withDuration: 4) {
                    self.activatedCards[0].cardBack.alpha = 1
                    self.activatedCards[1].cardBack.alpha = 1
                } completion: { (finished) in
                    
                }
                
                self.activatedCards[0].isUserInteractionEnabled = true
                self.activatedCards.removeAll(keepingCapacity: true)
                self.score -= 25

            }
            
        }
        
    }
    
    func restartGame() {
        for card in deletedCards {
            card.cardBack.alpha = 1
            card.cityName.isHidden = false
            card.isUserInteractionEnabled = true
            
        }
        
        items.removeAll(keepingCapacity: true)
        activatedCards.removeAll(keepingCapacity: true)
        deletedCards.removeAll(keepingCapacity: true)
        removedCards = 0
        
        capitals.shuffle()
        collectionView.reloadData()
        
        score = 0
        
    }
    
    
}

