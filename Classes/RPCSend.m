//
//  RPCSend.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RPCSend.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface RPCSend (PrivateMethods)
+(NSString *)getGatewayAddress;
@end

@implementation RPCSend

static RpcConnection rpc;
static char *host;
static unsigned short port;
static BOOL connected;
static char hwdbaddr[16];
static char response[SOCK_RECV_BUF_LEN];
static char sendquery[SOCK_RECV_BUF_LEN];
static unsigned querylen;
static unsigned length;

+(void) initrpc{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];  
	
    port = [userDefaults integerForKey:@"HWDBP"];
	
   // NSString *rip = [userDefaults stringForKey:@"RouterIP"];
	
    //if (rip == NULL){
//		rip = @"10.2.0.6";
	//}
    
    NSString *gwaddr =  [self getGatewayAddress];
    NSLog(@"WIFI IP ADDR IS %@",gwaddr);
	
    //sprintf(hwdbaddr, [rip UTF8String]);
	sprintf(hwdbaddr, [gwaddr UTF8String]);
    
	host = hwdbaddr;
	port = HWDB_SERVER_PORT;
	//DLog(@"port is %d addr is %@", port, rip);

	connected = FALSE;
	DLog(@"initing rpc");
	if (!rpc_init(0)) {
		fprintf(stderr, "Failure to initialize rpc system\n");
		exit(1);
	}
	DLog(@"initialised rpc");
}

+(NSString *)getGatewayAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    NSArray *addrs = [address componentsSeparatedByString:@"."];
    int gwbit =  [((NSString *) [addrs objectAtIndex:3]) intValue];
    return [NSString stringWithFormat:@"%@.%@.%@.%d",[addrs objectAtIndex:0], [addrs objectAtIndex:1], [addrs objectAtIndex:2], gwbit+1];
}


+(BOOL) connect{
	DLog(@"connecting to router %s, %d", host, port);
	rpc = rpc_connect(host, port, "HWDB", 1l);
	if (rpc){
		connected = TRUE;
		[RPCSend performSelectorOnMainThread:@selector(notifyconnected:) withObject:nil waitUntilDone:NO];
		DLog(@"successfully connected");
		return TRUE;
	}
	[RPCSend performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
	return FALSE;
}

+(BOOL) sendquery:(NSString *)q{
	sprintf(sendquery, [q UTF8String]);
	querylen = strlen(sendquery) + 1;
	return [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:&length];
}

+(BOOL) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned *) len{
	
	if (!connected)
		if (![self connect]){
			connected = FALSE;
			[RPCSend performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
			return FALSE;
		}
	
	if (rpc){
		@synchronized(rpc){
			if (rpc_call(rpc, query, qlen, resp, rs, len)){
				return TRUE;
			}else{
				rpc_disconnect(rpc);
				connected = FALSE;
				[RPCSend performSelectorOnMainThread:@selector(notifydisconnected:) withObject:nil waitUntilDone:NO];
			}
		}
	}
	return FALSE;
}

+(void) notifydisconnected:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"disconnected" object:nil];
}

+(void) notifyconnected:(NSObject *) o{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"connected" object:nil];
}

@end
