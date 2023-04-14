//
//  VulnerableVault.h
//  fridaplayground
//
//  Created by Jeroen Beckers on 05/04/2023.
//

#ifndef VulnerableVault_h
#define VulnerableVault_h
#import <Foundation/Foundation.h>
//#import "fridaplayground-Swift.h"

@class Helper;
@interface VulnerableVault : NSObject;
+ (BOOL)I_WON;
-(void)winIfTrue:(BOOL)win;
-(BOOL) hasWon;
-(void) lose;
-(void) win;
-(void) doNothing;
-(NSString*) getSecretString;
-(VulnerableVault*) getself;
+(VulnerableVault*) getVault;
-(NSData*) getSecretKey;
-(void) setSecretString:(NSString*) string;
-(void) setSecretInt:(int)number;
-(NSMutableArray*) generateNumbers;
-(void) setSecretNumber:(NSNumber*)number;
-(void) winIfFrida:(NSString*)frida and27042: (int) port;
-(void) authenticate;
-(void) saveAndDeleteKeyChain:(NSString*) key withValue:(NSString*)value;
-(void) saveAndDeleteNSUserDefaults;
-(void) challenge1;
-(BOOL) validate:(int) p;
-(void) callDoesNotExist;



@end

#endif /* VulnerableVault_h */
