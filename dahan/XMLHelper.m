//
//  XMLHelper.m
//  pgapp
//
//  Created by 陈 利群 on 14-3-16.
//
//

#import "XMLHelper.h"

NSString *const kXMLHelperTextNodeKey = @"text";

@implementation XMLHelper

@synthesize errorPointer;
@synthesize dictionaryStackMbAry;
@synthesize textInProgressMbStr;

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)error
{
    XMLHelper *helper = [[XMLHelper alloc] initWithError:error];
    NSDictionary *rootDictionary = [helper objectWithData:data];
   // NSDictionary* textDic = [[[[[rootDictionary objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"UserLoginResponse"] objectForKey:@"UserLoginResult"] objectForKey:@"text"];
    return rootDictionary;
}

+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)error
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [XMLHelper dictionaryForXMLData:data error:error];
}

- (id)initWithError:(NSError *)error
{
    if (self = [super init])
    {
        errorPointer = error;
    }
    return self;
}

- (NSDictionary *)objectWithData:(NSData *)data
{
    // Clear out any old data
    
    dictionaryStackMbAry = [[NSMutableArray alloc] init];
    textInProgressMbStr = [[NSMutableString alloc] init];
    
    // Initialize the stack with a fresh dictionary
    [dictionaryStackMbAry addObject:[NSMutableDictionary dictionary]];
    
    // Parse the XML
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    BOOL success = [parser parse];
    
    // Return the stack’s root dictionary on success
    if (success)
    {
        NSDictionary *resultDict = [dictionaryStackMbAry objectAtIndex:0];
        return resultDict;
    }
    
    return nil;
}

#pragma mark -
#pragma mark NSXMLParserDelegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    // Get the dictionary for the current level in the stack
    NSMutableDictionary *parentDict = [dictionaryStackMbAry lastObject];
    
    // Create the child dictionary for the new element, and initilaize it with the attributes
    NSMutableDictionary *childDict = [NSMutableDictionary dictionary];
    [childDict addEntriesFromDictionary:attributeDict];
    
    // If there’s already an item for this key, it means we need to create an array
    id existingValue = [parentDict objectForKey:elementName];
    if (existingValue)
    {
        NSMutableArray *array = nil;
        if ([existingValue isKindOfClass:[NSMutableArray class]])
        {
            // The array exists, so use it
            array = (NSMutableArray *) existingValue;
        }
        else
        {
            // Create an array if it doesn’t exist
            array = [NSMutableArray array];
            [array addObject:existingValue];
            
            // Replace the child dictionary with an array of children dictionaries
            [parentDict setObject:array forKey:elementName];
        }
        
        // Add the new child dictionary to the array
        [array addObject:childDict];
    }
    else
    {
        // No existing value, so update the dictionary
        [parentDict setObject:childDict forKey:elementName];
    }
    
    // Update the stack
    [dictionaryStackMbAry addObject:childDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    // Update the parent dict with text info
    NSMutableDictionary *dictInProgress = [dictionaryStackMbAry lastObject];
    
    // Set the text property
    if ([textInProgressMbStr length] > 0)
    {
        // Get rid of leading + trailing whitespace
        [dictInProgress setObject:textInProgressMbStr forKey:kXMLHelperTextNodeKey];
        
        // Reset the text
        textInProgressMbStr = nil;
        textInProgressMbStr = [[NSMutableString alloc] init];
    }
    
    // Pop the current dict
    [dictionaryStackMbAry removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    // Build the text value
    [textInProgressMbStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // Set the error pointer to the parser’s error object
    errorPointer = parseError;
}



@end
