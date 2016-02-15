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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = NSArray(objects: "TUTORIAL: Criando palavras", "TUTORIAL: Entendendo as dicas", "TUTORIAL: Salvando e iniciando o jogo", "TUTORIAL: Jogando")
        self.pageImages = NSArray(objects: "tutorialPage1", "tutorialPage2", "tutorialPage3", "tutorialPage4")
        
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        
        self.pageViewController.dataSource = self
        
        let startVC = self.viewControllerAtIndex(0) as TutorialContentViewController
        let viewControllers = NSArray(objects: startVC)
        
        self.pageViewController.setViewControllers((viewControllers as! [UIViewController]), direction: .Forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.size.height - 60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // button to go to first page of tutorial:
//    @IBAction func restartAction(sender: AnyObject) {
//        let startVC = self.viewControllerAtIndex(0) as TutorialContentViewController
//        let viewControllers = NSArray(object: startVC)
//        
//        self.pageViewController.setViewControllers((viewControllers as! [UIViewController]), direction: .Forward, animated: true, completion: nil)
//        
//    }
    
    func viewControllerAtIndex(index: Int) -> TutorialContentViewController {
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return TutorialContentViewController()
        }
        
        let aViewController: TutorialContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("TutorialContentViewController") as! TutorialContentViewController
        
        aViewController.imageFile = self.pageImages[index]as! String
        aViewController.titleText = self.pageTitles[index]as! String
        aViewController.pageIndex = index
        
        return aViewController
    }
    
    // MARK: Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let aViewController = viewController as! TutorialContentViewController
        var index = aViewController.pageIndex as Int
        
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let aViewController = viewController as! TutorialContentViewController
        var index = aViewController.pageIndex as Int
        
        if (index == NSNotFound) {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
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
