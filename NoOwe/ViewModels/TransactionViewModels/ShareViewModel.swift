//
//  ShareViewModel.swift
//  NoOwe
//
//  Created by Filip Wicha on 16/12/2019.
//  Copyright © 2019 Filip Wicha. All rights reserved.
//

import Foundation

class ShareViewModel: Identifiable {
    
    var share: Share
    
    init(share: Share){
        self.share = share
    }
    
    var id: Int {
        return self.share.id
    }
    
    var amount: Double {
        return self.share.amount
    }
    
    var memberId: Int {
        return self.share.member_id
    }
    
    var transactionId: Int {
        return self.share.transaction_id
    }
}
