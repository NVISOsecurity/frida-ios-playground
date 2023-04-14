//
//  VulnerableVault.m
//  fridaplayground
//
//  Created by Jeroen Beckers on 05/04/2023.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VulnerableVault.h"
#import "HiddenVault.h"
#import "fridaplayground-Swift.h"

#import <LocalAuthentication/LocalAuthentication.h>


@implementation VulnerableVault : NSObject

HiddenVault *myVault;


- (instancetype)init {
    myVault = [[HiddenVault alloc] init];
    
    [self deleteKey:@"VulnerableVaultInitKey"];
    [self addKey:@"VulnerableVaultInitKey" withValue:@"ThisWasAddedDuringAppStartup"];
    
    [[NSUserDefaults standardUserDefaults] setObject: @"SecretValueStoredDuringAppLaunch" forKey:@"App_Init_Key"];
    [[NSUserDefaults standardUserDefaults] setObject: @"Yes!" forKey:@"Having fun?"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    return self;
}



+(BOOL) I_WON
{
    return FALSE;
}


-(void) winIfTrue:( BOOL )win
{
    if(win)
    {
        [self win];
    }
    else
    {
        [self lose];
    }
}

-(BOOL) hasWon
{
    return FALSE;
}


-(void) lose
{
    [[Helper new] showFailure];
}
-(void) win
{
    [[Helper new] showSuccess];
}

-(void) winIfFrida:(NSString*)frida and27042: (int) port
{
   if([frida isEqualToString:@"Frida"] && port == 27042)
   {
       [self win];
   }else{
       [self lose];
   }
}

-(void) doNothing
{
    
}

-(NSString*) getSecretString
{
    NSString *myString = @"VulnerableVault_g3n3r@t3dStr1ng";
    return myString;
}

-(NSMutableArray*) generateNumbers
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i = 0; i < 20; i++)
    {
        [array addObject:[NSNumber numberWithInteger:arc4random_uniform(99)]];
    }
    
    return array;
}

-(NSData*) getSecretKey
{
    const char bytes[] = {
        0x24,0x33,0x63,0x72,0x33,0x54,0x38,0x79,0x74,0x33,0x34,0x72,0x72,0x34,0x79};
    int size = sizeof(bytes)/sizeof(char);
    NSData *data = [NSData dataWithBytes:bytes length:size];
    
    return data;
}

-(void) saveAndDeleteKeyChain:(NSString*)key withValue:(NSString*)data
{
    
    [self addKey:key withValue:data];
    [self deleteKey:key];
}

-(void) addKey:(NSString*)key withValue:(NSString*)value
{
    NSData* data = [value dataUsingEncoding:NSUTF8StringEncoding];
    // Save the key
    NSMutableDictionary * dict =[self prepareDict:key];
    [dict setObject:data forKey:(__bridge id)kSecValueData];
    [dict setObject:@"VulnerableVaultService" forKey:(id)kSecAttrService];
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
}
-(void) deleteKey:(NSString*)key
{
    // Immediatelly delete the key
    NSMutableDictionary *dict = [self prepareDict:key];
    OSStatus _ = SecItemDelete((__bridge CFDictionaryRef)dict);
}

-(NSMutableDictionary*) prepareDict:(NSString *) key {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedKey = [key dataUsingEncoding:NSUTF8StringEncoding];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:encodedKey forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:@"VulnerableVaultService" forKey:(__bridge id)kSecAttrService];
    [dict setObject:(__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly forKey:(__bridge id)kSecAttrAccessible];
    
    return  dict;
}

-(void) setSecretString:(NSString*) string
{
    
}
-(void) setSecretInt:(int)number
{
    
}
-(void) setSecretNumber:(NSNumber*)number
{
    
}


-(void) authenticate
{
    LAContext *context = [[LAContext alloc] init];

    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Bypass without using biometrics"
                          reply:^(BOOL success, NSError *error) {
                                if(success){
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                         [[Helper new] showSuccess];
                                    });
                                }
                                else
                                {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[Helper new] showFailure];
                                    });
                                
                                }}];
                             
    }
}

-(void) saveAndDeleteNSUserDefaults
{
    NSString *key =@"MyAwesomeKey";
    NSString *valueToSave = @"ValueSavedToNSUserDefaults";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];


}


-(void) challenge1{
    [[SwiftVault new] askPin];
}

-(BOOL) validate:(int) p{
    int c = 0;
    for (int i = 1; i <= p; i++)
    {
        if(p % i == 0){
            c += 1;
        }
    }
    
    if(c == 60 && !(p % 100)){
        return TRUE;
    }

    return FALSE;
}

+(VulnerableVault*) getVault
{
    return [[VulnerableVault alloc] init];
}

-(VulnerableVault*) getself
{
    return self;
}

- (void) callDoesNotExist
{
    VulnerableVault *vault = [VulnerableVault getVault];
    @try {
        SEL s = NSSelectorFromString(@"doesNotExist");
        [vault performSelector:s];
     }
    @catch (NSException *exception) {
        [self lose];
    }
}
@end
