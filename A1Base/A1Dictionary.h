//
//  A1Dictionary.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

#define A1_DICTIONARY(...) \
        ((NSDictionary *) [NSDictionary dictionaryWithObjectsAndKeys: __VA_ARGS__, nil])

#define A1_DICTIONARY_WITH_DICTIONARY(object) \
        ((NSDictionary *) [NSDictionary dictionaryWithDictionary: (NSDictionary *)object])

#define A1_MUTABLE_DICTIONARY_WITH_DICTIONARY(object) \
        ((NSMutableDictionary *) [NSMutableDictionary dictionaryWithDictionary: (NSDictionary *)object])

#define A1_DICTIONARY_WITH_OBJECT_FOR_KEY(object, key) \
        ((NSDictionary *) [NSDictionary dictionaryWithObject: object forKey: key])

#define A1_DICTIONARY_WITH_OBJECTS_FOR_KEYS(objects, keys) \
        ((NSDictionary *) [NSDictionary dictionaryWithObjects: objects forKeys: keys])

#define A1_MUTABLE_DICTIONARY_WITH_OBJECTS_FOR_KEYS(objects, keys) \
        ((NSMutableDictionary *) [NSMutableDictionary dictionaryWithObjects: objects forKeys: keys])

#define A1_DICTIONARY_WITH_CONTENTS_OF_FILE(...) \
        ((NSDictionary *) [NSDictionary dictionaryWithContentsOfFile: __VA_ARGS__])

#define A1_DICTIONARY_WITH_CONTENTS_OF_PLIST(resource) \
        ((NSDictionary *) [NSDictionary dictionaryWithContentsOfFile: [A1_DEFAULT_BUNDLE pathForResource:resource ofType:@"plist"]])
