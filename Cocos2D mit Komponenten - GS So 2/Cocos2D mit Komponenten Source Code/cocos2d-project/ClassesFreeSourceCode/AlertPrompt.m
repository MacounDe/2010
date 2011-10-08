//
//  AlertPrompt.m
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.

// see his blog post:
// http://iphonedevelopment.blogspot.com/2009/02/alert-view-with-prompt.html

#import "AlertPrompt.h"

#import "cocos2d.h"

@implementation AlertPrompt

@synthesize textField;
@synthesize enteredText;

-(id) initWithTitle:(NSString*)title delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle okButtonTitle:(NSString*)okayButtonTitle textFieldText:(NSString*)textFieldText
{
	// this is just to make the AlertView size bigger (more height)
	NSString* twoLines = @"                                            ";
    if ((self = [super initWithTitle:title message:twoLines delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil]))
    {
        UITextField* theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f, 66.0f, 260.0f, 25.0f)];
		[theTextField setText:textFieldText];
        [theTextField setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0f, 95.0f);
        [self setTransform:translate];
    }
    return self;
}

-(void) show
{
    [textField becomeFirstResponder];
    [super show];
}

-(NSString*) enteredText
{
    return textField.text;
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);

    [textField release];
    [super dealloc];
}

@end
