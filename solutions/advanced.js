// 2.01
function solve201(){
    var VulnerableVault = ObjC.classes.VulnerableVault;
    var method = VulnerableVault["- lose"];
    method.implementation = ObjC.implement(method, function (handle, selector) {
        ObjC.Object(handle).win();
    });
}
// 2.02 (cannot be used together with 2.01 solution)
function solve202(){
    var method = VulnerableVault["- lose"];
    Interceptor.replace(method.implementation, new NativeCallback(function(vaultInstance, selector) {
            ObjC.Object(vaultInstance).win();
        }, 'void', ['pointer', 'pointer']));
}


// 2.03
function solve203(){
    var isSecure = Module.findExportByName(null, "isSecure");
    Interceptor.attach(isSecure, {
        onLeave(retval){
            retval.replace(1);
        }
    })
}

// 2.04
// Via static analysis, it's easy to find that isSecure calls a function named unexported
function solve204(){
    var isSecure = Module.findExportByName(null, "isSecure");
    printAssembly(isSecure, 10); // From this, we get an address

    var unexported = findMnemonic(isSecure, "bl").operands[0].value
    Interceptor.attach(ptr(unexported), {
        onLeave(retval){
            retval.replace(1);
        }
    })
}

// 2.05
function solve205(){
    var getLOTRTrilogy = Module.findExportByName(null, "getLOTRTrilogy");
    Interceptor.attach(getLOTRTrilogy, {
        onLeave(retval){
            var book1 = retval;
            console.log(book1.add(0).readPointer().readCString())
            console.log(book1.add(8).readPointer().readCString())

            var book2 = book1.add(0x10).readPointer();
            console.log(book2.add(0).readPointer().readCString())
            console.log(book2.add(8).readPointer().readCString())

            var book3 = book2.add(0x10).readPointer();
            console.log(book3.add(0).readPointer().readCString())
            console.log(book3.add(8).readPointer().readCString())
        }
    })
}

// 2.06
function solve206(){
    var hotPatchMe = Module.findExportByName(null, "hotPatchMe");
    console.log("hotPatchMe - original code")
    printAssembly(hotPatchMe, 20)
    console.log("")
    
    // load #1 into w0 right before ret
    Memory.patchCode(hotPatchMe.add(32), 1, function (code) {
        var cw = new Arm64Writer(code, {pc: hotPatchMe.add(60)});
        cw.putNop()
        cw.flush();
    });
    console.log("hotPatchMe - new code")
    printAssembly(hotPatchMe, 20)
}


// 2.07
function solve207()
{
    console.log("TODO")
}



// Util functions
function printAssembly(address, count){
    var offset = 0;
    for(var i = 0; i<count; i++)
    {
        var instruction = Instruction.parse(address.add(offset))
        console.log(`${instruction.address} [+${zeroPad(offset, 3)}]  ${instruction}`)
        offset += instruction.size
    }
}
function findMnemonic(address, mnemonic){
    var nextAddress = address;
    while(true)
    {
        var instruction = Instruction.parse(nextAddress)
        if(instruction.mnemonic == mnemonic)
        {
            return instruction;
        }
        nextAddress = nextAddress.add(instruction.size) 
    }
}
const zeroPad = (num, places) => String(num).padStart(places, '0')
