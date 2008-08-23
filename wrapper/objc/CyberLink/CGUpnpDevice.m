//
//  CGUpnpDevice.m
//  CyberLink for C
//
//  Created by Satoshi Konno on 08/03/14.
//  Copyright 2008 Satoshi Konno. All rights reserved.
//

#include <cybergarage/upnp/cdevice.h>
#include <cybergarage/upnp/cservice.h>
#include <cybergarage/upnp/cicon.h>

#import "CGUpnpDevice.h"
#import "CGUpnpService.h"
#import "CGUpnpIcon.h"

@implementation CGUpnpDevice

@synthesize cObject;

- (id) init
{
	if ((self = [super init]) == nil)
		return nil;
	cObject = cg_upnp_device_new();
	isCObjectCreated = YES;
	if (!cObject)
		return nil;
	return self;
}

- (id) initWithCObject:(CgUpnpDevice *)cobj
{
	if ((self = [super init]) == nil)
		return nil;
	cObject = cobj;
	isCObjectCreated = NO;
	return self;
}

- (id) initWithXMLDescription:(NSString *)xmlDesc
{
	if ((self = [super init]) == nil)
		return nil;
	cObject = cg_upnp_device_new();
	isCObjectCreated = YES;
	if (!cObject)
		return nil;
	if (![self parseXMLDescription:xmlDesc]) {
		cg_upnp_device_delete(cObject);
		return nil;
	}
	return self;
}

- (BOOL) parseXMLDescription:(NSString *)xmlDesc;
{
	if (!cObject)
		return NO;
	return cg_upnp_device_parsedescription(cObject, (char *)[xmlDesc UTF8String], [xmlDesc length]);
}

- (void) dealloc
{
	if (isCObjectCreated && cObject)
		cg_upnp_device_delete(cObject);
	[super dealloc];
}

- (void) finalize
{
	if (isCObjectCreated && cObject)
		cg_upnp_device_delete(cObject);
	[super finalize];
}

- (NSString *)friendlyName
{
	if (!cObject)
		return nil;
	return [[[NSString alloc] initWithUTF8String:cg_upnp_device_getfriendlyname(cObject)] autorelease];
}

- (NSString *)deviceType
{
	if (!cObject)
		return nil;
	return [[[NSString alloc] initWithUTF8String:cg_upnp_device_getdevicetype(cObject)] autorelease];
}

- (NSString *)udn
{
	if (!cObject)
		return nil;
	return [[[NSString alloc] initWithUTF8String:cg_upnp_device_getudn(cObject)] autorelease];
}

- (BOOL)isDeviceType:(NSString *)aType
{
	return [aType isEqualToString:[self deviceType]];
}

- (BOOL)isUDN:(NSString *)aUDN
{
	return [aUDN isEqualToString:[self udn]];
}

- (BOOL)isFriendlyName:(NSString *)aFriendlyName
{
	return [aFriendlyName isEqualToString:[self friendlyName]];
}

- (NSArray *)services
{
	if (!cObject)
		return [[[NSArray alloc] init] autorelease];
	NSMutableArray *serviceArray = [[[NSMutableArray alloc] init] autorelease];
	CgUpnpService *cService;
	for (cService = cg_upnp_device_getservices(cObject); cService; cService = cg_upnp_service_next(cService)) {
		CGUpnpService *service = [[[CGUpnpService alloc] initWithCObject:(void *)cService] autorelease];
		[serviceArray addObject:service];
	}
	return serviceArray;
}

- (CGUpnpService *)getServiceForID:(NSString *)serviceId
{
	if (!cObject)
		return nil;
	CgUpnpService *foundService = cg_upnp_device_getservicebyserviceid(cObject, (char *)[serviceId UTF8String]);
	if (!foundService)
		return nil;
	return [[[CGUpnpService alloc] initWithCObject:(void *)foundService] autorelease];
}

- (CGUpnpService *)getServiceForType:(NSString *)serviceType
{
	if (!cObject)
		return nil;
	CgUpnpService *foundService = cg_upnp_device_getservicebytype(cObject, (char *)[serviceType UTF8String]);
	if (!foundService)
		return nil;
	return [[[CGUpnpService alloc] initWithCObject:(void *)foundService] autorelease];
}

- (NSArray *)icons
{
	if (!cObject)
		return [[[NSArray alloc] init] autorelease];
	NSMutableArray *iconArray = [[[NSMutableArray alloc] init] autorelease];
	CgUpnpIcon *cIcon;
	for (cIcon = cg_upnp_device_geticons(cObject); cIcon; cIcon = cg_upnp_icon_next(cIcon)) {
		CGUpnpIcon *icon = [[[CGUpnpIcon alloc] initWithCObject:(void *)cIcon] autorelease];
		[iconArray addObject:icon];
	}
	return iconArray;
}

- (void)setUserData:(void *)aUserData
{
	if (!cObject)
		return;
	cg_upnp_device_setuserdata(cObject, aUserData);
}

- (void *)userData
{
	if (!cObject)
		return NULL;
	return cg_upnp_device_getuserdata(cObject);
}

@end