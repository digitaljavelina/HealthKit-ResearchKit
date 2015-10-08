//
//  ViewController.swift
//  Karenina
//
//  Created by Matt Luedke on 5/1/15.
//  Copyright (c) 2015 Razeware. All rights reserved.
//

import AVFoundation
import ResearchKit

class ViewController: UIViewController, ORKTaskViewControllerDelegate {
  
  var audioPlayer: AVAudioPlayer?
  var soundFileURL: NSURL?
  
  @IBAction func consentTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
    taskViewController.delegate = self
    presentViewController(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func surveyTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: SurveyTask(), taskRunUUID: nil)
    taskViewController.delegate = self
    presentViewController(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func microphoneTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: MicrophoneTask, taskRunUUID: nil)
    taskViewController.delegate = self
    taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
    presentViewController(taskViewController, animated: true, completion: nil)
  }
  
  @IBAction func playMostRecentSound(sender: AnyObject) {
    if let soundFileURL = soundFileURL {
      do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: soundFileURL, fileTypeHint: AVFileTypeAppleM4A)
        audioPlayer?.play()
      } catch {}
    }
  }
  
  @IBAction func authorize(sender: AnyObject) {
    HealthKitManager.authorizeHealthKit()
  }
  
  @IBAction func walkTapped(sender : AnyObject) {
    let taskViewController = ORKTaskViewController(task: WalkTask, taskRunUUID: nil)
    taskViewController.delegate = self
    taskViewController.outputDirectory = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0], isDirectory: true)
    presentViewController(taskViewController, animated: true, completion: nil)
    HealthKitManager.startMockHeartData()
  }
  
  func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
    
    HealthKitManager.stopMockHeartData()
    
    if (taskViewController.task?.identifier == "WalkTask"
      && reason == .Completed) {
        
        let heartURLs = ResultParser.findWalkHeartFiles(taskViewController.result)
        
        for url in heartURLs {
          do {
            let string = try NSString.init(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            print(string)
          } catch {}
        }
    }
    
    if (reason != .Failed) {
      taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  func findSoundFile(result: ORKTaskResult) -> NSURL? {
    
    if let results = result.results {
      if results.count > 3 {
        if let stepResult = results[3] as? ORKStepResult, let subResults = stepResult.results, let fileResult = subResults[0] as? ORKFileResult {
          
          return fileResult.fileURL
        }
      }
    }
    
    return nil
  }
}
