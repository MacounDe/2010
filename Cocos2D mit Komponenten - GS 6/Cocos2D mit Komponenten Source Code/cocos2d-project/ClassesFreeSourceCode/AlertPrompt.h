//
//  AlertPrompt.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.

// see his blog post:
// http://iphonedevelopment.blogspot.com/2009/02/alert-view-with-prompt.html


#import <Foundation/Foundation.h>

@interface AlertPrompt : UIAlertView 
{
    UITextField *textField;
	NSString* enteredText; // dummy to avoid warning
}

@property (nonatomic, retain) UITextField* textField;
@property (readonly) NSString* enteredText;

-(id) initWithTitle:(NSString*)title delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okButtonTitle textFieldText:(NSString*)textFieldText;

@end
