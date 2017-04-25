//
//  TutorialCurrentPageVC.swift
//  LinguaDeGato
//
//  Created by Jheniffer Jordao Leonardi on 2/5/16.
//  Copyright © 2016 Kobayashi. All rights reserved.
//

import UIKit

class TutorialCurrentPageVC: UIViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageImages: NSArray!
    
    //MARK: BUTTONS
    
    @IBAction func SkipTutorial(_ sender: Any) {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tutorialTitlePage1 = NSLocalizedString("TutorialCurrentPageVC.title1", value: "Start creating a game...", comment: "Title that will appear on the first page of the tutorial")
        let tutorialTitlePage2 = NSLocalizedString("TutorialCurrentPageVC.title2", value: "And add new words", comment: "Title that will appear on the second page of the tutorial")
        let tutorialTitlePage8 = NSLocalizedString("TutorialCurrentPageVC.title8", value: "Have fun!", comment: "Title that will appear on the eighth page of the tutorial")
        
        self.pageTitles = NSArray(objects: tutorialTitlePage1, tutorialTitlePage2, "", "", "", "", "", tutorialTitlePage8)
        self.pageImages = NSArray(objects: "tutorialPage1", "tutorialPage2", "tutorialPage3", "tutorialPage4", "tutorialPage5", "tutorialPage6", "tutorialPage7", "tutorialPage8")
        
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as TutorialContentViewController
        let viewControllers = NSArray(objects: startVC)
        
        self.pageViewController.setViewControllers((viewControllers as! [UIViewController]), direction: .forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 30, width: self.view.frame.width, height: self.view.frame.size.height - 100)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(_ index: Int) -> TutorialContentViewController {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return TutorialContentViewController()
        }
        
        let aViewController: TutorialContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialContentViewController") as! TutorialContentViewController
        
        aViewController.imageFile = self.pageImages[index]as! String
        aViewController.titleText = self.pageTitles[index]as! String
        aViewController.pageIndex = index
        
        return aViewController
    }
    
    // MARK: Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let aViewController = viewController as! TutorialContentViewController
        var index = aViewController.pageIndex as Int
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let aViewController = viewController as! TutorialContentViewController
        var index = aViewController.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index += 1
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
