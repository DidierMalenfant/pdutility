/*
 *  pdutility - Handy utility functions for Playdate development.
 *
 *  MIT License
 *  Copyright (c) 2022 Didier Malenfant.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */
 
#ifndef PDUTILITY_PLATFORM_H
#define PDUTILITY_PLATFORM_H

#include "pd_api.h"

// -- Globals
extern PlaydateAPI* pd;

// -- Utility macros
#ifndef PD_ALLOC
#define PD_ALLOC(size)           pd->system->realloc(NULL, (size))
#endif

#ifndef PD_FREE
#define PD_FREE(mem)             pd->system->realloc((mem), 0)
#endif

#ifndef PD_LOG
    #if 0
        #define PD_LOG(format, ...)         pd->system->logToConsole((s), ##__VA_ARGS__)
    #else
        #define PD_LOG(format, args...)     do { } while(0)
    #endif
#endif

#ifndef PD_DBG_LOG
    #if 0
        #define PD_DBG_LOG                  PD_LOG
    #else
        #define PD_DBG_LOG(format, args...) do { } while(0)
    #endif
#endif

// -- Utility functions
void register_pdutility(PlaydateAPI* playdate);
void* pd_calloc(size_t nb_of_items, size_t item_size);

#endif
