//
// Copyright 2011 Roger Chapman
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

#import "HtmlViewController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HtmlViewController
@synthesize htmlLabel;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  return [super initWithNibName:@"HtmlView" bundle:nibBundleOrNil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
  NI_RELEASE_SAFELY(htmlLabel);
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)viewDidLoad {
  
  self.title = @"HTML to Attributed Label";
  
  NSString *html = @"<p>This is some text with a <b>Bold</b> bit of text</p><p>Second Paragraph with <i>italic and <u>underlined</u></i></p><p>Lets add in a <a href=\"www.google.com\">link</a> for good messure</p>";
  
  NIHTMLParser *parser = [[NIHTMLParser alloc] initWithString:html];
  
  NSAttributedString* attrString = [parser.body attributedString];
    
  htmlLabel.attributedString = attrString;
  
}

@end
