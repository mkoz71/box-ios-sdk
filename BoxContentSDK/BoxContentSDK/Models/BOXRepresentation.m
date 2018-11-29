//
//  BOXRepresentation.m
//  BoxContentSDK
//
//  Created on 7/15/16.
//  Copyright © 2016 Box. All rights reserved.
//

#import "BOXRepresentation.h"
#import "NSJSONSerialization+BOXContentSDKAdditions.h"
#import "BOXContentSDKConstants.h"

@implementation BOXRepresentation

- (instancetype)initWithJSON:(NSDictionary *)JSONResponse
{
    if (self = [super init]) {
        
        self.JSONData = JSONResponse;
        
        self.type = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyRepresentation
                                                   inDictionary:JSONResponse
                                                hasExpectedType:[NSString class]
                                                    nullAllowed:NO];
        
        NSDictionary *propertiesJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyProperties
                                                                      inDictionary:JSONResponse
                                                                   hasExpectedType:[NSDictionary class]
                                                                       nullAllowed:NO];
        
        self.dimensions = [propertiesJSON objectForKey:BOXAPIObjectKeyDimensions];
        
        NSDictionary *statusObject = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyStatus
                                                                    inDictionary:JSONResponse
                                                                 hasExpectedType:[NSDictionary class]
                                                                     nullAllowed:NO];
        
        self.status = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyState
                                                     inDictionary:statusObject
                                                  hasExpectedType:[NSString class]
                                                      nullAllowed:NO];
        
        self.statusCode = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyCode
                                                         inDictionary:statusObject
                                                      hasExpectedType:[NSString class]
                                                          nullAllowed:NO];
        
        NSDictionary *detailsJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyDetails
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        self.details = detailsJSON;
        
        NSDictionary *contentJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyContent
                                                                   inDictionary:JSONResponse
                                                                hasExpectedType:[NSDictionary class]
                                                                    nullAllowed:NO];
        
        self.templateURLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURLTemplate
                                                                    inDictionary:contentJSON
                                                                 hasExpectedType:[NSString class]
                                                                     nullAllowed:NO];
        if (self.templateURLString.length > 0) {
            NSString *replacementString = @"";

            if ([self.type isEqualToString:BOXRepresentationTypeHLS]) {
                replacementString = BOXRepresentationTemplateValueHLSManifest;
            }
            
            self.contentURL = [NSURL URLWithString:[self.templateURLString stringByReplacingOccurrencesOfString:BOXRepresentationTemplateKeyAccessPath withString:replacementString]];
        }
        
        NSDictionary *infoJSON = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyInfo
                                                                inDictionary:JSONResponse
                                                             hasExpectedType:[NSDictionary class]
                                                                 nullAllowed:NO];
        
        NSString *infoURLString = [NSJSONSerialization box_ensureObjectForKey:BOXAPIObjectKeyURL
                                                      inDictionary:infoJSON
                                                   hasExpectedType:[NSString class]
                                                       nullAllowed:NO];
        if (infoURLString.length > 0) {
            self.infoURL = [NSURL URLWithString:infoURLString];
        }
    }
    
    return self;
}

- (NSDictionary *)JSONDictionary
{
    NSMutableDictionary *JSONData = [NSMutableDictionary new];
    JSONData[BOXAPIObjectKeyRepresentation] = self.type;

    if (self.dimensions) {
        JSONData[BOXAPIObjectKeyProperties] = @{BOXAPIObjectKeyDimensions: self.dimensions};
    }

    NSMutableDictionary *statusDict = nil;
    if (self.status || self.statusCode) {
        statusDict = [NSMutableDictionary new];
        statusDict[BOXAPIObjectKeyState] = self.status;
        statusDict[BOXAPIObjectKeyCode] = self.statusCode;
    }
    JSONData[BOXAPIObjectKeyStatus] = statusDict;

    JSONData[BOXAPIObjectKeyDetails] = self.details;

    if (self.templateURLString) {
        JSONData[BOXAPIObjectKeyContent] = @{BOXAPIObjectKeyURLTemplate: self.templateURLString};
    }
    if (self.infoURL.absoluteString) {
        JSONData[BOXAPIObjectKeyInfo] = @{BOXAPIObjectKeyURL: self.infoURL.absoluteString};
    }
    return JSONData;
}

@end
