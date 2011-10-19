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

#import <Foundation/Foundation.h>
#import <libxml/HTMLparser.h>

typedef enum {
  
  NIHTMLElementTypeUnknown,
  NIHTMLElementTypeP,
  NIHTMLElementTypeDiv,
  NIHTMLElementTypeStrong
  
} NIHTMLElementType;

@interface NIHTMLElement : NSObject {
  xmlNode* _node;
}

// Init with a lib xml node (shouldn't need to be called manually)
// Use [parser doc] to get the root Node
-(id) initWithXMLNode:(xmlNode*) xmlNode;

// Returns a single child of class
-(NIHTMLElement*) findChildOfClass:(NSString*) className;

// Returns all children of class
-(NSArray*) findChildrenOfClass:(NSString*) className;

// Finds a single child with a matching attribute 
// set allowPartial to match partial matches 
// e.g. <img src="http://www.google.com> 
// [findChildWithAttribute:@"src" matchingValue:"google.com" allowPartial:TRUE]
-(NIHTMLElement*) findChildWithAttribute:(NSString*) attribute 
                           matchingValue:(NSString*) matchingValue 
                            allowPartial:(BOOL) partial;

// Finds all children with a matching attribute
-(NSArray*) findChildrenWithAttribute:(NSString*) attribute 
                        matchingValue:(NSString*) matchingValue 
                         allowPartial:(BOOL) partial;

// Gets the attribute value matching tha name
-(NSString*) getAttributeNamed:(NSString*) name;

// Find childer with the specified tag name
-(NSArray*) findChildTags:(NSString*) tagName;

// Looks for a tag name e.g. "h3"
-(NIHTMLElement*) findChildTag:(NSString*) tagName;

// Returns the first child element
-(NIHTMLElement*) firstChild;

// Returns the plaintext contents of node
-(NSString*) contents;

// Returns the plaintext contents of this node + all children
-(NSString*) allContents;

// Returns the html contents of the node 
-(NSString*)rawContents;

// Returns next sibling in tree
-(NIHTMLElement*) nextSibling;

// Returns previous sibling in tree
-(NIHTMLElement*)previousSibling;

// Returns the class name
-(NSString*)className;

// Returns the tag name
-(NSString*)tagName;

// Returns the parent
-(NIHTMLElement*)parent;

//Returns the first level of children
-(NSArray*)children;

//Returns the element type if know
-(NIHTMLElementType)elementType;

// C functions for minor performance increase in tight loops
NSString * getAttributeNamed(xmlNode * node, const char * nameStr);
void setAttributeNamed(xmlNode * node, const char * nameStr, const char * value);
NIHTMLElementType nodeType(xmlNode* node);
NSString * allNodeContents(xmlNode*node);
NSString * rawContentsOfNode(xmlNode * node);

@end
