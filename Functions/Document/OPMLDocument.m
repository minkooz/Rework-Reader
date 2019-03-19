//
//  OPMLDocument.m
//  rework-reader
//
//  Created by 张超 on 2019/3/14.
//  Copyright © 2019 orzer. All rights reserved.
//

#import "OPMLDocument.h"
@import KissXML;
@interface OPMLDocument ()
@property (nonatomic, strong) NSMutableString* content;
@property (nonatomic, strong) DDXMLDocument* xmlDocument;

@property (nonatomic, strong) NSString* title;

@end

@implementation OPMLOutline

- (instancetype)initWithElement:(DDXMLElement*)element
{
    self = [super init];
    if (self) {
//        NSLog(@"%@",element);
        NSDictionary* d = [element attributesAsDictionary];
//        NSLog(@"%@",d);
        self.text = d[@"text"];
        self.title = d[@"title"];
        self.type = d[@"type"];
        self.xmlUrl = d[@"xmlUrl"];
        self.htmlUrl = d[@"htmlUrl"];
        
        NSMutableArray* m = [[NSMutableArray alloc] init];
        NSArray* a = [element elementsForName:@"outline"];
        [a enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OPMLOutline* o = [[OPMLOutline alloc] initWithElement:obj];
            [m addObject:o];
        }];
        self.subOutlines = [m copy];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@ %@ child:%@",[super description],self.text,self.title,@(self.subOutlines.count)];
}

@end

@implementation OPMLDocument

- (NSMutableString *)content
{
    if (!_content) {
        _content = [[NSMutableString alloc] init];
    }
    return _content;
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError
{
    NSString* s = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
    if (s) {
        [self.content setString:s];
        self.xmlDocument = [[DDXMLDocument alloc] initWithXMLString:self.content options:DDXMLDocumentXMLKind error:outError];
        DDXMLElement* root = self.xmlDocument.rootElement;
        DDXMLElement* headElement = [root elementForName:@"head"];
        if ([headElement childCount] == 1) {
            self.headTitle = headElement.stringValue;
        }
        else {
            DDXMLElement* title = [headElement elementForName:@"title"];
            if (title) {
                self.headTitle = [title stringValue];
            }
        }
        DDXMLElement* bodyElement = [root elementForName:@"body"];
        NSArray* temp = [self outlineWithNode:bodyElement];
        self.outlines = [temp mutableCopy];
    }
    return YES;
}

- (NSArray*)outlineWithNode:(DDXMLElement*)element
{
    NSMutableArray* array = [[NSMutableArray alloc] init];
    NSArray* temp = [element elementsForName:@"outline"];
    [temp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//        NSArray* t = [self outlineWithNode:obj];
        OPMLOutline* outline = [[OPMLOutline alloc] initWithElement:obj];
        [array addObject:outline];
//        if (t && t.count > 0) {
//            [array addObject:t];
//        }
    }];
    return [array copy];
}

- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError
{
    return [self.content dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)handleError:(NSError *)error userInteractionPermitted:(BOOL)userInteractionPermitted
{
    NSLog(@"%@",error);
    
}

- (void)finishedHandlingError:(NSError *)error recovered:(BOOL)recovered
{
    NSLog(@"%@",error);
}

- (void)userInteractionNoLongerPermittedForError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
