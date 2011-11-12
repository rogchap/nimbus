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
#import <libxml/HTMLtree.h>

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
  NIHTMLElement* node = [self findChildWithAttribute:"class" 
                                       matchingValue:[className UTF8String] 
                                           inXMLNode:_node->children allowPartial:NO];
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
-(void)findChildTags:(NSString*)tagName inXMLNode:(xmlNode *)node inArray:(NSMutableArray*)array {
	xmlNode *cur_node = NULL;
	const char * tagNameStr =  [tagName UTF8String];
  
	if (tagNameStr == nil) {
		return;
  }
  
  for (cur_node = node; cur_node; cur_node = cur_node->next) {				
		if (cur_node->name && strcmp((char*)cur_node->name, tagNameStr) == 0) {
			NIHTMLElement* childNode = [[[NIHTMLElement alloc] initWithXMLNode:cur_node] autorelease];
			[array addObject:childNode];
		}
    
		[self findChildTags:tagName inXMLNode:cur_node->children inArray:array];
	}	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement*)findChildTag:(NSString*)tagName inXMLNode:(xmlNode *)node {
	xmlNode *cur_node = NULL;
	const char * tagNameStr =  [tagName UTF8String];
  
  for (cur_node = node; cur_node; cur_node = cur_node->next) {				
		if (cur_node && cur_node->name && strcmp((char*)cur_node->name, tagNameStr) == 0) {
			return [[[NIHTMLElement alloc] initWithXMLNode:cur_node] autorelease];
		}
    
		NIHTMLElement * cNode = [self findChildTag:tagName inXMLNode:cur_node->children];
		if (cNode != NULL) {
			return cNode;
		}
	}	
	return NULL;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)findChildTags:(NSString *)tagName {
  NSMutableArray * array = [NSMutableArray array];
	[self findChildTags:tagName inXMLNode:_node->children inArray:array];
	return array;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)findChildTag:(NSString *)tagName {
  return [self findChildTag:tagName inXMLNode:_node->children];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)firstChild {
  return [[[NIHTMLElement alloc] initWithXMLNode:_node->children] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)contents {
  if (_node->children && _node->children->content) {
		return [NSString stringWithCString:(void*)_node->children->content encoding:NSUTF8StringEncoding];
	}
	return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString * allNodeContents(xmlNode*node) {
	if (node == NULL) {
		return nil;
  }
  
	void * contents = xmlNodeGetContent(node);
	if (contents)	{
		NSString* string = [NSString stringWithCString:contents encoding:NSUTF8StringEncoding];
		xmlFree(contents);
		return string;
	}
	return @"";
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString *)allContents {
  return allNodeContents(_node);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString * rawContentsOfNode(xmlNode * node) {	
	xmlBufferPtr buffer = xmlBufferCreateSize(1000);
	xmlOutputBufferPtr buf = xmlOutputBufferCreateBuffer(buffer, NULL);
  
	htmlNodeDumpOutput(buf, node->doc, node, (const char*)node->doc->encoding);
  
	xmlOutputBufferFlush(buf);
  
	NSString * string = nil;
  
	if (buffer->content) {
		string = [[[NSString alloc] initWithBytes:(const void *)xmlBufferContent(buffer) length:xmlBufferLength(buffer) encoding:NSUTF8StringEncoding] autorelease];
	}
  
	xmlOutputBufferClose(buf);
	xmlBufferFree(buffer);
  
	return string;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSString*)rawContents {
	return rawContentsOfNode(_node);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)nextSibling {
  return [[[NIHTMLElement alloc] initWithXMLNode:_node->next] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElement *)previousSibling {
  return [[[NIHTMLElement alloc] initWithXMLNode:_node->prev] autorelease];
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
  return [[[NIHTMLElement alloc] initWithXMLNode:_node->parent] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)children {
  xmlNode *cur_node = NULL;
	NSMutableArray * array = [NSMutableArray array]; 
  
	for (cur_node = _node->children; cur_node; cur_node = cur_node->next) {	
		NIHTMLElement * node = [[[NIHTMLElement alloc] initWithXMLNode:cur_node] autorelease];
		[array addObject:node];
	}
	return array;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NIHTMLElementType elementType(xmlNode * _node) {
	if (_node == NULL || _node->name == NULL)
		return NIHTMLElementTypeUnknown;
  
	const char * tagName = (const char*)_node->name;
	if (strcmp(tagName, "p") == 0)
		return NIHTMLElementTypeParagraph;
  else if (strcmp(tagName, "div") == 0)
		return NIHTMLElementTypeParagraph;
	else if (strcmp(tagName, "b") == 0)
		return NIHTMLElementTypeBold;
	else if (strcmp(tagName, "strong") == 0)
		return NIHTMLElementTypeBold;
	else if (strcmp(tagName, "i") == 0)
		return NIHTMLElementTypeItalic;
  else if (strcmp(tagName, "em") == 0)
		return NIHTMLElementTypeItalic;
  else if (strcmp(tagName, "a") == 0)
		return NIHTMLElementTypeLink;
	else
		return NIHTMLElementTypeUnknown;
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(NIHTMLElementType)elementType {
  return elementType(_node);
}


@end
