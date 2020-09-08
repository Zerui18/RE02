//
//  ProcList.c
//  RE02
//
//  Created by Zerui Chen on 8/9/20.
//

#include <stdlib.h>
#include <errno.h>
#include "ProcList.h"

int getBSDProcessList(struct kinfo_proc const **procList, size_t *procCount) {
    static const int names[] = { CTL_KERN, KERN_PROC, KERN_PROC_ALL , 0};
    struct kinfo_proc *result;
    size_t length;
    
    *procCount = 0;
    while (1) {
        // Get size.
        sysctl((int *) names, 4, NULL, &length, NULL, 0);
        // Allocate and request data.
        result = malloc(length);
        if (sysctl((int *) names, 4, result, &length, NULL, 0) == -1) {
            // Fail.
            // Free result.
            free(result);
            result = NULL;
            if (errno != ENOMEM) {
                // Return errno.
                return errno;
            }
            // Else loop.
        }
        else {
            // Success.
            *procList = result;
            *procCount = length / sizeof(struct kinfo_proc);
            return 0;
        }
    }
}
