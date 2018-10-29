//
//  ViewController.swift
//  DrawingApp-Lab3_v3
//
//  Created by Hakkyung on 2018. 10. 3..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//
//  Reference:
//  Rendering UIView to image (https://www.hackingwithswift.com/example-code/media/how-to-render-a-uiview-to-a-uiimage)
//  Saving image in photoLibrary (https://www.youtube.com/watch?v=0IvkfWl4uoI)
//  Loading image from photoLibrary (https://www.youtube.com/watch?v=v8r_wD_P3B8)
//  Putting image back to UIView (https://www.youtube.com/watch?v=Qufbjtda4iQ)


import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var currentLine: Line?
    var lineCanvas: LineView!
    var imageView: UIImageView!
    var imported:Bool = false
    
    var colorSelected:UIColor = UIColor.black
    @IBOutlet weak var trueView: UIView!
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    @IBAction func undoButton(_ sender: Any) {
        
        if(lineCanvas.lines.count != 0){
            
            let myLine:Line = lineCanvas.lines.popLast()!
            print("undoing \(myLine)")
        }
    }
    
    @IBAction func clearView(_ sender: Any) {
        
        lineCanvas.theLine = nil
        lineCanvas.lines = []
        
        if(imported == true){
            print(trueView.subviews)
            while(trueView.subviews.count > 0){
            
                trueView.subviews[trueView.subviews.count - 1].removeFromSuperview()
            }
            trueView.addSubview(lineCanvas)
            imported = false
        }
    }

    @IBAction func colorChanged(_ sender: UIButton) {
        
        let color:String = sender.currentTitle!
        
        switch color{
        
        case "R":
            colorSelected = UIColor.red
        case "Y":
            colorSelected = UIColor.yellow
        case "G":
            colorSelected = UIColor.green
        case "BL":
            colorSelected = UIColor.blue
        case "P":
            colorSelected = UIColor.purple
        case "BK":
            colorSelected = UIColor.black
        default:
            colorSelected = UIColor.black
        }
    }

    
    @IBAction func openButton(_ sender: Any) {
       
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = true
        self.present(image, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: trueView.frame.width, height: trueView.frame.height))
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            clearView(clearButton)
            trueView.addSubview(imageView)
            imageView.addSubview(lineCanvas)
        }
        else{
            
        }
        imported = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let renderer = UIGraphicsImageRenderer(size: trueView.bounds.size)
        let image = renderer.image { ctx in
            trueView.drawHierarchy(in: trueView.bounds, afterScreenUpdates: true)
        }
        
        let toPNG = UIImagePNGRepresentation(image)
        let compressed = UIImage(data: toPNG!)
        UIImageWriteToSavedPhotosAlbum(compressed!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your drawing has been saved!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        lineCanvas = LineView(frame: CGRect(x: 0, y: 0, width: trueView.frame.width, height: trueView.frame.height))
        trueView.addSubview(lineCanvas)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchPoint = touches.first?.location(in: trueView) else { return }
        //print("first point is \(touchPoint)")
        
        currentLine = Line()
        currentLine?.thickness = CGFloat(widthSlider.value)
        currentLine?.color = colorSelected
        currentLine?.points.append(touchPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touchPoint = touches.first?.location(in: trueView) else { return }
        // print("moved point is \(touchPoint)")
        
        currentLine?.points.append(touchPoint)
        lineCanvas.theLine = currentLine
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        lineCanvas.lines.append(currentLine!)
        lineCanvas.theLine = nil
    }

}

