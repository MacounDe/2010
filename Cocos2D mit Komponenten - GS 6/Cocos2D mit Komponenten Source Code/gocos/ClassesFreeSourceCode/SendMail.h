//
//  SendMail.h
//
//  Created by Steffen Itterheim on 26.11.09.
//  Copyright 2009 Steffen Itterheim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol SendMailDelegate
-(void) onSendMailFinished;
@end


@interface SendMail : UIViewController <MFMailComposeViewControllerDelegate>
{
	NSString* msgTo;
	NSString* msgSubject;
	NSString* msgBody;
	bool isHTMLBody;
	
	NSString* msgAttachmentMimeType;
	NSString* msgAttachmentFileName;
	NSData* msgAttachmentData;
	
	NSObject<SendMailDelegate>* delegate;
	
	MFMailComposeViewController* picker;
}

@property (readwrite, copy, nonatomic) NSString* msgTo;
@property (readwrite, copy, nonatomic) NSString* msgSubject;
@property (readwrite, copy, nonatomic) NSString* msgBody;
@property (readwrite, copy, nonatomic) NSString* msgAttachmentMimeType;
@property (readwrite, copy, nonatomic) NSString* msgAttachmentFileName;
@property (readwrite, retain, nonatomic) NSData* msgAttachmentData;
@property (readwrite, nonatomic) bool isHTMLBody;

+(bool) canSendInAppMail;
+(void) showEmailNotSetupAlertView;

+(id) send;
-(id) init;
+(id) sendWithDelegate:(NSObject<SendMailDelegate>*)del;
-(id) initSendMailWithDelegate:(NSObject<SendMailDelegate>*)del;
-(void) displayMailComposer;

@end
