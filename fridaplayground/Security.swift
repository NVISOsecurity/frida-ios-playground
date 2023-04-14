//
//  Security.swift
//  fridaplayground
//
//  Created by Jeroen Beckers on 06/04/2023.
//

import Foundation
import Darwin
import MachO

class Security {
    
    static func detectFridaPort() -> Bool
    {
        let port = UInt16(27042)
        return isPortOpen(port:port)
    }
    
    static func isPortOpen(port: in_port_t) -> Bool {

        let socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0)
        if socketFileDescriptor == -1 {
            return false
        }

        var addr = sockaddr_in()
        let sizeOfSockkAddr = MemoryLayout<sockaddr_in>.size
        addr.sin_len = __uint8_t(sizeOfSockkAddr)
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = Int(OSHostByteOrder()) == OSLittleEndian ? _OSSwapInt16(port) : port
        addr.sin_addr = in_addr(s_addr: inet_addr("127.0.0.1"))
        addr.sin_zero = (0, 0, 0, 0, 0, 0, 0, 0)
        var bind_addr = sockaddr()
        memcpy(&bind_addr, &addr, Int(sizeOfSockkAddr))

        if Darwin.bind(socketFileDescriptor, &bind_addr, socklen_t(sizeOfSockkAddr)) == -1 {
            return true
        }
        if listen(socketFileDescriptor, SOMAXCONN ) == -1 {
            return true
        }
        return false
    }
    
    static func detectFridaGadget() -> Bool {

        let libraries = ["FridaGadget"]
        let imageCount = _dyld_image_count();
        for i in 0..<imageCount{
            let imgName = String(cString: _dyld_get_image_name(i));

            for lib in libraries {
                if imgName.contains(lib){
                    
                    return true
                }
            }
        }
        return false
    }
    
    static func detectSuspiciousLibraries() -> Bool{

        let libraries = ["MobileSubstrate", "libcycript", "SubstrateLoader", "SubstrateInserter"]
        let imageCount = _dyld_image_count();
        for i in 0..<imageCount{
            let imgName = String(cString: _dyld_get_image_name(i));
            for lib in libraries {
                if imgName.contains(lib){
                    
                    return true
                }
            }
        }
        return false
    }
    
}
