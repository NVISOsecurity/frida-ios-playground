![logo](img/logo.png?raw=true "logo")

# frida-ios-playground

An iOS app that lets you practice your [Frida](https://frida.re) skills. This app provides you with a bunch of different tasks to complete using Frida.



## Installing the IPA

- **Jailbroken device:** Push the IPA to your device and install via Filza / TrollStore.
- **Non-jailbroken device:** Since this application is meant to train your Frida skills, you'll first have to inject the Frida gadget. The easiest way is to use [objection's patchipa command](https://github.com/sensepost/objection/wiki/Patching-iOS-Applications). Note that this is only possible on a macOS device.

## Preview

![logo](img/screenshots.png?raw=true "logo")
## Challenges

Basic ([solutions](solutions/basic.js))

- Print parameter (int)
- Print parameter (NSNumber)
- Print parameter (NSString)
- Replace parameter
- Print return value (string)
- Replace return value
- Print return value (bytearray)
- Call function on object
- Call function with arguments on object
- Find HiddenVault instance
- Call secret function of HiddenVault
- Modify ByteArray

Advanced ([solutions](solutions/advanced.js))

- Switch implementation (ObjC.implement)
- Switch implementation (Interceptor.replace)
- Hook exported function
- Hook unexported function
- Reading pointers
- Hotpatch assembly

Interact with app  ([solutions](solutions/interact.js))

- Show a UIAlertController
- Intercept KeyChain item
- Read stored KeyChain item
- Biometric authentication
- NSUserDefaults
- NSUserDefaults - Read full file

Detect Frida / Jailbreak  ([solutions](solutions/frida.js))

- Detect frida-server on port 27042
- Detect suspicious libraries
- Detect packed FridaGadget 

Swift  ([solutions](solutions/swift.js))

- Intercept function (short String)
- Intercept function (large String)
- Call Swift function
- Call nonstatic Swift function

Challenges ([solutions](solutions/challenges.js))

- Enter the correct PIN
- Enter the correct password
- Solve every challenge at once

## FAQ

**I have a different solution**

That's definitely possible. Many challenges can be solved in different ways. If you have a different solution that uses a different approach, please open an issue or PR.

**I can cheat / reuse solutions / ...**

The app is built in a way that makes it easy to add challenges without the overhead of creating unique functions for each challenge. The goal is to learn, not just to get the SUCCESS popup. There's even a challenge to see if you can find a universal solution for each challenge.

**I have suggestions for challenges / found a bug**

Great! Please open an issue or PR.