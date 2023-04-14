//
//  ModifyFunctionArgument.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 05/04/2023.
//

import SwiftUI

struct ModifyFunctionArgument: View {
    
    var title : String;
    var text: String;
    var handler : () -> Void;
    
    init(title: String, text: String,  handler: @escaping () -> Void ){
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
            Button("Go!") {
                self.handler();
            }.font(.headline)
            Spacer()
        }
        .navigationTitle(self.title)
        .padding([.top], 20)
    }
    
}


struct ModifyFunctionArgument_Previews: PreviewProvider {
    static var previews: some View {
        ModifyFunctionArgument(title: "The Title", text: "Description", handler: {})
    }
}
