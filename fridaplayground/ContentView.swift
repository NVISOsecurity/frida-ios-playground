//
//  ContentView.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 28/02/2023.
//

import SwiftUI




struct Challenge {
    var title: String
    var text: String
    var handler: () -> Void
}

struct ChallengeGroup {
    var title: String
    var challenges: [Challenge]
}

struct ContentView: View {

    var challenges : [ChallengeGroup]! = nil;
    init(){
    
        
    challenges = [
            
        ChallengeGroup(title: "Basic", challenges:[
            
            Challenge(title: "Print parameter (int)",
                      text: "The button triggers VulnerableVault.setSecretInt(int). Intercept the secret number.",
                      handler: {
                          Helper.vault.setSecretInt(42);
                      }),
            
            Challenge(title: "Print parameter (NSNumber)",
                      text: "The button triggers VulnerableVault.setSecretNumber(NSNumber). Intercept the secret number.",
                      handler: {
                          Helper.vault.setSecretNumber(42);
                      }),
            
            Challenge(title: "Print parameter (NSString)",
                      text: "The button triggers VulnerableVault.setSecretString(NSString). Intercept the secret string.",
                      handler: {
                          Helper.vault.setSecretString("The Answer to Life, The Universe, And Everything");
                      }),
            
            Challenge(title: "Replace parameter",
                      text: "The button triggers VulnerableVault.winIfTrue(FALSE). Make winIfTrue receive TRUE instead of FALSE",
                      handler: {
                          Helper.vault.winIfTrue(false);
                      }),
            
            Challenge(title: "Print return value (string)",
                      text: "The button triggers VulnerableVault.getSecretString, which returns a String. Intercept the return value and print it.",
                      handler: {
                          Helper.vault.getSecretString();
                      }),
            
            Challenge(title: "Replace return value",
                      text: "Make VulnerableVault.hasWon return TRUE instead of FALSE",
                      handler: {
                          Helper.vault.hasWon() ? Helper.app.showSuccess() : Helper.app.showFailure();
                      }),
            
           
            Challenge(title: "Print return value (bytearray)",
                      text: "The button triggers VulnerableVault.getSecretKey, which returns a bytearray. The bytearray contains an ascii string. Intercept the return value and print the string in the bytearray.",
                      handler: {
                          Helper.vault.getSecretKey();
                      }),
            
            
            Challenge(title: "Call function on object",
                      text: "The button triggers VulnerableVault.getself, which returns a reference to itself. Intercept the return value and call the win() method.",
                      handler: {
                          Helper.vault.getself();
                      }),
            
            Challenge(title: "Call function with arguments on object",
                      text: "The button triggers VulnerableVault.getself, which returns a reference to itself. Intercept the return value and call [vault winIfFrida:@\"Frida\" and27042:27042]",
                      handler: {
                          Helper.vault.getself();
                      }),
            
            
            Challenge(title: "Find HiddenVault instance",
                      text: "The button calls VulnerableVault.doNothing, which doesn't do anything. When the button is clicked, find an instance of the HiddenVault class and call its win() method",
                      handler: {
                          Helper.vault.doNothing()
                      }),
            
            Challenge(title: "Call secret function of HiddenVault",
                      text: "The button calls VulnerableVault.doNothing, which doesn't do anything. When the button is clicked, find an instance of the HiddenVault class and the secret function",
                      handler: {
                          Helper.vault.doNothing()
                      }),
            
            
            Challenge(title: "Modify ByteArray",
                      text: "The button calls VulnerableVault.generateNumbers, which returns an NSMutableArray. Modify the array and set any number larger than 42 to 42. Have the function return the modified array",
                      handler: {
                          let numbers = Helper.vault.generateNumbers() as? [Int]
                          for nr in numbers! {
                              if nr  > 42 {
                                  Helper.app.showFailure()
                                  return
                              }
                          }
                          Helper.app.showSuccess()
                      }),
        ]),
        
        ChallengeGroup(title: "Advanced", challenges:[
            
            Challenge(title: "Switch implementation (ObjC.implement)",
                      text: "The button triggers VulnerableVault.lose. Switch out the implementation of VulnerableVault.lose with a function that calls VulnerableVault.win() by using ObjC.implement",
                      handler: {
                          Helper.vault.lose()
                      }),
            
            Challenge(title: "Switch implementation (Interceptor.replace)",
                      text: "The button triggers VulnerableVault.lose. Switch out the implementation of VulnerableVault.lose with a function that calls VulnerableVault.win() by using Interceptor.replace",
                      handler: {
                          Helper.vault.lose()
                      }),
            
            Challenge(title: "Hook exported function",
                      text: "The button calls the isSecure function. Make the function return TRUE",
                      handler: {
                          isSecure() == 1 ? Helper.app.showSuccess() : Helper.app.showFailure()
                      }),

            Challenge(title: "Hook unexported function",
                      text: "The button calls the isSecure function, which internally calls a second function that isn't exported. Find the second function and make it return 1, without modifying/hooking isSecure().",
                      handler: {
                          isSecure() == 1 ? Helper.app.showSuccess() : Helper.app.showFailure()
                      }),
            
            Challenge(title: "Reading pointers",
                      text: "The button triggers getLOTRTrilogy(void), which returns a struct: \nstruct Book {\n\tNSString *author;\n\tNSString *title;\n\tstruct Book *sequel;\n};\n\nPrint the title of the third book.",
                      handler: {
                          getLOTRTrilogy();
                      }),
            
            Challenge(title: "Hotpatch assembly",
                      text: "The button calls the hotPatchMe function. The function performs a conditional check (if(0){}). Use Memory.writeByteArray to hotpatch the function.",
                      handler: {
                          hotPatchMe() == 1 ? Helper.app.showSuccess() : Helper.app.showFailure()
                      }),
        ]),
        
        ChallengeGroup(title: "Interact with app", challenges:[
                      
            Challenge(title: "Show a UIAlertController",
                      text: "The button calls VulnerableVault.doNothing(), which doesn't do anything. When the button is clicked, create and show a UIAlertController without using any of the methods in the playground.",
                      handler: {
                          Helper.vault.doNothing();
                      }),
            
            Challenge(title: "Intercept KeyChain item",
                      text: "The button calls VulnerableVault.saveKey(<key>, <value>) which saves the key:value pair to the iOS KeyChain and immediatelly deletes it. Intercept the key when it is written to the KeyChain.",
                      handler: {
                          Helper.vault.saveAndDeleteKeyChain("K3yCh41nK3y", withValue:"Th3K3yCh41nD4t4")
                      }),
            
            Challenge(title: "Read stored KeyChain item",
                      text: "The button calls VulnerableVault.doNothing(), which doesn't do anything. During application launch, a secretkey was already stored in the iOS KeyChain. Retrieve it.",
                      handler: {
                          Helper.vault.doNothing();
                      }),
            
            Challenge(title: "Biometric authentication",
                      text: "The button calls VulnerableVault.authenticate, which shows a biometric prompt. Bypass the prompt without using biometrics.",
                      handler: {
                          Helper.vault.authenticate();
                      }),
            
            Challenge(title: "NSUserDefaults",
                      text: "The button calls VulnerableVault.saveAndDeleteNSUserDefaults, which saves data to NSUserDefaults and immediatelly deletes it. Intercept the saved value.",
                      handler: {
                          Helper.vault.saveAndDeleteNSUserDefaults();
                      }),
            
            Challenge(title: "NSUserDefaults - Read full file",
                      text: "The button calls VulnerableVault.doNothing, which doesn't do anything. During application launch, values were stored in [NSUserDefaults standardUserDefaults]. Retrieve them.",
                      handler: {
                      })
        ]),
    
        ChallengeGroup(title: "Detect Frida / Jailbreak", challenges:[
            
            Challenge(title: "Detect frida-server on port 27042",
                      text: "The button scans open ports in search for port 27042, which is the default port of frida-server.",
                      handler: {
                          Security.detectFridaPort() ?
                          Helper.app.showAlert(title: "Frida detected!", message: "Frida has been detected on port 27042") :
                          Helper.app.showAlert(title: "Success!", message: "Frida was not detected!")
                      }),
            
            Challenge(title: "Detect suspicious libraries",
                      text: "The button scans the loaded libraries of the process to find libraries related to jailbreaking (MobileSubstrate, libcycript, SubstrateLoader, SubstrateInserter)",
                      handler: {
                          Security.detectSuspiciousLibraries() ?
                          Helper.app.showAlert(title: "Libraries detected!", message: "Suspicious libraries were detected") :
                          Helper.app.showAlert(title: "Success!", message: "No libraries detected!")
                      }),
            
            Challenge(title: "Detect packed FridaGadget ",
                      text: "The button scans the loaded libraries of the process to find FridaGadget. This will only trigger for a repackaged app.",
                      handler: {
                          Security.detectFridaGadget() ?
                            Helper.app.showAlert(title: "Frida detected!", message: "The frida-agent library was found") :
                            Helper.app.showAlert(title: "Success!", message: "Frida was not detected!")
                      })
        ]),
            
        ChallengeGroup(title: "Swift", challenges:[
                
            Challenge(title: "Intercept function (short String)",
                      text: "The button calls SwiftVault.getSmallSecret. Intercept the secret.",
                      handler: {
                          SwiftVault.vault.getSmallSecret();
                      }),
            
            Challenge(title: "Intercept function (large String)",
                      text: "The button calls SwiftVault.getLargeSecret. Intercept the secret.",
                      handler: {
                          SwiftVault.vault.getLargeSecret();
                      }),
            
            Challenge(title: "Call Swift function",
                      text: "The button calls VulnerableVault.doNothing(), which doesn't do anything. When clicked, call the static SwiftVault.staticWin() function",
                      handler: {
                          Helper.vault.doNothing()
                      }),
            
            Challenge(title: "Call nonstatic Swift function",
                      text: "The button calls VulnerableVault.doNothing(), which doesn't do anything. When clicked, call the SwiftVault.win() function",
                      handler: {
                          Helper.vault.doNothing()
                      }),
        ]),
    
        ChallengeGroup(title: "Challenges", challenges:[
                
            Challenge(title: "Enter the correct PIN",
                      text: "The button calls VulnerableVault.challenge1. Enter the correct PIN.",
                      handler: {
                          Helper.vault.challenge1();
                      }),
            
            Challenge(title: "Enter the correct password",
                      text: "Find and enter the correct password.",
                      handler: {
                          ChallengeVault().challenge2();
                      }),
            
            Challenge(title: "Solve every challenge at once",
                      text: "Every challenge is launched by the same button press. Create a Frida script that solves every challenge at the same time.",
                      handler: {
                         
                      }),
            
            
        ])]
    }
    
   
    
    func writeOutput(output : String, toFile file : String){
        let filename = getDocumentsDirectory().appendingPathComponent(file)

        do {
            try output.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    
    
    
    
    
//    func setStaticVar(){
//        if(VulnerableVault.I_WON()){
//            Helper.app.showSuccess();
//        }else{
//            Helper.app.showFailure();
//        }
//    }
    
    
    
    var body: some View {
        NavigationView {
            List() {
                    ForEach(challenges.indices, id: \.self) {
                        groupindex in
                        Section(header: Text(challenges[groupindex].title)) {
                            ForEach(challenges[groupindex].challenges.indices, id: \.self) {
                                challengeindex in
                                let challenge = challenges[groupindex].challenges[challengeindex]
                                let formatIndex = "\(groupindex+1)." + String(format: "%02d", challengeindex + 1)
                                    NavigationLink(
                                        destination: ChallengeView(nav: "Challenge \(formatIndex)", title: challenge.title , text: challenge.text, handler: challenge.handler),
                                        label: {
                                            Text("\(formatIndex) \(challenge.title)")
                                        }
                                    )
                                }
                            }
                        }
                    
                }.listStyle(.insetGrouped)

            .navigationTitle("Challenges")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
