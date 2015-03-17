//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Vikas Varma on 3/17/15.
//  Copyright (c) 2014 Vikas Varma. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    var filePathUrl: NSURL!
    var title: String!
    
    //constructor
    init(url:NSURL!, title:String!){
        
        self.filePathUrl=url
        self.title=title
    }
}
