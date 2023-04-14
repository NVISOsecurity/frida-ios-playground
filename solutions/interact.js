
function solve301(){
    var UIAlertController = ObjC.classes.UIAlertController;
    var UIAlertAction = ObjC.classes.UIAlertAction;
    var UIApplication = ObjC.classes.UIApplication;
    var handler = new ObjC.Block({ 
        retType: 'void', 
        argTypes: ['object'], 
        implementation: function () {} 
    });
    ObjC.schedule(ObjC.mainQueue, function () {
        var alert = UIAlertController.alertControllerWithTitle_message_preferredStyle_('Success', 'Solved with Frida', 1);
        var defaultAction = UIAlertAction.actionWithTitle_style_handler_('OK', 0, handler);
        alert.addAction_(defaultAction);
        UIApplication.sharedApplication().keyWindow().rootViewController().presentViewController_animated_completion_(alert, true, NULL);
    })
}

function solve302(){
    Module.enumerateExports("Security", { 
        onMatch: function(imp) {
            if (imp.type == "function" && imp.name == "SecItemAdd") {
                Interceptor.attach(imp.address, {
                    onEnter(args){
                        var dict = convertDict(ObjC.Object(args[0]));
                        console.log(`(${dict["svce"]}) ${dict["acct"]} - ${dict["v_Data"]}`)
                    }
                });
            }
            
        },
        onComplete: function(){
    
        }
    });
}

function solve303(){
    getkeychain();
}

function solve304(){
    // Doesn't always seem to work for some reason ...
    const pendingBlocks = new Set();
    var hook = ObjC.classes.LAContext["- evaluatePolicy:localizedReason:reply:"];
    Interceptor.attach(hook.implementation, {
        onEnter: function(args) {
            console.log("Hooking Touch Id..")
            console.log(args[4])
            var block = new ObjC.Block(args[4]);
            pendingBlocks.add(block); // Keep it alive
            
            const appCallback = block.implementation;
            block.implementation = function (error, value)  {
                const result = appCallback(1, null);
                pendingBlocks.delete(block);

                return result;
            };
        },
    });
}

function solve305(){
    var NSUserDefaults = ObjC.classes.NSUserDefaults;
    var setObject = NSUserDefaults["- setObject:forKey:"]
    Interceptor.attach(setObject.implementation, {
        onEnter(args){
            var value = new ObjC.Object(args[2])
            var key = new ObjC.Object(args[3])
            console.log(`${key} -> ${value}`)
        }
    })

}

function solve306(){
    var NSUserDefaults = ObjC.classes.NSUserDefaults;
    console.log( NSUserDefaults["+ standardUserDefaults"]())
    var NSDictionary = NSUserDefaults["+ standardUserDefaults"]().dictionaryRepresentation();
    console.log(NSDictionary.toString())
}

// util functions
function convertDict(dict){
    var keys = dict.allKeys();
    var ob = {};
    for (var index = 0; index < keys.count(); index++) {
        var k = keys.objectAtIndex_(index);
        var v = dict.objectForKey_(k);
        if (["svce", "pdmn" ,"mdat", "cdat", "agrp"].includes(k.toString())) {
            v = new ObjC.Object(v).toString()
        }
        if(k == "acct" || k == "v_Data"){
            var data = new ObjC.Object(v)
            v = data.bytes().readUtf8String(data.length());
        }
        ob[k] = v;
    }
    return ob;
}

// modified from https://codeshare.frida.re/@lichao890427/ios-utils/
function getConstant(name){
    var pptr = Module.findExportByName(null, name);
    return ObjC.Object(Memory.readPointer(pptr));
}
function getkeychain() {
    var NSMutableDictionary=ObjC.classes.NSMutableDictionary;
    var kCFBooleanTrue = getConstant("kCFBooleanTrue");
    var kSecReturnAttributes = getConstant("kSecReturnAttributes");
    var kSecMatchLimitAll = getConstant("kSecMatchLimitAll");
    var kSecMatchLimit = getConstant("kSecMatchLimit");
    var kSecReturnData = getConstant("kSecReturnData");
    var kSecClassGenericPassword = getConstant("kSecClassGenericPassword");
    var kSecClassInternetPassword = getConstant("kSecClassInternetPassword");
    var kSecClassCertificate = getConstant("kSecClassCertificate");
    var kSecClassKey = getConstant("kSecClassKey");
    var kSecClassIdentity = getConstant("kSecClassIdentity");
    var kSecClass = getConstant("kSecClass");

    var query = NSMutableDictionary.alloc().init();

    var SecItemCopyMatching = new NativeFunction(Module.findExportByName(null, "SecItemCopyMatching"), "int", ["pointer", "pointer"]);

    [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, 
        kSecClassIdentity].forEach(function(secItemClass) {
            query.setObject_forKey_(kCFBooleanTrue, kSecReturnAttributes);
            query.setObject_forKey_(kSecMatchLimitAll, kSecMatchLimit);
            query.setObject_forKey_(secItemClass, kSecClass);
            query.setObject_forKey_(kCFBooleanTrue, kSecReturnData);

            var result = Memory.alloc(8);
            Memory.writePointer(result, ptr("0"));
            SecItemCopyMatching(query.handle, result);
            var pt = Memory.readPointer(result);
            if (!pt.isNull()) {
                var nsArray = ObjC.Object(pt);
                var count = nsArray.count();
                for (var i = 0; i < count; i++) {
                    var dict = convertDict(nsArray.objectAtIndex_(i));
                    console.log(`(${dict["svce"]}) ${dict["acct"]} - ${dict["v_Data"]}`)
                }
            }
        }
    )
}


// var myVault = VulnerableVault.alloc().init();
// for(var i = 0; i<9999; i++){
//     if(myVault["- validate:"](i))
//     {
//         console.log(i)
//     }
// }


// 2.05
