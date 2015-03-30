//
//  YumYum2Macros.h
//  YumYum2
//
//  Created by PhantomDestroyer on 3/26/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#ifndef YumYum2_YumYum2Macros_h
#define YumYum2_YumYum2Macros_h

extern NSString * const
ManagedObjectContextSaveDidFailNotification;

#define FATAL_CORE_DATA_ERROR(__error__)\
NSLog(@"*** Fatal error in %s:%d\n%@\n%@",\
__FILE__, __LINE__, error, [error userInfo]);\
[[NSNotificationCenter defaultCenter] postNotificationName:\
ManagedObjectContextSaveDidFailNotification object:error];

#endif
