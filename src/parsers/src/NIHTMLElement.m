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

#import "NIHTMLElement.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NIHTMLElement

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id)initWithXMLNode:(xmlNode *)xmlNode {
  if (self = [super init]) {
    _node = xmlNode;
  }
  return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement*)findChildWithAttribute:(const char*)attribute 
                           matchingValue:(const char*)matchingValue 
                              inXMLNode:(xmlNode *)node 
                           allowPartial:(BOOL)partial
{
	xmlNode *cur_node = NULL;
	const char * classNameStr = matchingValue;
  
	if (node == NULL) {
		return NULL;
  }
  
  for (cur_node = node; cur_node; cur_node = cur_node->next) {		
		for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next) {			
			if (strcmp((char*)attr->name, attribute) == 0) {				
				for(xmlNode * child = attr->children; NULL != child; child = child->next) {
          
					BOOL match = NO;
					if (!partial && strcmp((char*)child->content, classNameStr) == 0) {
						match = YES;
          }
					else if (partial && strstr ((char*)child->content, classNameStr) != NULL) {
						match = YES;
          }
          
					if (match) {					
						return [[[NIHTMLElement alloc] initWithXMLNode:cur_node] autorelease];
					}
				}
				break;
			}
		}
    
		NIHTMLElement* cNode = [self findChildWithAttribute:attribute 
                                           matchingValue:matchingValue 
                                              inXMLNode:cur_node->children 
                                           allowPartial:partial];
		if (cNode != NULL) {
			return cNode;
		}
	}	
  
	return NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)findChildrenWithAttribute:(const char*)attribute 
                    matchingValue:(const char*)matchingValue 
                       inXMLNode:(xmlNode *)node 
                         inArray:(NSMutableArray*)array allowPartial:(BOOL)partial {
	
  xmlNode *cur_node = NULL;
	const char * matchingValueStr = matchingValue;
  
  for (cur_node = node; cur_node; cur_node = cur_node->next) {				
		for(xmlAttrPtr attr = cur_node->properties; NULL != attr; attr = attr->next) {
			if (strcmp((char*)attr->name, attribute) == 0) {				
				for(xmlNode * child = attr->children; NULL != child; child = child->next)	{
					BOOL match = NO;
					if (!partial && strcmp((char*)child->content, matchingValueStr) == 0) {
						match = YES;
          }
					else if (partial && strstr ((char*)child->content, matchingValueStr) != NULL) {
						match = YES;
          }
          
					if (match) {
						NIHTMLElement * nNode = 
              [[[NIHTMLElement alloc] initWithXMLNode:cur_node] autorelease];
						[array addObject:nNode];
						break;
					}
				}
				break;
			}
		}
    
		[self findChildrenWithAttribute:attribute 
                       matchingValue:matchingValue 
                          inXMLNode:cur_node->children 
                            inArray:array allowPartial:partial];
	}	
  
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)findChildOfClass:(NSString *)className {
  NIHTMLElement* node = [self findChildWithAttribute:"class" matchingValue:[className UTF8String] inXMLNode:_node->children allowPartial:NO];
  return node;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)findChildrenOfClass:(NSString *)className {
  return [self findChildrenWithAttribute:@"class" matchingValue:className allowPartial:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)findChildWithAttribute:(NSString *)attribute 
                           matchingValue:(NSString *)matchingValue 
                            allowPartial:(BOOL)partial {
  return [self findChildWithAttribute:[attribute UTF8String] 
                        matchingValue:[matchingValue UTF8String] 
                            inXMLNode:_node->children 
                         allowPartial:partial];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)findChildrenWithAttribute:(NSString *)attribute 
                        matchingValue:(NSString *)matchingValue 
                         allowPartial:(BOOL)partial {
  NSMutableArray * array = [NSMutableArray array];
  
	[self findChildrenWithAttribute:[attribute UTF8String] 
                    matchingValue:[matchingValue UTF8String] 
                        inXMLNode:_node->children 
                          inArray:array 
                     allowPartial:partial];
  
	return array;

}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString * getAttributeNamed(xmlNode * node, const char * nameStr) {
	for(xmlAttrPtr attr = node->properties; NULL != attr; attr = attr->next) {
		if (strcmp((char*)attr->name, nameStr) == 0) {				
			for(xmlNode * child = attr->children; NULL != child; child = child->next)	{
				return [NSString stringWithCString:(void*)child->content encoding:NSUTF8StringEncoding];
			}
			break;
		}
	}
	return NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)getAttributeNamed:(NSString *)name {
  return getAttributeNamed(_node, [name UTF8String]);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)findChildTags:(NSString *)tagName {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)findChildTag:(NSString *)tagName {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)firstChild {
  return [[[NIHTMLElement alloc] initWithXMLNode:_node->children] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)contents {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)allContents {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)rawContents {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)nextSibling {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)previousSibling {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)className {
  return [self getAttributeNamed:@"class"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)tagName {
  return [NSString stringWithCString:(void*)_node->name encoding:NSUTF8StringEncoding];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)parent {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)children {
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElementType)elementType {
  
}


@end
