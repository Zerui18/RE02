//
//  ProcList.h
//  RE02
//
//  Created by Zerui Chen on 8/9/20.
//

#include <sys/sysctl.h>

int getBSDProcessList(struct kinfo_proc const * _Nonnull * _Nonnull procList, size_t * _Nonnull procCount);
