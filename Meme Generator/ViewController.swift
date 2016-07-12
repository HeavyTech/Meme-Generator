//
//  ViewController.swift
//  Meme Generator
//
//  Created by Jose Virgen on 7/5/16.
//  Copyright © 2016 Jose Virgen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,  UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ]
    
    struct Meme {
        
        var topText: String!
        var bottomText: String!
        var image:UIImage!
        var memedImage: UIImage!
        
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func shareMeme(sender: AnyObject) {
        
        
    }
    
    var memedImage = UIImage()
    var meme: Meme!          //Instance of a meme
    var memes: [Meme]!      //Array of Memes
    

    
    
    override func viewDidLoad() {

       
        super.viewDidLoad()
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        
        //Setting default Text
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        //Hides text field until you picked out pic
        topText.hidden = true
        bottomText.hidden = true
        
        
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        
        //Settings the attributes to the text
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        shareButton.enabled = false
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNoticiation()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    //Controlling the Image Controller.

    
    
    //-------------------Control of App Code ----------------------------------------------
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func pickAnImageFromAlbum(sender:AnyObject){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
    }
   
    //This will allow you to pick a picture and dismiss the controller after.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            topText.hidden = false
            bottomText .hidden = false
            shareButton.enabled = true
            
            //After you pick your pick, navigation bar will go away
//            showToolBar(false)
        }
       dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    
    //This function will allow you to take a photo using camera and loading it to the meme app
    @IBAction func pickAnImageFromCamera(sender:AnyObject){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    
    //----------------------------------------------------------------------------------------
    
    
    
    
    
    //-----------------------Keyboard Controls----------------------------------------------
    
    
    func keyboardWillShow(notification: NSNotification){
        
        self.view.frame.origin.y  -= getKeyboardHeight(notification)
    }
    
    
    func getKeyboardHeight(notification: NSNotification)->CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
        
    }
    
    func subscribeToKeyboardNoticiation(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow", name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    
    func keyboardWillHide(textField:UITextField)-> Bool{
        topText.resignFirstResponder()
        bottomText.resignFirstResponder()
        return true;
    
    }
    
    
    //---------------------------------------------------------------------------------------
    
    func generateMemedImage() -> UIImage {
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    
        return memedImage
    }

    
    func save(){
        
        let meme = Meme(topText:topText.text!, bottomText: bottomText.text!,  image: imageView.image!,  memedImage: memedImage)
        self.meme = meme
    
    }
    
    
    //--------Hides ToolBar-------->>
    func showToolBar(visible: Bool){
        toolbar.hidden = !visible
        
    }
    
    @IBAction func sharePicture(sender: AnyObject) {
        
        save()

        print("This was saved")
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)

    }
    
    
}



