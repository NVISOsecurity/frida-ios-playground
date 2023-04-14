//
//  ChallengeView.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 05/04/2023.
//

import Foundation


import SwiftUI

struct ChallengeView: View {
    
    var title : String;
    var text: String;
    var nav : String;
    var handler : () -> Void;
    
    init(nav: String, title: String, text: String,  handler: @escaping () -> Void ){
        self.nav = nav;
        self.title = title;
        self.text = text;
        self.handler = handler;
    }
    
    
    var body: some View {
        VStack (spacing: 20){
            
            Text(self.title)
                .font(.headline)
            Text(self.text)
                .font(.body)
            Button("Test solution") {
                self.handler();
            }.font(.headline)
            Spacer()
        }
        .navigationTitle(self.nav)
        .navigationBarTitleDisplayMode(.inline)
        .padding([.top], 20)
    }
    
}


struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {

        ChallengeView(nav: "Challenge 01", title: "The Title", text: "Description", handler: {})
    }
}
