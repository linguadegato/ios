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
    @IBOutlet weak var saveGameButton: UIButton!
    @IBOutlet weak var removeNewClueButton: UIButton!
    
    
    //MARK: Views
    @IBOutlet weak var newImageImgView: UIImageView!
    @IBOutlet weak var newWordTxtField: UITextField!
    @IBOutlet weak var wordsAddedCollectionView: UICollectionView!
    @IBOutlet weak var lowerContainer: UIView!
    @IBOutlet weak var audioImageView: UIImageView!
    
    //MARK: Colors and apearance
    
    //Images
    
    // - New image
    fileprivate let defaultImage = UIImage(named: "imageDefault")
    fileprivate let audioImage = UIImage(named: "imageDefaultAudio")
    
    // - Audio Button to delete record
    fileprivate let audioButtonReadyToUseImage = (UIImage(named: "btnAudio"))
    fileprivate let audioButtonRecordingImage = (UIImage(named: "btnAudioRed"))
    
    // - Add new clue
    fileprivate let addButtonImageOn = (UIImage(named: "iconAddWord"))
    
    //textField
    fileprivate let textFieldBorderColor = UIColor.bluePalete().cgColor
    fileprivate let textFieldBorderWidth: CGFloat = 1.0
    fileprivate let textFieldBorderRadius : CGFloat = 1.0

    //newImageImgView
    fileprivate let newImageBorderColor = UIColor.bluePalete().cgColor
    fileprivate let newImageBorderWidth: CGFloat = 1.0
    
    //slide view
    fileprivate let audioImageBorderRadius : CGFloat = 30.0

    //mute button images
