var VulnerableVault = ObjC.classes.VulnerableVault; 

function solve101(){
    var method = VulnerableVault["- setSecretInt:"];
    Interceptor.attach(method.implementation, {
        onEnter(args) {
            console.log(args[2]);
        }
    });
}


function solve102(){
    var method = VulnerableVault["- setSecretNumber:"];
    Interceptor.attach(method.implementation, {
        onEnter(args) {
            console.log(new ObjC.Object(args[2]));
        }
    });
}

function solve103(){
    var method = VulnerableVault["- setSecretString:"];
    Interceptor.attach(method.implementation, {
        onEnter(args) {
            console.log(ObjC.Object(args[2]));
        }
    });
}


function solve104(){
    var method = ObjC.classes["VulnerableVault"]["- winIfTrue:"]
    Interceptor.attach(method.implementation, {
        onEnter(args) {
            args[2] = ptr(0x1)
        }
    });
}

function solve105(){
    var method = VulnerableVault["- getSecretString"];
    Interceptor.attach(method.implementation, {
        onLeave(retval) {
            console.log(new ObjC.Object(retval))
        }
    });
}

function solve106(){
    var method = ObjC.classes["VulnerableVault"]["- hasWon"];
    Interceptor.attach(method.implementation, {
        onLeave(retval) {
            retval.replace(ptr(0x1))
        }
    });
}

function solve107(){
    var method = VulnerableVault["- getSecretKey"];
    Interceptor.attach(method.implementation, {
        onLeave(retval) {
            // Via NSString
            var theString = ObjC.classes.NSString.alloc()["- initWithData:encoding:"](retval, 4);
            console.log(theString)

            // Without NSString
            var data = new ObjC.Object(retval);
            console.log(data.bytes().readUtf8String(data.length()));
        }
    });
}

function solve108(){
    var method = VulnerableVault["- getself"];
    Interceptor.attach(method.implementation, {
        onLeave(retval) {
            var vault = new ObjC.Object(retval);
            vault.win();
        }
    });
}

function solve109(){
    var method = VulnerableVault["- getself"];
    Interceptor.attach(method.implementation, {
        onLeave(retval) {
            var vault = new ObjC.Object(retval);
            vault.winIfFrida_and27042_("Frida", 27042);
        }
    });
}

function solve110(){
    var method = VulnerableVault["- doNothing"];
    Interceptor.attach(method.implementation, {
        onLeave() {
            var hiddenVault = ObjC.chooseSync(ObjC.classes.HiddenVault)[0]
            hiddenVault.win();
        }
    });
}

function solve111(){
    var method = VulnerableVault["- doNothing"];
    Interceptor.attach(method.implementation, {
        onLeave() {
            // Find hidden function
            console.log(ObjC.classes.HiddenVault.$ownMethods);
            // Call it
            var hiddenVault = ObjC.chooseSync(ObjC.classes.HiddenVault)[0]
            hiddenVault["- super_secret_function"]();
        }
    });
}

function solve112(){
    var method = VulnerableVault["- generateNumbers"];
    Interceptor.attach(method.implementation, {
        onLeave(retval) {
            let array = ObjC.Object(retval)
            for(var i = 0; i<array["- count"](); i++){
                if(array["- objectAtIndex:"](i) > 42){
                    array["- setObject:atIndex:"](42, i);
                }
            }
        }
    });
}