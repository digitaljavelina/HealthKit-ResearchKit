//
//  ResultParser.swift
//  Karenina
//
//  Created by Matt Luedke on 10/6/15.
//  Copyright © 2015 Razeware. All rights reserved.
//

import Foundation
import ResearchKit

struct ResultParser {
  
  static func findWalkHeartFiles(result: ORKTaskResult) -> [NSURL] {
    
    var urls = [NSURL]()
    
    if let results = result.results
      where results.count > 4,
      let walkResult = results[3] as? ORKStepResult,
      let restResult = results[4] as? ORKStepResult {
        
        for result in walkResult.results! {
          
          if let result = result as? ORKFileResult,
            let fileUrl = result.fileURL {
              
              urls.append(fileUrl)
          }
        }
        
        for result in restResult.results! {
          
          if let result = result as? ORKFileResult,
            let fileUrl = result.fileURL {
              
              urls.append(fileUrl)
          }
        }
    }
    
    return urls
  }
}
