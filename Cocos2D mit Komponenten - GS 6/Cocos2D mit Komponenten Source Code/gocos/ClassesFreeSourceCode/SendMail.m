//
//  SendMail.m
//
//  Created by Steffen Itterheim on 26.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import "SendMail.h"

#import "CocoaHelper.h"
#import "LocaleHelper.h"
#import "Screenshot.h"


@interface SendMail (Private)
-(void) loadView;
-(void) displayMailComposer;
@end

@implementation SendMail

@synthesize msgTo, msgSubject, msgBody, msgAttachmentMimeType, msgAttachmentFileName;
@synthesize msgAttachmentData;
@synthesize isHTMLBody;

+(bool) canSendInAppMail
{
	bool result = false;
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		// We must always check whether the current device is configured for sending emails
		if ([mailClass canSendMail])
		{
			result = true;
		}
	}
	
	return result;
}

+(id) sendWithDelegate:(NSObject<SendMailDelegate>*)del
{
	return [[[self alloc] initSendMailWithDelegate:del] autorelease];
}

-(id) initSendMailWithDelegate:(NSObject<SendMailDelegate>*)del
{
	if ((self = [super init]))
	{
		delegate = del;
		[self loadView];
	}
	
	return self;
}

+(id) send
{
	return [self sendWithDelegate:nil];
}

-(id) init
{
	return [self initSendMailWithDelegate:nil];
}

-(void) dealloc
{
	CCLOG(@"dealloc %@", self);
	delegate = nil;
	[super dealloc];
}

-(void) loadView
{
	UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	view.backgroundColor = [UIColor clearColor];
	view.clearsContextBeforeDrawing = YES;
	view.opaque = NO;

	view.center = CGPointMake(240, 160);
	[view setTransform:CGAffineTransformMakeRotation((float)M_PI_2)];
	
	self.view = view;
	[view release];
}

-(void) displayMailComposer
{
	if ([MFMailComposeViewController canSendMail])
	{
		picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		
		if ([msgTo length] != 0)
		{
			[picker setToRecipients:[NSArray arrayWithObject:msgTo]];
		}
		
		[picker setSubject:msgSubject];
		[picker setMessageBody:msgBody isHTML:NO];

		if ([msgAttachmentData length] != 0)
		{
			[picker addAttachmentData:msgAttachmentData mimeType:msgAttachmentMimeType fileName:msgAttachmentFileName];
			[msgAttachmentData release];
			msgAttachmentData = nil;
		}
		
		[self.view addSubview:picker.view];
		[self presentModalViewController:picker animated:YES];
	}
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight) || (interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}

-(void) mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	[self dismissModalViewControllerAnimated:NO];
	//CCLOG(@"self %@ = %@ controller --- controller view: %@ superview: %@", self, controller, controller.view, controller.view.superview);
	
	[picker.view removeFromSuperview];
	[picker release];
	picker = nil;
	
	[delegate onSendMailFinished];
}

+(void) showEmailNotSetupAlertView
{
	UIAlertView *alert = [[UIAlertView alloc] init];

	NSString* title = NSLocalizedStringFromTable(@"SendMail_EmailNotSetup_Title", [LocaleHelper getLanguageTable], @"Messagebox title for 'no email account set up' error");
	NSString* message = NSLocalizedStringFromTable(@"SendMail_EmailNotSetup_Message", [LocaleHelper getLanguageTable], @"Messagebox message for 'no email account set up' error");
	NSString* button = NSLocalizedStringFromTable(@"SendMail_EmailNotSetup_Button", [LocaleHelper getLanguageTable], @"Messagebox 'OK' button for 'no email account set up' error");
	
	[alert setTitle:title];
	[alert setMessage:message];
	[alert addButtonWithTitle:button];
	[alert show];
	[alert release];
}

@end
