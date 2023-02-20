//
//  HomeSection.swift
//  HMOA_iOS
//
//  Created by 임현규 on 2023/02/20.
//

import UIKit
import RxDataSources

struct HomeSection {
    
    typealias Model = SectionModel<Section, Item>
  
    enum Section: Equatable {
        case homeTop
        case homeFirst
        case homeSecond
        case homeWatch
    }
  
    enum Item: Equatable {
        case Info(Perfume)
        case photo(UIImage?)
    }
}

