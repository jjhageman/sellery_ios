//
//  A1PropMacros.h
//
//  Created by Sergey Simonov on 27.09.09.
//  Copyright 2010. All rights reserved.
//


#import <boost/preprocessor/repetition.hpp>
#import <boost/preprocessor/seq.hpp>
#import <boost/preprocessor/seq/for_each.hpp>


#define A1_PP_PROP_IVARS(...) \
    BOOST_PP_SEQ_FOR_EACH (A1_PP_PROP_IVAR_ELEM, _, __VA_ARGS__)

#define A1_PP_PROPS(...) \
    BOOST_PP_SEQ_FOR_EACH (A1_PP_PROP_ELEM, _, __VA_ARGS__)

#define A1_PP_SYNTHESIZE(...) \
    BOOST_PP_SEQ_FOR_EACH (A1_PP_SYNTHESIZE_ELEM, _, __VA_ARGS__)

#define A1_PP_RELEASE_PROPS(...) \
    BOOST_PP_SEQ_FOR_EACH (A1_PP_RELEASE_PROP_ELEM, _, __VA_ARGS__)

/*
    A1_SELF_XXX
 */

#define A1_SELF_P \
    BOOST_PP_SEQ_CAT ((A1_SELF)(F))

#define A1_SELF_NP \
    BOOST_PP_SEQ_CAT ((A1_SELF)(NF))

#define A1_PP_SELF_SYNTHESIZE \
    A1_PP_SYNTHESIZE (A1_SELF_P)

#define A1_PP_SELF_SYNTHESIZE_N \
    A1_PP_SYNTHESIZE (A1_SELF_NP)

#define A1_PP_RELEASE_SELF_PROPS \
    A1_PP_RELEASE_PROPS (A1_SELF_P)

#define A1_PP_SELF_PROP_DEALLOC \
\
- (void) dealloc; \
{ \
    A1_PP_RELEASE_SELF_PROPS; \
    \
    [super dealloc]; \
}

#define A1_PP_SELF_SYNTHESIZE_AND_DEALLOC \
    A1_PP_SELF_SYNTHESIZE; \
    A1_PP_SELF_SYNTHESIZE_N; \
    A1_PP_SELF_PROP_DEALLOC;

/*
 */

#define A1_PP_RELEASE_PROP_ELEM(r, data, prop) \
    self.BOOST_PP_SEQ_HEAD (prop) = nil;

#define A1_PP_SYNTHESIZE_ELEM(r, data, prop) \
    @synthesize BOOST_PP_SEQ_HEAD (prop) = BOOST_PP_CAT (_, BOOST_PP_SEQ_HEAD (prop));

#define A1_PP_EXPAND_PAREN(macro, paren) \
    macro paren

#define A1_PP_IDENTITY(...) \
    __VA_ARGS__

#define A1_PP_EXPAND_SEQ(seq) \
    A1_PP_EXPAND_PAREN (A1_PP_IDENTITY, seq)

#define A1_PP_PROP_IVAR_ELEM(r, data, prop) \
    A1_PP_EXPAND_SEQ (BOOST_PP_SEQ_ELEM (2, prop)) \
    BOOST_PP_CAT (_, BOOST_PP_SEQ_HEAD (prop));

#define A1_PP_PROP_ELEM(r, data, prop) \
    @property \
    BOOST_PP_SEQ_ELEM (1, prop) \
    A1_PP_EXPAND_SEQ (BOOST_PP_SEQ_ELEM (2, prop)) \
    BOOST_PP_SEQ_HEAD (prop);

/*
 */

#define A1_PP_SET_PROP(prop) \
    [prop retain]; \
    [_ ## prop release]; \
    _ ## prop = prop

#define A1_PP_SET_PROP_COPY(prop) \
    [_ ## prop autorelease]; \
    _ ## prop = [prop copy];

#define A1_PP_SET_PROP_CFRETAIN(prop) \
	if (prop) { \
		CFRetain (prop); \
	} \
	if (_ ## prop) { \
		CFRelease (_ ## prop); \
	} \
	_ ## prop = prop
