//
//  A1DeclareMacros.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import <objc/objc.h>


#pragma mark -

#define A1_SYNCHRONIZED_SELF_BEG \
        @synchronized (self) {

#define A1_SYNCHRONIZED_SELF_END \
        }

#pragma mark -

#define A1_ALLOC(Class) \
        (Class *)[Class alloc]

#define A1_AUTORELEASE(...) \
        (__typeof__ (__VA_ARGS__))[__VA_ARGS__ autorelease]

#define A1_COPY(...) \
        A1_AUTORELEASE ((__typeof__ (__VA_ARGS__))[__VA_ARGS__ copy])

#define A1_RETAIN(...) \
        (__typeof__ (__VA_ARGS__))[__VA_ARGS__ retain]

#define A1_RELEASE(v) \
        [v release]

#pragma mark -

/**
 A1_V (v, expr)
 
 <=>
 
 type-of-expr v = expr
 */
#define A1_V(v, ...) \
        __typeof__ (__VA_ARGS__) v = __VA_ARGS__;

#pragma mark -

/**
 A1_KCAST (Class, v, expr)
 
 <=>
 
 safe-kind-cast<Class>(expr)
 */
#define A1_KCAST(Class, ...) \
        (Class *)(__VA_ARGS__)

#define A1_CCAST(Protocol, ...) \
        (id<Protocol>)(__VA_ARGS__)

#define A1_IDKCAST(Class, ...) \
        A1_KCAST (Class, (id)(__VA_ARGS__))

#pragma mark -

/** 
 A1_ATV (foo, target) 
 
 <=>
 
 Foo *foo = [target foo]
 */
#define A1_ATV(v, t) \
        A1_V (v, [t v])

/** 
 A1_AV (foo) 
 
 <=>
 
 Foo *foo = [self foo]
 */
#define A1_AV(v) \
        A1_ATV (v, self)

//

#define A1_CUSTOM_INIT(Class, ...) \
        (Class *)[A1_ALLOC (Class) __VA_ARGS__]

#define A1_INIT(Class) \
        A1_CUSTOM_INIT (Class, init)

/**
 A1_CUSTOM_NEW (NSString, initWithData: data encoding: NSUTF8StringEncoding)
 
 is equivalent of
 
 (NSString *)[[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease]
 */
#define A1_CUSTOM_NEW(Class, ...) \
        A1_AUTORELEASE (A1_CUSTOM_INIT (Class, __VA_ARGS__))

#define A1_NEW(Class) \
        A1_CUSTOM_NEW (Class, init)

#pragma mark -

#define A1_NV(Class, v) \
        A1_V (v, A1_NEW (Class))

#define A1_CUSTOM_NV(Class, v, ...) \
        A1_V (v, A1_CUSTOM_NEW (Class, __VA_ARGS__))

#pragma mark -

#define A1_PROP_KEY(target, prop) \
        ([(__typeof__ (target))(nil) prop], @"" #prop)

#define A1_CLASS_PROP_KEY(cls, prop) \
        ([(cls *)(nil) prop], @"" #prop)

#define A1_SELF_KEY(prop) \
        A1_PROP_KEY (self, prop)

#pragma mark -

/** 
 $macro (target, foo)
 
 is selector-checking equivalent of
 
 @selector (foo)
 
 In other words, the only difference is that $macro verifies at
 compile-time that target responds to foo.
 */
#define A1_NO_ARG_SEL(target, sel) \
        ([(__typeof__(target))(id)nil sel], @selector(sel))

#pragma mark -

#define A1_DEFAULT_BUNDLE \
        ([NSBundle mainBundle])

#define A1_DEFAULT_BUNDLE_PATH \
        ([A1_DEFAULT_BUNDLE bundlePath])

#define A1_SELF_BUNDLE \
        ([NSBundle bundleForClass: [A1_SELF self]])

#define A1_DEFAULT_FILEMANAGER \
        ([NSFileManager defaultManager])

#define A1_DOCUMENTS \
        ([NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, \
                                              NSUserDomainMask, \
                                              YES) objectAtIndex: 0])

#define A1_IS_RESOURCE_IN_DOCUMENTS(resource) \
        ([A1_DEFAULT_FILEMANAGER fileExistsAtPath: [A1_DOCUMENTS stringByAppendingPathComponent: resource]]) \

#define A1_COPY_FROM_BUNDLE_TO_DOCUMENTS(resource, type) \
        ([A1_DEFAULT_FILEMANAGER copyItemAtPath:[A1_DEFAULT_BUNDLE \
                                                    pathForResource:resource \
                                                    ofType:type] \
          toPath:[A1_DOCUMENTS stringByAppendingPathComponent: resource] \
                                             error:nil])

#define A1_COPY_DIRECTORY_FROM_BUNDLE_TO_DOCUMENTS(...) \
        ([A1_DEFAULT_FILEMANAGER copyItemAtPath: A1_STRING_WITH_FORMAT (@"%@/%@", A1_DEFAULT_BUNDLE_PATH, __VA_ARGS__) \
                                         toPath: [A1_DOCUMENTS stringByAppendingPathComponent: userConfig] \
                                          error: nil])

#define A1_BUNDLE_RESOURCE_PATH(resource, type) \
        [A1_DEFAULT_BUNDLE pathForResource:resource ofType:type]

#define A1_DEFAULT_NOTIFICATION_CENTER \
        [NSNotificationCenter defaultCenter]
