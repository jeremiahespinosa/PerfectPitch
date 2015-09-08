//
//  RecordedAudio.swift
//  PerfectPitch
//
//  Created by jeremiah espinosa on 8/31/15.
//  Copyright (c) 2015 Jeremiah Espinosa. All rights reserved.
//

import Foundation

//NSObject is root class for most classes
class RecordedAudio: NSObject{
    
    var filePathUrl : NSURL!;
    var title : String!;
    
    init(filePathUrl:NSURL, title:String) {
        // perform some initialization here
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
