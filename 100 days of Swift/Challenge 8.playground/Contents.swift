import UIKit

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration) { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView()
view.bounceOut(duration: 3)

extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

5.times {
    print("Hello")
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        var itemsCounter = 0
        var index: Index?
        for element in self {
            if element == item {
                if itemsCounter != 2 {
                    itemsCounter += 1
                    index = self.firstIndex(of: element)
                }
            }
        }
        
        if let index = index {
            self.remove(at: index)
        }
        
    }
}

var array = [1, 2, 3, 4, 5, 5, 5]
array.remove(item: 5)


