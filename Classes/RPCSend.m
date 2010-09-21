//
//  RPCSend.m
//  ContentionApp
//
//  Created by Tom Lodge on 20/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RPCSend.h"


@implementation RPCSend

static RpcConnection rpc;
static char *host;
static unsigned short port;
static BOOL connected;


static char response[SOCK_RECV_BUF_LEN];
static char sendquery[SOCK_RECV_BUF_LEN];
static unsigned querylen;
static unsigned length;

+(void) initrpc{
	
	host = HWDB_SERVER_ADDR;
	port = HWDB_SERVER_PORT;
	
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
		NSLog(@"successfully connected");
		return TRUE;
	}
	return FALSE;
}

+(BOOL) sendquery:(NSString *)q{
	sprintf(sendquery, [q UTF8String]);
	querylen = strlen(sendquery) + 1;
	return [self send: sendquery qlen:querylen resp: response rsize: sizeof(response) len:&length];
}

+(BOOL) send: (void *) query qlen:(unsigned) qlen resp: (void*) resp rsize:(unsigned) rs len:(unsigned *) len{
	
	if (!connected)
		if (![self connect])
			return FALSE;
	NSLog(@"query is %s", query);
	if (rpc){
		NSLog(@"rpc is ok..qlen %d, resp size %d", qlen, rs);
		@synchronized(rpc){
			if (rpc_call(rpc, query, qlen, resp, rs, len)){
				return TRUE;
			} 
		}
	}
	return FALSE;
}

@end
