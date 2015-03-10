//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Issac Rosa on 3/5/15.
//  Copyright (c) 2015 IARBizGroup. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    let filePathUrl: NSURL!
    let title: String!
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
