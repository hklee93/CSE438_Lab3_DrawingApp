//
//  LineView.swift
//  DrawingApp-Lab3_v3
//
//  Created by Hakkyung on 2018. 10. 3..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//

import Foundation
import UIKit

class LineView: UIView{
    
    override init(frame: CGRect){
        
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var theLine: Line?{
        
        didSet{
            
            setNeedsDisplay()
        }
    }
    
    var lines: [Line] = []{
        
        didSet{
            
            setNeedsDisplay()
        }
    }
    
    private func midpoint(first: CGPoint, second: CGPoint) -> CGPoint{
        
        let firstX: CGFloat = first.x
        let firstY: CGFloat = first.y
        let secondX: CGFloat = second.x
        let secondY: CGFloat = second.y
        
        let midX: CGFloat = (firstX + secondX) / 2.0
        let midY: CGFloat = (firstY + secondY) / 2.0
        
        return CGPoint(x: midX, y: midY)
    }
    
    func createQuadPath(points: [CGPoint]) -> UIBezierPath{
        
        let path = UIBezierPath()
        if points.count < 2 { return path }
        let firstPoint = points[0]
        let secondPoint = points[1]
        let firstMidPoint = midpoint(first: firstPoint, second: secondPoint)
        path.move(to: firstPoint)
        path.addLine(to: firstMidPoint)
        for index in 1 ..< points.count - 1 {
            
            let currentPoint = points[index]
            let nextPoint = points[index + 1]
            let midPoint = midpoint(first: currentPoint, second: nextPoint)
            path.addQuadCurve(to: midPoint, controlPoint: currentPoint)
        }
        guard let lastLocation = points.last else { return path }
        path.addLine(to: lastLocation)
        return path
    }
    
    func drawLine(_ line: Line){
        
        //print("in drawLine")
        let path = createQuadPath(points: line.points)
        let dot: CGPoint = line.points[0]
        
        if(line.points.count == 1){
            
            //print("1: \(line.points)")
            path.addArc(withCenter: dot, radius: line.thickness * 10, startAngle: 0, endAngle: CGFloat(Float.pi * 2), clockwise: true)
            line.color.setFill()
            path.fill()
        }
        else{
            
            //print("2: \(line.points)")
            path.lineWidth = line.thickness * 10
            line.color.setStroke()
            path.stroke()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        //print("in draw")
        for line in lines{
            
            drawLine(line)
        }
        if(theLine != nil){
            
            drawLine(theLine!)
        }
        
    }
}
