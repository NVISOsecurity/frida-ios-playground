
function solve501(){
    var getSecret = Swift.classes.SwiftVault.$methods.filter(s => s.name.includes("getSmallSecret"))[0]
    Interceptor.attach(getSecret.address, {
        onLeave(retval){
            // For a short string (<16), Swift returns it via two registers, x0 and x1
            // You can see that it's a short string when printing retval, which just contains ascii hex
            var str = new SDSwiftSmallString(this.context.x0.toString(16), this.context.x1.toString(16));
            console.log(str.desc())
            console.log(str.strValue)
        }
    })  
}

function solve502(){
    var getSecret = Swift.classes.SwiftVault.$methods.filter(s => s.name.includes("getLargeSecret"))[0]
    Interceptor.attach(getSecret.address, {
        onLeave(retval){
            // A large string is allocated on the heap. retval now contains an indicator and length, while x1 contains a pointer
            let largeStr = new SDSwiftLargeString(BigInt(this.context.x0), BigInt(this.context.x1));
            console.log(largeStr.desc())
            console.log(largeStr.strValue)
        }
    })  
}

function solve503(){
    console.log("TODO")
}

function solve504(){
    console.log("TODO")
}


// utils adapted from https://codeshare.frida.re/@Numenorean/swiftstring/
function isSmallString(value) {
    let smth = (value >> 4n) & 0xFn;
    return (smth & 2n) > 0n;
}
class SDSwiftSmallString { 
    strValue;
    count;
    isHex;
    constructor(h1, h2) {
        // max small string length is 15 bytes
        let h1Array = hexStrToUIntArray(h1).reverse();
        let h2Array = hexStrToUIntArray(h2).reverse();
        function isValidChar(element, index, array) { 
            return (element > 0); 
        }
        let dataArr = h1Array.concat(h2Array).slice(0, 15);
        let data = dataArr.filter(isValidChar);
        let str = String.fromCharCode.apply(null, data);
        if (isPrintableString(str)) {
            this.strValue = str;
            this.count = str.length;
            this.isHex = false;
        } else {
            this.strValue = uintArrayToHexStr(dataArr)
            this.count = dataArr.length;
            this.isHex = true;
        }
    }
    desc() {
        let hexTip = this.isHex ? "hex" : "str";
        return `<Swift.String(Small), count=${this.count}, ${hexTip}='${this.strValue}'>`;
    }
}
class SDSwiftLargeString {
    // https://github.com/TannerJin/Swift-MemoryLayout/blob/master/SwiftCore/String.swift
    _countAndFlagsBits;
    _object;
    isASCII;
    isNFC;
    isNativelyStored;
    isTailAllocated;
    count;
    strValue;
    constructor(inCountAndFlag, inObject) {
        this._countAndFlagsBits = inCountAndFlag;
        this._object = inObject;
        // 1. parse _countAndFlagsBits
        let abcd = inCountAndFlag >> 48n >> 12n & 0xFn; // 16bits, 2bytes
        this.isASCII = (abcd & 0x8n) > 0n;
        this.isNFC = (abcd & 0x4n) > 0n;
        this.isNativelyStored = (abcd & 0x2n) > 0n;
        this.isTailAllocated = (abcd & 0x1n) > 0n;
        this.count = inCountAndFlag & 0xFFFFFFFFFFFFn ; // 48bits,6bytes
        // 2. parse _object
        let objectFlag = inObject >> 56n & 0xFFn;
        let strAddress = '0x' + (inObject & 0xFFFFFFFFFFFFFFn).toString(16); // low 56 bits
        let strPtr = new NativePointer(strAddress);
        let cstrPtr = strPtr.add(32);
        this.strValue = cstrPtr.readCString() ?? "";
    }
    desc() {
        return `<Swift.String(Large), count=${this.count}, str='${this.strValue}'>`;
    }
}
function isPrintableChar(val) {
    // [A-Za-z0-9_$ ]
    //0-9  0x30-0x39
    //A-Z  0x41-0x5a
    //a-z  97-122
    //0x5f 0x24 0x20
    let isNumber = (val >= 0x30 && val <= 0x39);
    let isUpper = (val >= 0x41 && val <= 0x5a);
    let isLower = (val >= 0x61 && val <= 0x7a);
    let isSpecial = (val == 0x5f) || (val == 0x24) || (val == 0x20);
    return isNumber || isUpper || isLower || isSpecial;
}
function isPrintableString(str) {
    for(var i = 0; i < str.length; i++) {
        let val = str.charCodeAt(i);
        if (!isPrintableChar(val)) {
            return false;
        }
    }
    return true;
}
function hexString(str) {
    var ret = "0x";
    for(var i = 0; i < str.length; i++) {
        let val = str.charCodeAt(i);
        var valstr = val.toString(16);
        if (valstr.length == 1) {
            valstr = '0' + valstr;
        }
        ret = ret + valstr;
    }
    return ret;
}
function readUCharHexString(ptr, maxlen) {
    var idx = 0;
    var hexStr = "";
    while (true) {
        let val = ptr.add(idx).readU8()
        if (val == 0) {
            break;
        }
        var valstr = val.toString(16);
        if (valstr.length == 1) {
            valstr = '0' + valstr;
        }
        hexStr += valstr;
        idx++;
        if (idx >= maxlen) {
            break;
        }
    }
    if (hexStr.length > 0) {
        hexStr = "0x" + hexStr;
    }
    return hexStr;
}
function swapInt16(val) {
    return ((val & 0xff) << 8) | ((val >> 8) & 0xff);
}
function swapInt32(val) {
    return (
        ((val & 0xff) << 24) |
        ((val & 0xff00) << 8) |
        ((val & 0xff0000) >> 8) |
        ((val >> 24) & 0xff)
    );
}
function hexStrToUIntArray(inputStr) {
    var str = inputStr
    if (str.startsWith('0x')) {
        str = str.substr(2);
    }
    var hex = str.toString();
    var result = [];
    for (var n = 0; n < hex.length; n += 2) {
        result.push(parseInt(hex.substr(n, 2), 16));
    }
    return result;
}
function uintArrayToHexStr(array) {
    var str = "";
    for (var n = 0; n < array.length; n += 1) {
        let val = array[n];
        var valstr = array[n].toString(16);
        if (valstr.length == 1) {
            valstr = '0' + valstr;
        }
        str += valstr;
    }
    if (str.length > 0) {
        str = "0x" + str;
    }
    return str;
}