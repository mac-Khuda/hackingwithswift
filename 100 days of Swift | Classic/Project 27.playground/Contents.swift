import UIKit

func drawEmoji() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    renderer.image { (ctx) in
        let mainRectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 10, dy: 10)
        ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(3)
        ctx.cgContext.addEllipse(in: mainRectangle)
        
        ctx.cgContext.drawPath(using: .fillStroke)
        
        let eye1 = CGRect(x: 145, y: 175, width: 50, height: 80)
        let eye2 = CGRect(x: 300, y: 175, width: 50, height: 80)
        ctx.cgContext.setFillColor(UIColor.black.cgColor)
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(3)
        
        ctx.cgContext.addEllipse(in: eye1)
        ctx.cgContext.addEllipse(in: eye2)
        
        ctx.cgContext.drawPath(using: .fillStroke)
        
        ctx.cgContext.move(to: CGPoint(x: 100, y: 325))
        ctx.cgContext.addCurve(to: CGPoint(x: 400, y: 325), control1: CGPoint(x: 205, y: 450), control2: CGPoint(x: 300, y: 450))
        ctx.cgContext.setLineWidth(12)
        
        ctx.cgContext.strokePath()
        
        
    }
}

drawEmoji()

func drawTwin() {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
    renderer.image { (ctx) in
        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
        ctx.cgContext.setLineWidth(5)
        
        //render "T"
        
        ctx.cgContext.move(to: CGPoint(x: 25, y: 25))
        ctx.cgContext.addLine(to: CGPoint(x: 75, y: 25))
        
        ctx.cgContext.move(to: CGPoint(x: 50, y: 25))
        ctx.cgContext.addLine(to: CGPoint(x: 50, y: 75))
        
        //render "W"
        
        let width = 90
        
        ctx.cgContext.move(to: CGPoint(x: 90, y: 25))
        ctx.cgContext.addLine(to: CGPoint(x: width + 15, y: 75))
        ctx.cgContext.addLine(to: CGPoint(x: width + 30, y: 40))
        ctx.cgContext.addLine(to: CGPoint(x: width + 45, y: 75))
        ctx.cgContext.addLine(to: CGPoint(x: width + 60, y: 25))
        
        //render "I"
        
        ctx.cgContext.move(to: CGPoint(x: 165, y: 25))
        ctx.cgContext.addLine(to: CGPoint(x: 200, y: 25))
        
        ctx.cgContext.move(to: CGPoint(x: 182.5, y: 25))
        ctx.cgContext.addLine(to: CGPoint(x: 182.5, y: 75))
        
        ctx.cgContext.move(to: CGPoint(x: 165, y: 75))
        ctx.cgContext.addLine(to: CGPoint(x: 200, y: 75))
        
        //render "N"
        
        ctx.cgContext.move(to: CGPoint(x: 215, y: 75))
        ctx.cgContext.addLine(to: CGPoint(x: 215, y: 25))
        ctx.cgContext.addLine(to: CGPoint(x: 245, y: 75))
        ctx.cgContext.addLine(to: CGPoint(x: 245, y: 25))
        
        ctx.cgContext.strokePath()
    }
}

drawTwin()
