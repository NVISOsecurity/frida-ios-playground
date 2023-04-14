function solve401(){
    var bind = Module.getExportByName(null, "bind")
    Interceptor.attach(ptr(bind), {
        onLeave(retval){
            retval.replace(0x0);
        }
    })
}

function solve402(){
    var bind = Module.getExportByName(null, "_dyld_get_image_name")
    Interceptor.attach(ptr(bind), {
        onLeave(retval){
            var dangerous = ["MobileSubstrate", "libcycript", "SubstrateLoader", "SubstrateInserter"]
            var lib = retval.readCString();
            for(var d in dangerous){
                lib = lib.replace(d, "xxx");
            }
            retval.replace(Memory.allocUtf8String(lib))
        }
    })
}

function solve403(){
    console.log("TODO")
}