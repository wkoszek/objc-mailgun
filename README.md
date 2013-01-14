objc-mailgun
============

Objective-C SDK for Mailgun

Usage:
======

    Mailgun *mailgun = [Mailgun client];
    [mailgun setDomain:@"mailguntest.mailgun.org"];
    [mailgun setAPIKey:@"key-3ax6xnjp29jd6fds4gc373sgvjxteol0"];
    
    MGMessage *message = [[MGMessage alloc] initWithFrom:@"Jay Baird <jay.baird@rackspace.com>"
                                                      to:@"Steve Brown <steve.brown@rackspace.com>"
                                                 subject:@"Mailgun"
                                                    body:@"Mailgun is neat. You should check it out."];
    [message addBcc:@"Joe Smith <joe.smith@rackspace.com>"];
    [message addImage:[UIImage imageNamed:@"attachment.png"] withName:@"attachment.png" type:PNGFileType];
    [mailgun sendMessage:message];