//
// Copyright 2011 Roger Chapman
//
// Forked from Objective-C-HMTL-Parser October 19, 2011 - Copyright 2010 Ben Reeves
//    https://github.com/zootreeves/Objective-C-HMTL-Parser
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NIHTMLParser.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NIHTMLParser

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithString:(NSString*)string error:(NSError**)error { 
	if (self = [super init]) {
		_doc = nil;
    
		if ([string length] > 0) {
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
			const char *enc = CFStringGetCStringPtr(cfencstr, 0);
			int optionsHtml = 0;
			optionsHtml = HTML_PARSE_RECOVER;
			optionsHtml = optionsHtml | HTML_PARSE_NOERROR; //Uncomment this to see HTML errors
			optionsHtml = optionsHtml | HTML_PARSE_NOWARNING;
			_doc = htmlReadDoc ((xmlChar*)[string UTF8String], NULL, enc, optionsHtml);
		}
		else {
			if (error) {
				*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
			}
		}
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithData:(NSData*)data error:(NSError**)error {
	if (self = [super init]) {
		_doc = nil;
    
		if (data)	{
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);
			const char *enc = CFStringGetCStringPtr(cfencstr, 0);
			_doc = htmlReadDoc((xmlChar*)[data bytes],
                         "",
                         enc,
                         XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
		}
		else {
			if (error) {
				*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
			}
		}
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithContentsOfURL:(NSURL*)url error:(NSError**)error {
  
	NSData * _data = [[NSData alloc] initWithContentsOfURL:url options:0 error:error];
  
	if (_data == nil || error)
	{
		[_data release];
		return nil;
	}
  
	[self initWithData:_data error:error];
  
	[_data release];
  
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)dealloc {
  
  if (_doc) {
    xmlFreeDoc(_doc);
  }
    
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement*)doc {
	if (_doc == nil)
		return nil;
  
	return [[[NIHTMLElement alloc] initWithXMLNode:(xmlNode*)_doc] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement*)html {
	if (_doc == nil)
		return nil;
  
	return [[self doc] findChildTag:@"html"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement*)body
{
	if (_doc == nil)
		return nil;
  
	return [[self doc] findChildTag:@"body"];
}

@end
