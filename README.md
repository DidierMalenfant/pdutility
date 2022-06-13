# pdutility for Playdate

Handy utility functions for Playdate development. These can be shared between projects to avoid code duplication.

v0.2-alpha June 13th 2022

## Globals

`PlaydateAPI* pd` - Shortcut used to call Playdate API methods (for example `pd->system->logToConsole()`). This relies on `pd_init()` being called first.

## Macros

`PD_ALLOC(size)` - Allocate memory of the given `size`. Returns `NULL` if allocation fails.

`PD_FREE(mem)` - Free memory at `mem`.

`PD_LOG(format)` - Print log message to the console. Can be turned off in the header.

`PD_DBG_LOG(format)` - Print debug log message to the console. Can also be turned off in the header, separately from `PD_LOG`.

## Functions

`void pd_init(PlaydateAPI* playdate)` - Initialize the utility system. Ideally called before anything else, like in a `kEventInitLua` event.

`void* pd_calloc(size_t nb_of_items, size_t item_size)` - Allocates and sets to 0 memory for `nb_of_items` items, each of size `size`. This is safer that using `PD_ALLOC(nb_of_items * item_size)` because it does test for any overrun caused by the multiplication.



* * *

Copyright (c) 2022 Didier Malenfant