//    fileprivate let muteMusicOnImage = UIImage(named: "btnMuteMusicOnLightBlue")
//    fileprivate let muteMusicOffImage = UIImage(named: "btnMuteMusicOffLightBlue")
    
    //MARK: Keyboard variable
    fileprivate var isKeyboardLifted: Bool = false
    
    
    //MARK: Crossword Creation related variables
    fileprivate var gameName: String!
    fileprivate var newMedia: Bool?
    
    fileprivate var hasClue = false {
        didSet {
            setAddButtonState()
            removeNewClueButton.isHidden = !hasClue
        }
    }
    fileprivate var hasWord = false {
        didSet {
            setAddButtonState()
        }
    }
    
    fileprivate var wordsLimitReached = false {
        didSet {
            setAddButtonState()
        }
    }
    
    fileprivate var newWords: [WordAndClue] = []
    
    //MARK: File related variables
    fileprivate let aFileManager = FileManager.default
    fileprivate let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    //path of the image in newImageImgView
    fileprivate var imageID: String?
    
    // Audio session to manage recording and an audio recorder to handle the actual reading and saving of data
    var recordingAudio: Bool = false
    fileprivate var recordingSession: AVAudioSession!
    fileprivate var audioRecorder: AVAudioRecorder!
    fileprivate var audioPath: String?
    fileprivate var audio: AVAudioPlayer!

    // back button
    fileprivate var backButton : UIBarButtonItem!

    let limitLength = BoardView.maxSquaresInCol
    
    // Last saved game name
    fileprivate var savedGameName : String = ""
    
    //MARK: - VIEW LIFECYCLE METHODS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //used to limiting the number of characters
        newWordTxtField.delegate = self
        newWordTxtField.autocorrectionType = .no
        
        // Disable the swipe to make sure you get your chance to save
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //MARK: appearance settings
        
        lowerContainer.isHidden = true
        
        newWordTxtField.layer.borderColor = textFieldBorderColor
        newWordTxtField.layer.borderWidth = textFieldBorderWidth
        newWordTxtField.layer.cornerRadius = textFieldBorderRadius
        
        audioButton.setBackgroundImage(audioButtonReadyToUseImage, for: UIControlState())
        audioButton.setBackgroundImage(audioButtonRecordingImage, for: .highlighted)
        
        newImageImgView.layer.borderColor = newImageBorderColor
        newImageImgView.layer.borderWidth = newImageBorderWidth
        
        audioImageView.layer.cornerRadius = audioImageBorderRadius

        addButton.setImage(addButtonImageOn, for: UIControlState())
        addButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        setAddButtonState()
        
        removeNewClueButton.isHidden = true
        
        //MARK: interaction settings
        
        self.recordingAudio = false
        
        //buttons
        generateButton.isEnabled = false
        addButton.backgroundColor = UIColor.greenPalete().withAlphaComponent(CGFloat(0.5))
        addButton.isUserInteractionEnabled = false
        
        //MARK: Set gesture recognizers
        //gesture recognizer to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateCrosswordViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        //gesture recognizers in main image
        newImageImgView.isUserInteractionEnabled = true
        newImageImgView.addGestureRecognizer(createGestureTapImageToPlayRecord())
        
        //audio image gesture reconizers
        audioImageView.isUserInteractionEnabled = true
        audioImageView.addGestureRecognizer(createGestureTapImageToPlayRecord())
        
        //MARK: request permission to use microfone
        audioButton.isEnabled = false
        
        recordingSession = AVAudioSession.sharedInstance()
        /*
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)

        } catch {
            //MARK: TODO: [audio] error message
            // failed to record!
        }
        */
        recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
            DispatchQueue.main.async {
                if allowed {
                    // Enable audio button
                    self.audioButton.isEnabled = true
                    
                } else {
                    //MARK: TODO: [audio] error message
                    // failed to record!
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Keyboard:
        super.viewWillAppear(animated)
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(CreateCrosswordViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(CreateCrosswordViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - BUTTON ACTIONS
    
    // MARK: NAVIGATION
    @IBAction func goBackPopup(_ sender: AnyObject) {
        
        if (wordsAddedCollectionView.numberOfItems(inSection: 0) > 0){
            
            let alert = UIAlertController(
                title: NSLocalizedString("createCrossword.GoBackPopup.title", value:"Are you sure you want to go back?", comment:"Ask the user if he wants to go back and cancel the creation of a new game."),
                message: NSLocalizedString("createCrossword.GoBackPopup.message", value:"The new words will be lost.", comment:"Message informing the user that if he returns, he will lose the words added to this new game."),
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("createCrossword.goBackPopup.button.cancel", value:"Cancel", comment:"Button to cancel the action of returning."),
                style: UIAlertActionStyle.cancel,
                handler:nil
            ))
            
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("createCrossword.goBackPopup.button.continue", value:"Go back", comment:"Button to continue the action of returning to home screen and cancel the creation of a new game."),
                style: UIAlertActionStyle.default,
                handler:
                {(UIAlertAction)in
                    self.goBack()                }
                ))
            
            self.present(alert, animated: true, completion: {
            })
            
        }else{
            self.goBack()
        }
    }
    
    fileprivate func goBack(){
        let _ = self.navigationController?.popViewController(animated: true)
        
        // Don't forget to re-enable the interactive gesture
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = true
        
    }

    // MARK: NEW CLUE ELEMENTS
    
    @IBAction func useCamera(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            //add orientation observer
            //NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: "UIDeviceOrientationDidChangeNotification", object: nil)
            
            //instatiate imagePicker
            let imagePicker = UIImagePickerController()
                
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
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
            
            self.present(imagePicker, animated: true, completion: nil)
            
            newMedia = true
        }
    }
    
    @IBAction func useCameraRoll(_ sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = false
        }
    }
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(true)
        }
        
        setAddButtonState()
    }

    // MARK: DELETE NEW WORD AND CLUE ELEMENT
    @IBAction func deleteNewClue(_ sender: AnyObject) {
        
        let deleteNewClueAlert = UIAlertController(
            title: NSLocalizedString("createCrossword.alert.deleteNewClue", value:"Delete this clue?", comment:"Asks if the user wants to delete new clue when he is creating a new game."),
            message: "",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        deleteNewClueAlert.addAction(UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.deleteNewClue.Confirm", value:"Yes", comment:"Respond positively if the user wants to delete new clue."),
            style: UIAlertActionStyle.default,
            handler: {_ in
                self.clearNewClue()
            }
        ))
        
        deleteNewClueAlert.addAction(UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.deleteNewClue.Cancel", value:"No", comment:"Respond negatively if the user wants to delete new clue."),
            style: UIAlertActionStyle.cancel,
            handler: {_ in
            }
        ))
        
        self.present(deleteNewClueAlert, animated: true, completion: nil)
    }
    
    fileprivate func clearNewClue(){
        // Clear audio variables
        self.audioPath = nil
        self.audioRecorder = nil
        self.recordingSession = nil
        
        // Clear image variables
        self.newImageImgView.image = self.defaultImage
        self.imageID = nil
        
        // Clear text variable
        self.newWordTxtField.text = ""
        
        // Hide elements
        self.audioImageView.isHidden = true
        self.removeNewClueButton.isHidden = true
        
        self.hasClue = false
    }

    // MARK: ADD NEW CLUE
    @IBAction func addNewWord() {
        
        generateButton.isEnabled = true

        //removing blank spaces
        let txtNewWord = newWordTxtField.text
        let trimmedNewWordTxtField = txtNewWord!.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if !(trimmedNewWordTxtField.characters.count > limitLength) {
            
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
            self.audioImageView.isHidden = true
            newImageImgView.image = defaultImage
            hasClue = false
            self.newWordTxtField.text = ""
            hasWord = false
            removeNewClueButton.isHidden = true
            dismissKeyboard()
            

            if newWords.count >= 6 {
                wordsLimitReached = true
                takePhotoButton.isEnabled = false
                cameraRollButton.isEnabled = false
                audioButton.isEnabled = false
            }
            
            disableSaveButton(false)
            
            // Show lower container (collection view and play button)
            lowerContainer.isHidden = false
        }
    }
    
    // MARK: COLLECTION VIEW BUTTONS (PLAY AND SAVE)
    @IBAction func playGame(_ sender: AnyObject) {
        if hasClue {
            let alert = UIAlertController(
                title: NSLocalizedString("createCrossword.btnPlayGame.alert.title", value:"You didn't finish adding the clue", comment:"This is the alert title when the user is craeting a new game, click on Play button and there is a new clue to be added in the game."),
                message: NSLocalizedString("createCrossword.btnPlayGame.alert.message", value:"The new clue will not be added in the game", comment:"This is the alert message when the user is craeting a new game, click on Play button and there is a new clue to be added in the game."),
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("createCrossword.btnPlayGame.alert.btnCancel", value:"Cancel",comment:"Continue the insertion of the new clue."),
                style: .cancel,
                handler: nil
            ))
            
            alert.addAction(UIAlertAction(
                title: NSLocalizedString("createCrossword.btnPlayGame.alert.btnContinue", value:"Play anyway", comment:"Alert answer to go to game even if it will cancel the insertion of a new clue to the new game."),
                style: .default,
                handler: { _ in
                    self.performSegue(withIdentifier: "GenerateCrossword", sender: self)
            }
            ))

            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            self.performSegue(withIdentifier: "GenerateCrossword", sender: self)
        }
    }
    
    @IBAction func saveGame(_ sender: AnyObject) {
        
        if (self.savedGameName.isEmpty){
            
            let saveAlert = UIAlertController(
                title: NSLocalizedString("createCrossword.btnSaveGame.alert.title", value:"Give a name for this game:", comment: "Alert that appears when the user wants to save a new game and asks the user to give a name for this game."),
                message: "",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            saveAlert.addTextField(configurationHandler: { alertTextField in
                alertTextField.placeholder = NSLocalizedString("createCrossword.btnSaveGame.alert.placeholderToNewGameNameTxtField", value: "Name of the game", comment: "Default text that will appear on the game name text field during alert popup when the user is saving a new game")
            })
            
            let alertTextField = saveAlert.textFields![0]
            
            alertTextField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
            
            saveAlert.addAction(UIAlertAction(
                title: NSLocalizedString("createCrossword.btnSaveGame.alert.btnCancel", value:"Cancel", comment:"Cancel the action of saving the new game"),
                style: UIAlertActionStyle.cancel,
                handler:nil
            ))
            
            saveAlert.addAction(UIAlertAction(
                title: NSLocalizedString("createCrossword.btnSaveGame.alert.btnSave", value:"Save", comment:"Go to action and save the new game"),
                style: UIAlertActionStyle.default,
                handler:{ _ in
                
                    if alertTextField.text != nil && alertTextField.text!.characters.count > 0 {
                        
                        self.savedGameName = alertTextField.text!
                        let newGame = Game(gameName: self.savedGameName, wordsAndClue: self.newWords)
                        
                        let indicator = LGStandarts.standartLGActivityIndicator(self.view)
                        
                        self.view.addSubview(indicator)
                        indicator.startAnimating()
                        
                        GameServices.saveGame(newGame, completion: {success in
                            
                            OperationQueue.main.addOperation(BlockOperation(block: {
                                indicator.removeFromSuperview()
                                if success {
                                    self.savedGameAlert()
                                    self.disableSaveButton(true)
                                }
                                else{
                                    self.overwriteGame(newGame)
                                }
                            }))
                        })

                    }
                    else {
                        print("empty text field!")
                    }
                }
            ))
            
            self.present(saveAlert, animated: true, completion: {
            })
            
        }
        else{
            let newGame = Game(gameName: self.savedGameName, wordsAndClue: self.newWords)
            
            let indicator = LGStandarts.standartLGActivityIndicator(self.view)
            self.view.addSubview(indicator)
            
            indicator.startAnimating()
            GameServices.overwriteGame(newGame, completion: {
                OperationQueue.main.addOperation(BlockOperation(block: {
                    indicator.removeFromSuperview()
                    self.savedGameAlert()
                }))
            })
            self.disableSaveButton(true)
        }
    }
    
    // MARK: - ALERTS
    fileprivate func savedGameAlert(){
        let savedGame = UIAlertController(
            title: NSLocalizedString("createCrossword.alert.gameSaved.title", value: "Game saved successfully",  comment: "Short message informing that the game was saved successfully."),
            message: "",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        savedGame.addAction(UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.gameSaved.ok", value: "Ok",  comment: "Ok and close popup."),
            style: UIAlertActionStyle.cancel,
            handler: nil)
        )
        
        self.present(savedGame, animated: true, completion: {
        })
    }
    
    fileprivate func overwriteGame(_ aGame: Game) {
        
        let overwriteAlert = UIAlertController(
            title: NSLocalizedString("createCrossword.alert.overwriteGame.title", value:"Overwrite game?", comment: "Short message asking the user if he wants to overwrite a game."),
            message: NSLocalizedString("createCrossword.alert.overwriteGame.message", value:"You already have a game named \(aGame.name). Do you want to overwrite it?", comment: "Message informing the user that there is a game saved with the same name and asking if he whants to save the game anyway and overwrite the other game."),
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        overwriteAlert.addAction(UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.overwriteGame.yes", value:"Yes", comment: "Responds positively to the question whether the user wants to overwrite the game that has the same name and continue the action of saving the new game."),
            style: UIAlertActionStyle.default,
            handler: {_ in
                let indicator = LGStandarts.standartLGActivityIndicator(self.view)
                self.view.addSubview(indicator)
                
                indicator.startAnimating()
                GameServices.overwriteGame(aGame, completion: {
                    OperationQueue.main.addOperation(BlockOperation{
                        indicator.removeFromSuperview()
                        self.savedGameAlert()
                    })
                })
                self.disableSaveButton(true)
        }
        ))
        
        overwriteAlert.addAction(UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.overwriteGame.no", value:"No", comment: "Responds negatively to the question whether the user wants to overwrite the game and cancel the action of saving the new game."),
            style: UIAlertActionStyle.cancel,
            handler: {_ in
//                self.saveGame(self)
                self.savedGameName = ""
                self.disableSaveButton(false)
            }
        ))
        
        self.present(overwriteAlert, animated: true, completion: nil)
    }
    
    func cellAlert(_ index: Int) {
        
        let alertController = UIAlertController(
            title: "",
            message: NSLocalizedString("createCrossword.alert.removeClueMessage", value: "Do you want to delete this word?", comment: "Asks the user if he wants to delete a clue from the new game."),
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.removeClue.cancelAction", value: "Cancel", comment: "Cancel action"),
            style: UIAlertActionStyle.default
        ) { (action) in }
        
        
        let confirmAction = UIAlertAction(
            title: NSLocalizedString("createCrossword.alert.removeClue.confirmAction", value: "Delete", comment: "Continue action and delete the clue from the new game"),
            style: UIAlertActionStyle.destructive
        ) { (action) in
                self.removeCell(index)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - BUTTONS STATES
    
    // Disable addButton if there's no clue, or no word, or if there's already 6 words
    fileprivate func setAddButtonState() {
        if hasClue && hasWord && !wordsLimitReached && (recordingAudio == false){
            addButton.backgroundColor = UIColor.greenPalete().withAlphaComponent(CGFloat(1))
            addButton.isUserInteractionEnabled = true
        } else {
            addButton.backgroundColor = UIColor.greenPalete().withAlphaComponent(CGFloat(0.5))
            addButton.isUserInteractionEnabled = false
        }
    }
    
    fileprivate func disableSaveButton(_ disable: Bool){
        OperationQueue.main.addOperation {
            if disable {
                self.saveGameButton.alpha = 0.5
                self.saveGameButton.isUserInteractionEnabled = false
            } else {
                self.saveGameButton.alpha = 1
                self.saveGameButton.isUserInteractionEnabled = true
            }
        }
    }
    
    //MARK: - GESTURE RECOGNIZERS
    
    // MARK: GENERATORS
    fileprivate func createGestureTapImageToPlayRecord() -> UITapGestureRecognizer{
        let tapGesture = UITapGestureRecognizer(target:self, action:#selector(CreateCrosswordViewController.tapAndPlayRecord(_:)))
        
        return tapGesture
    }
    
    //MARK: ACTIONS
    func tapAndPlayRecord(_ sender: UITapGestureRecognizer){
        
        if self.audioPath != nil {
            do {
                try self.audio = AVAudioPlayer(contentsOf: AudioFilesManager.URLForAudioWithFileName(audioPath!))
            } catch {
                //MARK: TODO: [audio] error message
            }
            
            if self.audio != nil {
                AudioCluePlayer.playAudio(audio)
            }
        }
    }
    
    // MARK: - RECORD AUDIO METHODS
    fileprivate func startRecording() {
        
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        }
        catch{
            //error handling
        }
        
        self.recordingAudio = true
        audioButton.setBackgroundImage(audioButtonRecordingImage, for: UIControlState())
        
        //MARK: this is a fragile line, and can cause bugs
        //user will never get to save the words "audio0" ,"audio1", "audio2", "audio3",
        //"audio4" and "audio5".
        //we can fix by macGayverism or implment an EasterEgg.
        
        self.audioPath = "audio\(newWords.count)"
        let audioURL = AudioFilesManager.URLForAudioWithFileName("audio\(newWords.count)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordAnimation()
        } catch {
            finishRecording(false)
        }
    }
    
    func finishRecording(_ success: Bool) {
        
        self.audioRecorder.stop()
        
        do{
            try AVAudioSession.sharedInstance().setActive(false, with: AVAudioSessionSetActiveOptions.notifyOthersOnDeactivation)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            //error handling
        }
        
        self.audioRecorder = nil
        self.recordingAudio = false
        
        audioButton.setBackgroundImage(audioButtonReadyToUseImage, for: UIControlState())
        audioButton.layer.removeAllAnimations()
        audioImageView.layer.removeAllAnimations()
        
        
        if success {
            hasClue = true
            
            if ((newImageImgView.image == nil) || (newImageImgView.image == defaultImage)){
                newImageImgView.image = audioImage
            }
            self.audioImageView.isHidden = false
            
        } else {
            //TODO: notificate the failure somehow
            audioPath = nil
            self.audioImageView.isHidden = true
            
            if ((newImageImgView.image == nil) || (newImageImgView.image == audioImage)){
                newImageImgView.image = defaultImage
                removeNewClueButton.isHidden = true
            }
        }

    }
    
    // MARK: RECORD AUDIO ANIMATION
    fileprivate func recordAnimation(){
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        
        audioButton.layer.add(pulseAnimation, forKey: nil)

        self.audioImageView.isHidden = false
        self.audioImageView.layer.add(pulseAnimation, forKey: nil)

    }
    
    //MARK: - FILE MANAGER RELATED METHODS
    //MARK: HARRY-TODO: DO NOT SAVE DEFAULT IMAGE
    //saves an image
    fileprivate func saveImage(_ image: UIImage, atPath: String) {
        
        let imageData: Data = UIImagePNGRepresentation(image)!
        
        aFileManager.createFile(atPath: atPath, contents: imageData, attributes: nil)
    }
    
    // MARK: - DELEGATES AND DATASOURCES METHDOS
    
    // MARK: UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        self.dismiss(animated: true, completion: nil)
        
        //Image treatment
        if mediaType.isEqual(kUTTypeImage as String) {
            
            var image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            let orientation = image.imageOrientation
            
            //clip image to an square, if its possible
            if (image.cgImage != nil){
                
                var aRect: CGRect
                if (image.size.height > image.size.width){
                    aRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.width)
                } else {
                    aRect = CGRect(x: 0, y: 0, width: image.size.height, height: image.size.height)
                }
                
                image = UIImage(cgImage: (image.cgImage?.cropping(to: aRect)!)!)
            }
            
            //rotate image
            switch(orientation){
                case .down:
                    image = rotateImage(image, degrees: 180)
                case .left:
                    image = rotateImage(image, degrees: -90)
                case .right:
                    image = rotateImage(image, degrees: 90)
                default:
                    image = rotateImage(image, degrees: 0)
            }
            
            //update crossword creation variables
            newImageImgView.image = image
            hasClue = true
            
            // Show delete button
            removeNewClueButton.isHidden = false
            
            // persist media in library, if it's a new media
            if (newMedia == true) {
                
                let photoRoll = PHPhotoLibrary.shared()
                
                photoRoll.performChanges({
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
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
                let results = PHAsset.fetchAssets(withALAssetURLs: [info[UIImagePickerControllerReferenceURL] as! URL], options: nil)
                let asset = results.firstObject!
                
                imageID = asset.localIdentifier
            }
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSErrorPointer?, contextInfo:UnsafeRawPointer) {
    
        if error != nil {
        
            let alert = UIAlertController(
                title: NSLocalizedString("createCrossword.alert.errorSavingGame.title", value:"Game not saved", comment: "Short messagem informing that there was a problem and the game was not saved"),
                message: NSLocalizedString("createCrossword.alert.errorSavingGame.message", value:"Sorry, there as an error. Please, contact us.", comment: "Messagem informing that there was a problem and saing the user to contact us"),
                preferredStyle: UIAlertControllerStyle.alert)
        
            let cancelAction = UIAlertAction(
                title: NSLocalizedString("createCrossword.alert.errorSavingGame.bntOk", value:"Ok", comment:"Button to close error message popup"),
                style: .cancel,
                handler: nil)
        
            alert.addAction(cancelAction)
        
            self.present(alert, animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //auxiliar function to pickerView Delegate
    
    fileprivate func rotateImage(_ image: UIImage, degrees: Float) -> UIImage {
        
        let rads = Float(Double.pi) * degrees / 180
        let newSide = max(image.size.width, image.size.height)
        let size = CGSize(width: newSide, height: newSide)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.translateBy(x: newSide/2, y: newSide/2)
        context?.rotate(by: CGFloat(rads))
        context?.scaleBy(x: 1, y: -1) //Gambiarra to fix the image flip around the context's X axis
        
        UIGraphicsGetCurrentContext()?.draw(image.cgImage!, in: CGRect(x: -image.size.width/2, y: -image.size.height/2, width: size.width, height: size.height))
        
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return output!
    }
    
    //MARK: AVaudioRecorder Delegate

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(false)
        }
    }

    //MARK: Collection View Delegate and Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 6
        return newWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NewWordCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! NewWordCollectionViewCell
        
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
                var wordLabelCut = wordLabel.substring(with: NSRange(location: 0, length: wordLabel.length > 9 ? 9 : wordLabel.length))
                
                if (wordLabel.length > 9) {
                    wordLabelCut = wordLabelCut + ("...")
                }
                cell.labelCell.text = wordLabelCut
            } else {
                cell.labelCell.text = wordLabel as String
            }
            
            if (aWord.clue.audioPath != nil){
                cell.audioIcon.isHidden = false
            }else{
                cell.audioIcon.isHidden = true
            }
            
            if aWord.clue.imageID != nil {

                
                let results = PHAsset.fetchAssets(withLocalIdentifiers: [aWord.clue.imageID!], options: nil)
                
                PHImageManager.default().requestImage(for: results.firstObject!, targetSize: CGSize(width: 1024,height: 1024), contentMode: .aspectFit, options: nil, resultHandler:
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
            
            cell.labelCell.isHidden = false
            cell.deleteButton.isHidden = false
        }
        
        //not called when collection view is setted to only create cells for added words
        else {
            cell.labelCell.isHidden = true
            cell.deleteButton.isHidden = true
            cell.imageCell.image = defaultImage
        }
        
        return cell
    }
    
    //auxiliar methods called by NewWordCollectionViewCell
    func removeCell(_ index: Int){
        newWords.remove(at: index)
        
        wordsAddedCollectionView.reloadData()
        
        //re-enable buttons, if they were unenabled
        disableSaveButton(false)
        
        if newWords.count == 5 {
            
            wordsLimitReached = false
            takePhotoButton.isEnabled = true
            cameraRollButton.isEnabled = true
            audioButton.isEnabled = true
        }
        
        if newWords.count == 0 {
            generateButton.isEnabled = false
            lowerContainer.isHidden = true
        }
    }

    
    //MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //limits the characters in newWordTxtField
        if (textField === self.newWordTxtField) {
            guard let text = textField.text else { return true }
            
            //if user presses backspace
            if (string == ""){
                textField.deleteBackward()
            }
            
            //insert captlized text if it's within limitLenght
            let newLength = text.characters.count + string.characters.count - range.length
            if (newLength <= limitLength) {
                textField.insertText(string.capitalized)
            }
            
            hasWord = (text.characters.count > 0)
        }
        
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            hasWord = (text.characters.count > 0)
        } else {
            hasWord = false
        }
    }
    
    // Selector for keyboardWillShow
    func keyboardWillShow(_ notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height
        let collectionViewHeight = wordsAddedCollectionView.frame.height
        
        if (!isKeyboardLifted) {
            self.isKeyboardLifted = true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: (self.view.frame.origin.y - keyboardHeight + collectionViewHeight), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
        }
    }
    
    // Selector for keyboardWillHide
    func keyboardWillHide(_ notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardHeight: CGFloat = keyboardSize.height
        let collectionViewHeight = wordsAddedCollectionView.frame.height
        
        if (isKeyboardLifted) {
            self.isKeyboardLifted = false
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = CGRect(x: 0, y: (self.view.frame.origin.y + keyboardHeight - collectionViewHeight), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
        }
    }
    
    // Selector for UIGesture
    func dismissKeyboard() {
        self.newWordTxtField.endEditing(true)
    }
    
    //used by save game alert
    //Hide keyboard with return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // MARK: - NAVIGATION
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "GenerateCrossword" && newWords.count > 0) {
            
            //Generate Crossword
            
            let indicator = LGStandarts.standartLGActivityIndicator(self.view)
            self.view.addSubview(indicator)
            
            indicator.startAnimating()
            
            let aGenerator = LGCrosswordGenerator(rows: BoardView.maxSquaresInCol, cols: BoardView.maxSquaresinRow, maxloops: 2000, avaiableWords: newWords)
            aGenerator.computeCrossword(3, spins: 6)
            
            //atribute it to GamePlayViewController
            (segue.destination as! GamePlayViewController).crosswordMatrix = aGenerator.grid
            (segue.destination as! GamePlayViewController).words = aGenerator.currentWordlist
            
            indicator.removeFromSuperview()
        }
    
        //resets createCrosswordViewController
        
        //clues variables and its flags reset
        self.recordingSession = nil
        self.audioRecorder = nil
        self.audioPath = nil
        
        self.newMedia = false
        self.imageID = nil
        self.newImageImgView.image = defaultImage
        
        self.hasClue = false
        self.removeNewClueButton.isHidden = true
        
        self.newWordTxtField.text = ""
        self.hasWord = false
        
        self.newWords = []
        self.wordsLimitReached = false
        
        //collectionView reset
        self.wordsAddedCollectionView.reloadData()
        self.lowerContainer.isHidden = true
    }
}

//MARK: - UIPICKERVIEWCONTROLLER EXTENSION
// allows the UIPickerViewController stay landscape, but not make the orientation be landscape
// only works if Portrait are enaabled in the project
extension UIImagePickerController
{
    open override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
}
