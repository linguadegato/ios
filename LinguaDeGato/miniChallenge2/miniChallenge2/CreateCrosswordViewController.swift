//
//  CreateCrosswordViewController.swift
//  miniChallenge2
//
//  Created by Kobayashi on 6/12/15.
//  Copyright (c) 2015 Kobayashi. All rights reserved.
//
//MARK: HARRY-TODO: Create a function for a aPathCompletion, not persist already persisted images
import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class CreateCrosswordViewController: StatusBarViewController, UITextFieldDelegate,
    UINavigationControllerDelegate, UICollectionViewDataSource,
    UICollectionViewDelegate, UIImagePickerControllerDelegate,
    AVAudioRecorderDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - PROPERTIES
    
    //MARK: Buttons
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var cameraRollButton: UIButton!
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var muteMusicButton: UIButton!

    
    //MARK: Views
    @IBOutlet weak var newImageImgView: UIImageView!
    @IBOutlet weak var newWordTxtField: UITextField!
    @IBOutlet weak var wordsAddedCollectionView: UICollectionView!
    @IBOutlet weak var lowerContainer: UIView!
    @IBOutlet weak var audioImageImgView: UIImageView!
    @IBOutlet weak var trashImageImgView: UIImageView!
    @IBOutlet weak var removeAudioView: UIView!
    @IBOutlet weak var animationBackgroundView: UIView!
    @IBOutlet weak var arrow: UIImageView!

    //MARK: Colors and apearance
    
    //Images
    
    // - New image
    private let defaultImage = UIImage(named: "imageDefault")
    private let audioImage = UIImage(named: "imageDefaultAudio")
    
    // - Audio Button to delete record
    private let audioButtonReadyToUseImage = (UIImage(named: "btnAudio"))
    private let audioButtonRecordingImage = (UIImage(named: "btnAudioBlue"))
    
    // - Add new clue
    private let addButtonImageOn = (UIImage(named: "iconAddWhiteSmall"))
    
    //textField
    private let textFieldBorderColor = UIColor.bluePalete().CGColor
    private let textFieldBorderWidth: CGFloat = 1.0
    private let textFieldBorderRadius : CGFloat = 1.0

    //newImageImgView
    private let newImageBorderColor = UIColor.bluePalete().CGColor
    private let newImageBorderWidth: CGFloat = 1.0
    
    //slide view
    private let slideViewBorderRadius : CGFloat = 30.0
    
    //animation 
    private var playAudioImgViewOriginalPosition : CGPoint?
    
    //mute button images
    private let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
    private let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    //MARK: Keyboard variable
    private var isKeyboardLifted: Bool = false
    
    //MARK: Animations Variables
    private var arrowAnimationTimer: NSTimer!
    
    //MARK: Crossword Creation related variables
    private var gameName: String!
    private var newMedia: Bool?
    
    private var hasClue = false {
        didSet {
            setAddButtonState()
        }
    }
    private var hasWord = false {
        didSet {
            setAddButtonState()
        }
    }
    
    private var wordsLimitReached = false {
        didSet {
            setAddButtonState()
        }
    }
    
    private var newWords: [WordAndClue] = []
    
    //MARK: File related variables
    private let aFileManager = NSFileManager.defaultManager()
    private let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    //path of the image in newImageImgView
    private var imageID: String?
    
    // Audio session to manage recording and an audio recorder to handle the actual reading and saving of data
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var audioPath: String?
    private var audio: AVAudioPlayer!

    private var backButton : UIBarButtonItem!

    let limitLength = BoardView.maxSquaresInCol
    
    //MARK: - VIEW LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //used to limiting the number of characters
        newWordTxtField.delegate = self
        
        // Disable the swipe to make sure you get your chance to save
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        
        //MARK: appearance settings
        
        lowerContainer.hidden = true
        
        newWordTxtField.layer.borderColor = textFieldBorderColor
        newWordTxtField.layer.borderWidth = textFieldBorderWidth
        newWordTxtField.layer.cornerRadius = textFieldBorderRadius
        
        audioButton.setBackgroundImage(audioButtonReadyToUseImage, forState: .Normal)
        audioButton.setBackgroundImage(audioButtonRecordingImage, forState: .Highlighted)
        
        newImageImgView.layer.borderColor = newImageBorderColor
        newImageImgView.layer.borderWidth = newImageBorderWidth
        
        audioImageImgView.layer.cornerRadius = slideViewBorderRadius

        animationBackgroundView.layer.cornerRadius = slideViewBorderRadius
        
        addButton.setImage(addButtonImageOn, forState: UIControlState.Normal)
        addButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        setAddButtonState()
        
        //MARK: interaction settings
        
        //buttons
        generateButton.enabled = false
        addButton.backgroundColor = UIColor.greenPalete().colorWithAlphaComponent(CGFloat(0.5))
        addButton.userInteractionEnabled = false
        
        //MARK: Set gesture recognizers
        //gesture recognizer to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        //gesture recognizers in main image
        newImageImgView.userInteractionEnabled = true
        newImageImgView.addGestureRecognizer(createGestureTapImageToPlayRecord())
        removeAudioView.addGestureRecognizer(createGestureTapImageToPlayRecord())
        
        //audio image gesture reconizers
        playAudioImgViewOriginalPosition = audioImageImgView.frame.origin
        audioImageImgView.userInteractionEnabled = true
        audioImageImgView.addGestureRecognizer(createGestureLongPressDeleteRecord())
        
        //MARK: request permission to use microfone
        audioButton.enabled = false
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if allowed {
                        // Enable audio button
                        self.audioButton.enabled = true
                        
                    } else {
                        //MARK: TODO: [audio] error message
                        // failed to record!
                    }
                }
            }
        } catch {
            //MARK: TODO: [audio] error message
            // failed to record!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //set image of mute button
        if MusicSingleton.sharedMusic().isMusicMute {
            muteMusicButton.setImage(muteMusicOnImage, forState: .Normal)
        } else {
            muteMusicButton.setImage(muteMusicOffImage, forState: .Normal)
        }
        
        // Keyboard:
        super.viewWillAppear(animated)
        let center: NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // Prepare animation to delete audio
        resetAnimationViewPosition()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - BUTTON ACTIONS
    @IBAction func goBackPopup(sender: AnyObject) {
        
        if (wordsAddedCollectionView.numberOfItemsInSection(0) > 0){
            
            let alert = UIAlertController(title: "Deseja realmente sair?", message: "As palavras criadas serão perdidas.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler:nil))
            
            alert.addAction(UIAlertAction(
                title: "Sair",
                style: UIAlertActionStyle.Default,
                handler:
                {(UIAlertAction)in
                    self.goBack()                }
                ))
            
            self.presentViewController(alert, animated: true, completion: {
                print("completion block")
            })
            
        }else{
            self.goBack()
        }
    }
    
    private func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
        
        // Don't forget to re-enable the interactive gesture
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
        
        // if the back button is pressed when a clue audio is recording or playing, the music status is stoped
        // so we need to play when exit to another screen
        if !MusicSingleton.sharedMusic().isMusicMute {
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        }
    }

    // "mute" button
    @IBAction func muteMusicButton(sender: AnyObject) {
        if MusicSingleton.sharedMusic().isMusicMute {
            // music will play
            muteMusicButton.setImage(muteMusicOffImage, forState: .Normal)
            MusicSingleton.sharedMusic().isMusicMute = false
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
        } else {
            // music will stop
            muteMusicButton.setImage(muteMusicOnImage, forState: .Normal)
            MusicSingleton.sharedMusic().isMusicMute = true
            MusicSingleton.sharedMusic().playBackgroundAudio(false)
        }
    }
    
    //"camera" button (new photo)
    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            //add orientation observer
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
            
            //instatiate imagePicker
            let imagePicker = UIImagePickerController()
                
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            //MARK: TODO: Add orientation's observer
            
            //create a frame where the photo will be cropped
            //MARK: TODO: treat orientations changes
            /*
            let xPosition = ((imagePicker.view.frame.width  - imagePicker.toolbar!.frame.width) - imagePicker.view.frame.height) / 2
            
            let aRect = CGRect(x: xPosition, y: 0, width: imagePicker.view.frame.height, height: imagePicker.view.frame.height)

            let aView = UIView(frame: aRect)
            aView.backgroundColor = nil
            aView.layer.borderColor = UIColor.greenColor().CGColor
            aView.layer.borderWidth = 0.5
            
            imagePicker.view.addSubview(aView)
            */
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
            newMedia = true
        }
    }
    
    //"camera roll" button (stored photo)
    @IBAction func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = false
        }
    }
    
    // Record audio button
    @IBAction func recordAudio(sender: AnyObject) {
        if audioRecorder == nil {
            MusicSingleton.sharedMusic().playBackgroundAudio(false)
            startRecording()
        } else {
            finishRecording(success: true)
            if !MusicSingleton.sharedMusic().isMusicMute {
            MusicSingleton.sharedMusic().playBackgroundAudio(true)
            }
        }
    }
    
    // Add new word button
    @IBAction func addNewWord() {
        
        generateButton.enabled = true

        //removing black spaces
        let txtNewWord = newWordTxtField.text
        let trimmedNewWordTxtField = txtNewWord!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if !(trimmedNewWordTxtField.characters.count > BoardView.maxSquaresInCol) {
            
            // Appending new word + clue to newwords array:
            let aClue = Clue(aImageID: imageID, anAudioPath: audioPath)
            newWords.append(WordAndClue(aWord: trimmedNewWordTxtField, aClue: aClue))
            
            // Clear audioPath variable
            self.audioPath = nil
            self.audioRecorder = nil
            self.recordingSession = nil
            self.imageID = nil
            
            wordsAddedCollectionView.reloadData()
            
            // Hide elements (image view and new word text field)
            hideSlideView()
            newImageImgView.image = defaultImage
            hasClue = false
            self.newWordTxtField.text = ""
            hasWord = false
            
            
            if newWords.count >= 6 {
                wordsLimitReached = true
                takePhotoButton.enabled = false
                cameraRollButton.enabled = false
                audioButton.enabled = false
            }
            
            // Show lower container (collection view and play button)
            lowerContainer.hidden = false
        }
    }
    
    @IBAction func playGame(sender: AnyObject) {
        
        self.performSegueWithIdentifier("GenerateCrossword", sender: self)
        
    }
    
    @IBAction func saveGame(sender: AnyObject) {
        
        let saveAlert = UIAlertController(title: "Dê um nome ao jogo:", message: "É preciso inserir um nome para salvar", preferredStyle: UIAlertControllerStyle.Alert)

        saveAlert.addTextFieldWithConfigurationHandler({ alertTextField in
            alertTextField.placeholder = "Nome do jogo"
        })
        let alertTextField = saveAlert.textFields![0]
        
        saveAlert.addAction(UIAlertAction(title: "Salvar", style: UIAlertActionStyle.Default, handler:{ _ in
            
            if alertTextField.text != nil && alertTextField.text!.characters.count > 0 {
                
                let newGame = Game(gameName: alertTextField.text!, wordsAndClue: self.newWords)
                GameServices.saveGame(newGame, completion: {success in
                    if success {
                        let operation = NSBlockOperation(block: { () -> Void in
                            self.performSegueWithIdentifier("GenerateCrossword", sender: self)
                        })
                        NSOperationQueue.mainQueue().addOperation(operation)
                    }
                    else{
                        NSOperationQueue.mainQueue().addOperation(NSBlockOperation(block: {
                            self.overwriteGame(newGame)
                        }))
                    }
                })
            }
            else {
                print("empty text field!")
            }
        }))
        
        saveAlert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel, handler:nil))
        
        self.presentViewController(saveAlert, animated: true, completion: {
        })
    }
    
    // MARK: Button state management
    
    //disable addButton if there's no clue, or no word, or if there's already 6 words
    private func setAddButtonState() {
        if hasClue && hasWord && !wordsLimitReached {
            addButton.backgroundColor = UIColor.greenPalete().colorWithAlphaComponent(CGFloat(1))
            addButton.userInteractionEnabled = true
        } else {
            addButton.backgroundColor = UIColor.greenPalete().colorWithAlphaComponent(CGFloat(0.5))
            addButton.userInteractionEnabled = false
        }
    }
    
    //MARK: - TEXTFIELD PROPERTIES
    
    //limits the characters in newWordTxtField
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = newWordTxtField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    //MARK: - GESTURE RECOGNIZERS GENERATORS
    
    //Returns a tapGestureRecognizers to play recorded audio
    private func createGestureTapImageToPlayRecord() -> UITapGestureRecognizer{
        let tapGesture = UITapGestureRecognizer(target:self, action:Selector("tapAndPlayRecord:"))
        
        return tapGesture
    }
    
    //Returns a longPressRecognizer to erase audio
    private func createGestureLongPressDeleteRecord() -> UILongPressGestureRecognizer{
        let longPressGesture = UILongPressGestureRecognizer(target:self, action:Selector("longPressAction:"))
        let longPressDistance = self.removeAudioView.frame.width
        
        longPressGesture.minimumPressDuration = 0.3
        longPressGesture.allowableMovement.advancedBy(longPressDistance)
        
        return longPressGesture
    }
    
    //MARK: - GESTURE RECOGNIZERS ACTIONS
    
    func tapAndPlayRecord(sender: UITapGestureRecognizer){
        if self.audioPath != nil {
            let audioURL = NSURL(fileURLWithPath: self.audioPath!)
            var audioPlayerTimer = NSTimer()
            
            do {
                try self.audio = AVAudioPlayer(contentsOfURL: audioURL)
                MusicSingleton.sharedMusic().playBackgroundAudio(false)
                self.audio.play()
                
                audioPlayerTimer = NSTimer.scheduledTimerWithTimeInterval(audio.duration, target: self, selector: "playMusicAfterPlayClue", userInfo: nil, repeats: false)
            } catch {
                //MARK: TODO: [audio] error message
            }
        }
    }
    
    func playMusicAfterPlayClue(){
        if !MusicSingleton.sharedMusic().isMusicMute {
        MusicSingleton.sharedMusic().playBackgroundAudio(true)
        }
    }
    
    // MARK: Long Press and show trash animation
    func longPressAction(sender: UILongPressGestureRecognizer){
        
        switch sender.state{
            
            case UIGestureRecognizerState.Began:
                self.animationBackgroundView.hidden = false
                UIView.animateWithDuration(
                    0.3,
                    animations: {
                        self.animationBackgroundView.frame.size.width = self.removeAudioView.frame.size.width
                        self.animationBackgroundView.frame.origin.x = 0
                    },
                    completion: {
                        animationFinished in
                        if (self.animationBackgroundView.frame.origin.x == 0){
                            self.trashImageImgView.hidden = false
                            //self.arrow.frame.origin.x = self.audioImageImgView.frame.origin.x
                            self.arrow.hidden = false
                        }
                    }
                )
                self.arrowAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(1.2, target: self, selector: "slideAnimation" , userInfo: nil, repeats: true)
                self.arrowAnimationTimer.fire()

                break
        
            case UIGestureRecognizerState.Ended:
                self.arrowAnimationTimer.invalidate()
                resetAnimationViewPosition()
                hideElementsAfterAnimation()
                break

            case UIGestureRecognizerState.Cancelled:
                self.arrowAnimationTimer.invalidate()
                UIView.animateWithDuration(
                    0.3,
                    animations: {
                        self.animationBackgroundView.frame.size.width = 0
                        self.audioImageImgView.center.x = self.audioImageImgView.frame.width/2
                    },
                    completion: {
                        (finished:Bool) in
                        
                        // Clear audioPath variable
                        self.audioPath = nil
                        self.audioRecorder = nil
                        self.recordingSession = nil
                        if (self.newImageImgView.image == self.audioImage) {
                            self.newImageImgView.image = self.defaultImage
                            self.hasClue = false
                        }
        
                        // Make Gesture Recognizer avaiable and hide elements
                        sender.enabled = true
                        self.hideElementsAfterAnimation()
                        self.resetAnimationViewPosition()
                        self.hideSlideView()
                    }
                )
                break

            case UIGestureRecognizerState.Changed:
                let location = sender.locationInView(removeAudioView)
                let limitRectangle = self.removeAudioView.bounds
                let deltaWidth = self.audioImageImgView.frame.width/2
                let limitXToDelete = self.removeAudioView.frame.width/2
                
                if CGRectContainsPoint(limitRectangle, location){
                    if ((location.x >= deltaWidth) && (location.x <= self.removeAudioView.frame.width - deltaWidth)){
                    
                        if (location.x <= limitXToDelete){
                            self.trashImageImgView.hidden = true
                            sender.enabled = false
                        }else{
                            self.animationBackgroundView.frame.size.width = location.x + deltaWidth
                            self.audioImageImgView.center.x = location.x
                        }
                    }
                }
                break
            
            default:
                break
        }
    }

    // MARK: - RECORD AUDIO METHODS
    
    private func startRecording() {
        
        audioButton.setBackgroundImage(audioButtonRecordingImage, forState: .Normal)
        
        self.audioPath = paths+"/audio\(newWords.count).m4a"
        
        let audioURL = NSURL(fileURLWithPath: self.audioPath!)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordAnimation()
        } catch {
            finishRecording(success: false)
        }
    }
    
    private func finishRecording(success success: Bool) {
        
        audioButton.setBackgroundImage(audioButtonReadyToUseImage, forState: .Normal)
        audioButton.layer.removeAllAnimations()
        
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            hasClue = true
        } else {
            //TODO: notificate the failure somehow
        }
    }
    
    //MARK: - ANIMATIONS
    func slideAnimation() {
        print("fired")
        UIView.animateWithDuration(1,
            //arrow slide to trash
            animations: {
                self.arrow.hidden = false
                self.arrow.frame.origin.x = 0
            },
            //arrow backs to right edge of animationBackgroundView
            completion: { (flag) -> Void in
                self.arrow.hidden = true
                self.arrow.frame.origin.x = self.audioImageImgView.frame.origin.x
                self.arrow.setNeedsDisplay()
            }
        )
    }
    
    //audioButton animation
    private func recordAnimation(){
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
//        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        
        audioButton.layer.addAnimation(pulseAnimation, forKey: nil)

    }
    
    //hide animationBackground view
    private func hideSlideView(){
        self.audioImageImgView.hidden = true
        self.removeAudioView.hidden = true
        self.trashImageImgView.hidden = true
        self.arrow.hidden = true
        self.animationBackgroundView.hidden = true
    }
    
    //shows animationBackground view
    private func showSlideView(){
        self.audioImageImgView.hidden = false
        self.removeAudioView.hidden = false
        self.trashImageImgView.hidden = true
        self.arrow.hidden = true
        self.animationBackgroundView.hidden = true
    }
    
    //hides animationBackground view
    private func hideElementsAfterAnimation(){
        self.trashImageImgView.hidden = true
        self.arrow.hidden = true
        self.animationBackgroundView.hidden = true
    }
    
    //resets animationBackground view
    private func resetAnimationViewPosition(){
        self.animationBackgroundView.frame.origin.x = self.removeAudioView.frame.width
        self.animationBackgroundView.frame.size.width = 0
        
        self.audioImageImgView.frame.origin.x = self.removeAudioView.frame.width - self.audioImageImgView.frame.width
    }
    
    //MARK: - FILE MANAGER RELATED METHODS
    //MARK: HARRY-TODO: DO NOT SAVE DEFAULT IMAGE
    //saves an image
    private func saveImage(image: UIImage, atPath: String) {
        
        let imageData: NSData = UIImagePNGRepresentation(image)!
        
        aFileManager.createFileAtPath(atPath, contents: imageData, attributes: nil)
    }
    
    private func overwriteGame(aGame: Game) {
        let overwriteAlert = UIAlertController(title: "Sobreescrever jogo?", message: "Já existe um jogo salvo com o nome \(aGame.name).\nDeseja sobreescrevê-lo?", preferredStyle: UIAlertControllerStyle.Alert)
        
        overwriteAlert.addAction(UIAlertAction(title: "SIM", style: UIAlertActionStyle.Default, handler: {_ in
            GameServices.overwriteGame(aGame)
            self.performSegueWithIdentifier("GenerateCrossword", sender: nil)
        }))
        
        overwriteAlert.addAction(UIAlertAction(title: "NÃO", style: UIAlertActionStyle.Default, handler: {_ in
            self.saveGame(self)
        }))
        
        self.presentViewController(overwriteAlert, animated: true, completion: nil)
    }
    
    // MARK: - DELEGATES AND DATASOURCES METHDOS
    // MARK: UIImagePickerControllerDelegate Methods

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //Image treatment
        if mediaType.isEqual(kUTTypeImage as String) {
            
            var image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let orientation = image.imageOrientation
            
            //clip image to an square, if its possible
            if (image.CGImage != nil){
                
                var aRect: CGRect
                if (image.size.height > image.size.width){
                    aRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
                } else {
                    aRect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.height)
                }
                
                image = UIImage(CGImage: CGImageCreateWithImageInRect(image.CGImage, aRect)!)
            }
            
            //rotate image
            switch(orientation){
                case .Down:
                    image = rotateImage(image, degrees: 180)
                case .Left:
                    image = rotateImage(image, degrees: -90)
                case .Right:
                    image = rotateImage(image, degrees: 90)
                default:
                    image = rotateImage(image, degrees: 0)
            }
            
            //update crossword creation variables
            newImageImgView.image = image
            hasClue = true
            
            // Show hidden elements (image view and new word text field)
            //showElements()
            
            // persist media in library, if it's a new media
            if (newMedia == true) {
                
                let photoRoll = PHPhotoLibrary.sharedPhotoLibrary()
                
                photoRoll.performChanges({
                    let request = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
                    self.imageID = request.placeholderForCreatedAsset?.localIdentifier
                    },
                    completionHandler: { (succes, error) -> () in
                        if !succes {
                            self.imageID = nil
                        }
                    }
                )
            }
            else {
                let results = PHAsset.fetchAssetsWithALAssetURLs([info[UIImagePickerControllerReferenceURL] as! NSURL], options: nil)
                let asset = results.firstObject as! PHAsset
                
                imageID = asset.localIdentifier
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
    
        if error != nil {
        
            let alert = UIAlertController(
                title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
        
            let cancelAction = UIAlertAction(
                title: "OK",
                style: .Cancel,
                handler: nil)
        
            alert.addAction(cancelAction)
        
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //auxiliar function to pickerView Delegate
    
    private func rotateImage(image: UIImage, degrees: Float) -> UIImage {
        
        let rads = Float(M_PI) * degrees / 180
        let newSide = max(image.size.width, image.size.height)
        let size = CGSize(width: newSide, height: newSide)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextTranslateCTM(context, newSide/2, newSide/2)
        CGContextRotateCTM(context, CGFloat(rads))
        CGContextScaleCTM(context, 1, -1) //Gambiarra to fix the image flip around the context's X axis
        
        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRect(x: -image.size.width/2, y: -image.size.height/2, width: size.width, height: size.height), image.CGImage!)
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output
    }
    
    //MARK: AVaudioRecorder Delegate

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
        
        if ((newImageImgView.image == nil) || (newImageImgView.image == defaultImage)){
            newImageImgView.image = audioImage
        }
        
        showSlideView()
    }

    //MARK: Collection View Delegate and Datasource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 6
        return newWords.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell: NewWordCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! NewWordCollectionViewCell
        
        if indexPath.row < newWords.count {
            
            //get source object in datasource array
            let aWord = newWords[indexPath.row]
            
            //set cell's back-end properties
            cell.wordAndClue = aWord
            cell.index = indexPath.row
            cell.delegate = self
            
            //set cell's front-end properties
            let wordLabel = aWord.word as NSString
            
            //Limits the length of the word when show in label
            //Just if it has an audio
            if (wordLabel.length > 0 && aWord.clue.audioPath != nil) {
                var wordLabelCut = wordLabel.substringWithRange(NSRange(location: 0, length: wordLabel.length > 9 ? 9 : wordLabel.length))
                
                if (wordLabel.length > 9) {
                    wordLabelCut = wordLabelCut + ("...")
                }
                cell.labelCell.text = wordLabelCut
            } else {
                cell.labelCell.text = wordLabel as String
            }
            
            if (aWord.clue.audioPath != nil){
                cell.audioIcon.hidden = false
            }else{
                cell.audioIcon.hidden = true
            }
            
            if aWord.clue.imageID != nil {

                
                let results = PHAsset.fetchAssetsWithLocalIdentifiers([aWord.clue.imageID!], options: nil)
                
                PHImageManager.defaultManager().requestImageForAsset(results.firstObject as! PHAsset, targetSize: CGSize(width: 1024,height: 1024), contentMode: .AspectFit, options: nil, resultHandler:
                    { (image, _) -> Void in
                    
                        cell.imageCell.image = image
                    }
                )
            }
            else {
                if audioPath != nil {
                    cell.imageCell.image = audioImage
                }
                else {
                    cell.imageCell.image = defaultImage
                }
            }
            
            cell.labelCell.hidden = false
            cell.deleteButton.hidden = false
        }
        
        //not called when collection view is setted to only create cells for added words
        else {
            cell.labelCell.hidden = true
            cell.deleteButton.hidden = true
            cell.imageCell.image = defaultImage
        }
        
        return cell
    }
    
    //auxiliar methods called by NewWordCollectionViewCell
    
    func cellAlert(index: Int) {
        
        let alertController = UIAlertController(
            title: "",
            message: "Deseja apagar essa palavra?",
            preferredStyle: .Alert
        )
        
        let cancelAction = UIAlertAction(
            title: "Não",
            style: UIAlertActionStyle.Default
        ) { (action) in
        }

        
        let confirmAction = UIAlertAction(
            title: "Sim",
            style: UIAlertActionStyle.Default
        ) { (action) in
            self.removeCell(index)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    func removeCell(index: Int){
        newWords.removeAtIndex(index)
        
        wordsAddedCollectionView.reloadData()
        
        //re-enable buttons, if they were unenabled
        if newWords.count == 5 {
            
            wordsLimitReached = false
            takePhotoButton.enabled = true
            cameraRollButton.enabled = true
            audioButton.enabled = true
        }
        
        if newWords.count == 0 {
            generateButton.enabled = false
            lowerContainer.hidden = true
        }
    }

    
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let text = textField.text {
            hasWord = (text.characters.count > 0)
        } else {
            hasWord = false
        }
    }
    
    // Selector for keyboardWillShow
    func keyboardWillShow(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight: CGFloat = keyboardSize.height
        let collectionViewHeight = wordsAddedCollectionView.frame.height
        
        if (!isKeyboardLifted) {
            self.isKeyboardLifted = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.view.frame = CGRectMake(0, (self.view.frame.origin.y - keyboardHeight + collectionViewHeight), self.view.bounds.width, self.view.bounds.height)
                }, completion: nil)
        }
    }
    
    // Selector for keyboardWillHide
    func keyboardWillHide(notification: NSNotification) {
        let info: NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight: CGFloat = keyboardSize.height
        let collectionViewHeight = wordsAddedCollectionView.frame.height
        
        if (isKeyboardLifted) {
            self.isKeyboardLifted = false
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.view.frame = CGRectMake(0, (self.view.frame.origin.y + keyboardHeight - collectionViewHeight), self.view.bounds.width, self.view.bounds.height)
                }, completion: nil)
        }
    }
    
    // Selector for UIGesture
    func dismissKeyboard() {
        self.newWordTxtField.endEditing(true)
    }
    
    //used by save game alert
    //Hide keyboard with return key
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // MARK: - NAVIGATION
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //MARK: HARRY-TODO: ACTIVITY INDICATOR
        
        if (segue.identifier == "GenerateCrossword" && newWords.count > 0) {
            
            //moves audio files to a word related URL
            for word in newWords {
                if word.clue.audioPath != nil {
                    
                    let audioData = NSData(contentsOfURL: NSURL(fileURLWithPath: word.clue.audioPath!))
                    let newPath = "\(paths)/audio\(word.word).m4a"
                    
                    audioData!.writeToURL(NSURL(fileURLWithPath: newPath), atomically: true)
                    word.clue.audioPath = newPath

                }
            }
            
            // I dont know why cols and rows are interchanged... will not fix it right now
            let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: newWords)
            aGenerator.computeCrossword(3, spins: 4)
            
            //atribute it to GamePlayViewController
            (segue.destinationViewController as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destinationViewController as! GamePlayViewController).words = aGenerator.currentWordlist
            
            //resets createCrosswordViewController
            
            //clues variables and its flags reset
            self.recordingSession = nil
            self.audioRecorder = nil
            self.audioPath = nil
            
            self.newMedia = false
            self.imageID = nil
            self.newImageImgView.image = defaultImage
            
            self.hasClue = false
            
            self.newWordTxtField.text = ""
            self.hasWord = false
            
            self.newWords = []
            self.wordsLimitReached = false
            
            /* None of this is necessary
            //buttons reset
            self.addButton.backgroundColor = UIColor.greenPalete().colorWithAlphaComponent(CGFloat(0.5))
            self.addButton.userInteractionEnabled = false
            self.takePhotoButton.enabled = true
            self.cameraRollButton.enabled = true
            self.audioButton.enabled = true
            */
            
            //collectionView reset
            self.wordsAddedCollectionView.reloadData()
            self.lowerContainer.hidden = true
            
        }
    }
}

//MARK: - UIPICKERVIEWCONTROLLER EXTENSION
// allows the UIPickerViewController stay landscape, but not make the orientation be landscape
// only works if Portrait are enaabled in the project
extension UIImagePickerController
{
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
}