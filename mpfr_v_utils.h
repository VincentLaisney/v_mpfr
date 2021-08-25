// mpfr_v_utils.h

#ifndef __MPFR_V_UTILS_H__
#define __MPFR_V_UTILS_H__

static int mpfr_ternary_retval;

inline static int get_retval (void) {
    return mpfr_ternary_retval;
}

inline static void set_retval (int retval) {
    mpfr_ternary_retval = retval;
}

#endif