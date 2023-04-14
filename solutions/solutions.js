//chall1






Interceptor.attach(ObjC.classes.NSUserDefaults["- setObject:forKey:"].implementation, {
    onEnter(args){
        console.log("Storing NSUserDefault:");
        console.log(new ObjC.Object(args[3]), new ObjC.Object(args[2]));
    }
})






var VulnerableVault = ObjC.classes.VulnerableVault;




//chall4


//chall5



// // find generated string
// // Get a reference to the NSString class.
// var NSString = ObjC.classes.NSString;

// // Intercept the method
// Interceptor.attach(NSString["- initWithUTF8String:"].implementation, {
//     onEnter: function(args) {
//         console.log("Creating string")
//     //    var str=new ObjC(ptr(args[2]));
//        console.log(args[2])
    
//   }
// });


// var newReplyBlock = new ObjC.Block({
//     retType: 'void',
//     argTypes: ['int', 'pointer'],
//     implementation: function (successOrFailure, nsError) {
//         console.log("Success: "+successOrFailure+" nsError: "+ObjC.Object(nsError));
//         console.log("blockArray[0].implementation: "+blockArray[0].implementation);
//         //this is not working
//         blockArray[0].implementation(1,null);
//     }
// });


// Advanced
var isSecure = Module.findExportByName(null, "isSecure");
Interceptor.attach(isSecure, {
    onLeave(retval){
        retval.replace(1);
    }
})




// var symbols = Process.getModuleByName('fridaplayground').enumerateSymbols()
// for (const [key, obj] of Object.entries(symbols)) {
//     console.log(`${obj["name"]}:`);
// }