//
//  RPCSend.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RPCSend.h"
@interface RPCSend (PrivateMethods)
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
	NSString *rip = [userDefaults stringForKey:@"RouterIP"];
	if (rip == NULL){
		rip = @"192.168.9.1";
	}
	sprintf(hwdbaddr, [rip UTF8String]);
	
	host = hwdbaddr;
	port = HWDB_SERVER_PORT;
	NSLog(@"port is %d addr is %@", port, rip);

	connected = FALSE;
	NSLog(@"initing rpc");
	if (!rpc_init(0)) {
		fprintf(stderr, "Failure to initialize rpc system\n");
		exit(1);
	}
	NSLog(@"done initing rpc");
}

+(BOOL) connect{
	NSLog(@"connecting to router %s, %d", host, port);
	rpc = rpc_connect(host, port, "HWDB", 1l);
	if (rpc){
		connected = TRUE;
		[RPCSend performSelectorOnMainThread:@selector(notifyconnected:) withObject:nil waitUntilDone:NO];
		NSLog(@"successfully connected");
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
