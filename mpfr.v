// MIT License

// Copyright (c) 2021 Vincent Laisney

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

module mpfr

import gmp
import math.mathutil

#flag -lgmp -lmpfr
#flag @VMODROOT/mpfr_v_utils.o
#flag -I @VMODROOT
#include "mpfr.h"
#include "mpfr_v_utils.h"


/* Flags macros (in the public API) */
const (
	flags_underflow = 1
	flags_overflow = 2
	flags_nan = 4
	flags_inexact = 8
	flags_erange = 16
	flags_divby0 = 32
	flags_all = (flags_underflow | flags_overflow | flags_nan | flags_inexact | flags_erange | flags_divby0)
)

pub enum Round {
	rndn=0  /* round to nearest, with ties to even */
	rndz    /* round toward zero */
	rndu    /* round toward +Inf */
	rndd    /* round toward -Inf */
	rnda    /* round away from zero */
	rndf    /* faithful rounding */
	rndna=-1 /* round to nearest, with ties away from zero (mpfr_round) */
}

const (
	mpfr_prec_min = 1
	mpfr_prec_max = i64(((u64 (-1) >> 1) - 256))
	/* Definition of the standard exponent limits */
	mpfr_emax_default = i64((u64(1) << 30) - 1)
	mpfr_emin_default = (-(mpfr_emax_default))
)

/* Definition of the main structure */
struct C.__mpfr_struct {
	_mpfr_prec  i64
	_mpfr_sign  int
	_mpfr_exp   i64
	_mpfr_d  &u64
}

pub type Bigfloat = C.__mpfr_struct

pub type Mpfr_prec = i64
pub type Mpfr_exp = i64

// typedef __mpfr_struct mpfr_t[1]
// typedef __mpfr_struct *&Bigfloat
// typedef __mpfr_struct *&Bigfloat

/* Stack interface */
// typedef enum {
//   MPFR_NAN_KIND     = 0,
//   MPFR_INF_KIND     = 1,
//   MPFR_ZERO_KIND    = 2,
//   MPFR_REGULAR_KIND = 3
// } mpfr_kind_t

fn init() {
	gmp.mp_set_memory_functions(gmp.my_malloc, gmp.my_realloc, gmp.my_free)
}

// statics functions from mpfr_v_utils.h
fn C.get_retval () int

fn C.set_retval (int)

pub fn set_retval(r int) {
	C.set_retval(r)
}

pub fn get_retval() int {
	return C.get_retval()
}

struct MathContext {
	prec Mpfr_prec
	flags u64
	rnd Round
}

[inline]
pub fn get_def_math_ctx() MathContext {
	return MathContext {
		prec: get_default_prec()
		flags: 0
		rnd: .rndn
	}
}

fn C.mpfr_get_version () &char

pub fn get_version () &char {
	return C.mpfr_get_version ()
}

fn C.mpfr_get_patches () &char

pub fn get_patches () &char {
	return C.mpfr_get_patches ()
}


fn C.mpfr_buildopt_tls_p () int

pub fn buildopt_tls_p () int {
	return C.mpfr_buildopt_tls_p ()
}

fn C.mpfr_buildopt_float128_p () int

pub fn buildopt_float128_p () int {
	return C.mpfr_buildopt_float128_p ()
}

fn C.mpfr_buildopt_decimal_p () int

pub fn buildopt_decimal_p () int {
	return C.mpfr_buildopt_decimal_p ()
}

fn C.mpfr_buildopt_gmpinternals_p () int

pub fn buildopt_gmpinternals_p () int {
	return C.mpfr_buildopt_gmpinternals_p ()
}

fn C.mpfr_buildopt_sharedcache_p () int

pub fn buildopt_sharedcache_p () int {
	return C.mpfr_buildopt_sharedcache_p ()
}

fn C.mpfr_buildopt_tune_case () &char

pub fn buildopt_tune_case () &char {
	return C.mpfr_buildopt_tune_case ()
}


fn C.mpfr_get_emin () i64

pub fn get_emin () i64 {
	return C.mpfr_get_emin ()
}

fn C.mpfr_set_emin (i64) int

pub fn set_emin (e i64) int {
	return C.mpfr_set_emin (e)
}

fn C.mpfr_get_emin_min () i64

pub fn get_emin_min () i64 {
	return C.mpfr_get_emin_min ()
}

fn C.mpfr_get_emin_max () i64

pub fn get_emin_max () i64 {
	return C.mpfr_get_emin_max ()
}

fn C.mpfr_get_emax () i64

pub fn get_emax () i64 {
	return C.mpfr_get_emax ()
}

fn C.mpfr_set_emax (i64) int

pub fn set_emax (e i64) int {
	return C.mpfr_set_emax (e)
}

fn C.mpfr_get_emax_min () i64

pub fn get_emax_min () i64 {
	return C.mpfr_get_emax_min ()
}

fn C.mpfr_get_emax_max () i64

pub fn get_emax_max () i64 {
	return C.mpfr_get_emax_max ()
}


fn C.mpfr_set_default_rounding_mode (Round)

pub fn set_default_rounding_mode (rnd Round) {
	C.mpfr_set_default_rounding_mode (rnd)
}

fn C.mpfr_get_default_rounding_mode () Round

pub fn get_default_rounding_mode () Round {
	return C.mpfr_get_default_rounding_mode ()
}

fn C.mpfr_print_rnd_mode (Round) &char

pub fn print_rnd_mode (rnd Round) &char {
	return C.mpfr_print_rnd_mode (rnd)
}


fn C.mpfr_clear_flags ()

pub fn clear_flags () {
	C.mpfr_clear_flags ()
}

fn C.mpfr_clear_underflow ()

pub fn clear_underflow () {
	C.mpfr_clear_underflow ()
}

fn C.mpfr_clear_overflow ()

pub fn clear_overflow () {
	C.mpfr_clear_overflow ()
}

fn C.mpfr_clear_divby0 ()

pub fn clear_divby0 () {
	C.mpfr_clear_divby0 ()
}

fn C.mpfr_clear_nanflag ()

pub fn clear_nanflag () {
	C.mpfr_clear_nanflag ()
}

fn C.mpfr_clear_inexflag ()

pub fn clear_inexflag () {
	C.mpfr_clear_inexflag ()
}

fn C.mpfr_clear_erangeflag ()

pub fn clear_erangeflag () {
	C.mpfr_clear_erangeflag ()
}


fn C.mpfr_set_underflow ()

pub fn set_underflow () {
	C.mpfr_set_underflow ()
}

fn C.mpfr_set_overflow ()

pub fn set_overflow () {
	C.mpfr_set_overflow ()
}

fn C.mpfr_set_divby0 ()

pub fn set_divby0 () {
	C.mpfr_set_divby0 ()
}

fn C.mpfr_set_nanflag ()

pub fn set_nanflag () {
	C.mpfr_set_nanflag ()
}

fn C.mpfr_set_inexflag ()

pub fn set_inexflag () {
	C.mpfr_set_inexflag ()
}

fn C.mpfr_set_erangeflag ()

pub fn set_erangeflag () {
	C.mpfr_set_erangeflag ()
}


fn C.mpfr_underflow_p () int

pub fn underflow_p () bool {
	return C.mpfr_underflow_p () != 0
}

fn C.mpfr_overflow_p () int

pub fn overflow_p () bool {
	return C.mpfr_overflow_p () != 0
}

fn C.mpfr_divby0_p () int

pub fn divby0_p () bool {
	return C.mpfr_divby0_p () != 0
}

fn C.mpfr_nanflag_p () int

pub fn nanflag_p () bool {
	return C.mpfr_nanflag_p () != 0
}

fn C.mpfr_inexflag_p () int

pub fn inexflag_p () bool {
	return C.mpfr_inexflag_p () != 0
}

fn C.mpfr_erangeflag_p () int

pub fn erangeflag_p () bool {
	return C.mpfr_erangeflag_p () != 0
}


fn C.mpfr_flags_clear (u32)

pub fn flags_clear (f u32) {
	C.mpfr_flags_clear (f)
}

fn C.mpfr_flags_set (u32)

pub fn flags_set (f u32) {
	C.mpfr_flags_set (f)
}

fn C.mpfr_flags_test (u32) u32

pub fn flags_test (f u32) u32 {
	return C.mpfr_flags_test (f)
}

fn C.mpfr_flags_save () u32

pub fn flags_save () u32 {
	return C.mpfr_flags_save ()
}

fn C.mpfr_flags_restore (u32,u32)

pub fn flags_restore (f u32, g u32) {
	C.mpfr_flags_restore (f, g)
}


fn C.mpfr_check_range (&Bigfloat, int, Round) int

pub fn check_range (mut a Bigfloat, b int, r Round) int {
	return C.mpfr_check_range (&a, b, r)
}


fn C.mpfr_init2 (&Bigfloat, Mpfr_prec)

pub fn init2 (mut a Bigfloat, p Mpfr_prec) {
	C.mpfr_init2 (&a, p)
}

fn C.mpfr_init (&Bigfloat)

pub fn mpfr_init (mut a Bigfloat) {
	C.mpfr_init (&a)
}


pub fn new() Bigfloat {
	a := Bigfloat{ _mpfr_d: 0 }
	ctx := get_def_math_ctx()
	C.mpfr_init2 (&a, ctx.prec)
	return a
}

fn C.mpfr_clear (&Bigfloat)

pub fn clear (mut a Bigfloat) {
	C.mpfr_clear (&a)
}



//   C.mpfr_inits2 (Mpfr_prec, &Bigfloat, ...) __MPFR_SENTINEL_ATTR

//   C.mpfr_inits (&Bigfloat, ...) __MPFR_SENTINEL_ATTR

//   C.mpfr_clears (&Bigfloat, ...) __MPFR_SENTINEL_ATTR

fn C.mpfr_prec_round (&Bigfloat, Mpfr_prec, Round) int

pub fn prec_round (p Mpfr_prec) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_prec_round (&a, p, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn prec_round_ctx (p Mpfr_prec, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_prec_round (&a, p, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_can_round (&Bigfloat, i64, Round, Round, Mpfr_prec) int

pub fn can_round (a Bigfloat, err i64, r1 Round, r2 Round, p Mpfr_prec) int {
	return C.mpfr_can_round (&a, err, r1, r2, p)
}

fn C.mpfr_min_prec (&Bigfloat) Mpfr_prec

pub fn min_prec (a Bigfloat) Mpfr_prec {
	return C.mpfr_min_prec (&a)
}


fn C.mpfr_get_exp (&Bigfloat) Mpfr_exp

pub fn get_exp (a Bigfloat) Mpfr_exp {
	return C.mpfr_get_exp (&a)
}

fn C.mpfr_set_exp (&Bigfloat, i64) int

pub fn set_exp (mut a Bigfloat, e i64) int {
	return C.mpfr_set_exp (&a, e)
}

fn C.mpfr_get_prec (&Bigfloat) i64

pub fn get_prec (a Bigfloat) i64 {
	return C.mpfr_get_prec (&a)
}

fn C.mpfr_set_prec (&Bigfloat, Mpfr_prec)

pub fn set_prec (mut a Bigfloat, p Mpfr_prec) {
	C.mpfr_set_prec (&a, p)
}

fn C.mpfr_set_prec_raw (&Bigfloat, Mpfr_prec)

pub fn set_prec_raw (mut a Bigfloat, p Mpfr_prec) {
	C.mpfr_set_prec_raw (&a, p)
}

fn C.mpfr_set_default_prec (Mpfr_prec)

pub fn set_default_prec (p Mpfr_prec) {
	C.mpfr_set_default_prec (p)
}

fn C.mpfr_get_default_prec () i64

pub fn get_default_prec () i64 {
	return C.mpfr_get_default_prec ()
}


fn C.mpfr_set_d (&Bigfloat, f64, Round) int

pub fn from_f64 (d f64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_d (&a, d, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn from_f64_ctx (d f64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_d (&a, d, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set_flt (&Bigfloat, f32, Round) int

pub fn from_f32 (f f32) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_flt (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn from_f32_ctx (f f32, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_flt (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

// #ifdef MPFR_WANT_DECIMAL_FLOATS
// // /* _Decimal64 is not defined in C++,
// //    cf https://gcc.gnu.org/bugzilla/show_bug.cgi?id=51364 */
// fn C.mpfr_set_decimal64 (&Bigfloat, _Decimal64, Round) int

// pub fn set_decimal64 (&Bigfloat, _Decimal64, Round) int {
// 	return C.mpfr_set_decimal64 (&Bigfloat, _Decimal64, Round)
// }

// fn C.mpfr_set_decimal128 (&Bigfloat, _Decimal128, Round) int

// pub fn set_decimal128 (&Bigfloat, _Decimal128, Round) int {
// 	return C.mpfr_set_decimal128 (&Bigfloat, _Decimal128, Round)
// }

// #endif
// fn C.mpfr_set_ld (&Bigfloat, f80, Round) int

// pub fn set_ld (mut a Bigfloat, f80, Round) int {
// 	return C.mpfr_set_ld (&Bigfloat, f80, Round)
// }

// #ifdef MPFR_WANT_FLOAT128
// fn C.mpfr_set_float128 (&Bigfloat, f128, Round) int
// f128 C.mpfr_get_float128 (&Bigfloat, Round)
// #endif
fn C.mpfr_set_z (&Bigfloat, &gmp.Bigint, Round) int

pub fn set_z (b gmp.Bigint) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_z (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_z_ctx (b gmp.Bigint, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_z (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set_z_2exp (&Bigfloat, &gmp.Bigint, i64, Round) int

pub fn set_z_2exp (b gmp.Bigint, e i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_z_2exp (&a, &b, e, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_z_2exp_ctx (b gmp.Bigint, e i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_z_2exp (&a, &b, e, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set_nan (&Bigfloat)

pub fn set_nan (mut a Bigfloat) {
	C.mpfr_set_nan (&a)
}

fn C.mpfr_set_inf (&Bigfloat, int)

pub fn set_inf (mut a Bigfloat, neg bool) {
	C.mpfr_set_inf (&a, int(neg))
}

fn C.mpfr_set_zero (&Bigfloat, int)

pub fn set_zero (mut a &Bigfloat, neg bool) {
	C.mpfr_set_zero (&a, int(neg))
}


// #ifndef MPFR_USE_MINI_GMP
  /* mini-gmp does not provide mpf_t, we disable the following functions */
fn C.mpfr_set_f (&Bigfloat, &gmp.Bigfloat, Round) int

pub fn set_f (b gmp.Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_f (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_f_ctx (b gmp.Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_f (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_cmp_f (&Bigfloat, &gmp.Bigfloat) int

pub fn cmp_f (a Bigfloat, b gmp.Bigfloat) int {
	return C.mpfr_cmp_f (&a, &b)
}

fn C.mpfr_get_f (&gmp.Bigfloat, &Bigfloat, Round) int

pub fn get_f (mut a gmp.Bigfloat, b Bigfloat, r Round) int {
	return C.mpfr_get_f (&a, &b, r)
}

pub fn get_f_ctx (mut a gmp.Bigfloat, b Bigfloat, r Round, ctx MathContext) int {
	return C.mpfr_get_f (&a, &b, r)
}

// #endif
fn C.mpfr_set_si (&Bigfloat, i64, Round) int

pub fn from_i64 (i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_si (&a, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn from_i64_ctx (i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_si (&a, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set_ui (&Bigfloat, u64, Round) int

pub fn from_u64 (u u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_ui (&a, u, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn from_u64_ctx (u u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_ui (&a, u, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set_si_2exp (&Bigfloat, i64, i64, Round) int

pub fn set_i64_2exp (i i64, e i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_si_2exp (&a, i, e, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_i64_2exp_ctx (i i64, e i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_si_2exp (&a, i, e, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set_ui_2exp (&Bigfloat, u64, i64, Round) int

pub fn set_u64_2exp (u u64, e i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_ui_2exp (&a, u, e, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_u64_2exp_ctx (u u64, e i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_ui_2exp (&a, u, e, ctx.rnd)
	set_retval(retval)
	return a
}

// #ifndef MPFR_USE_MINI_GMP
  /* mini-gmp does not provide mpq_t, we disable the following functions */
fn C.mpfr_set_q (&Bigfloat, &gmp.Bigrational, Round) int

pub fn set_q (b gmp.Bigrational) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_q (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_q_ctx (b gmp.Bigrational, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_q (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul_q (&Bigfloat, &Bigfloat, &gmp.Bigrational, Round) int

pub fn mul_q (b Bigfloat, c gmp.Bigrational) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_q_ctx (b Bigfloat, c gmp.Bigrational, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_q (&Bigfloat, &Bigfloat, &gmp.Bigrational, Round) int

pub fn div_q (b Bigfloat, c gmp.Bigrational) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_q_ctx (b Bigfloat, c gmp.Bigrational, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_add_q (&Bigfloat, &Bigfloat, &gmp.Bigrational, Round) int

pub fn add_q (b Bigfloat, c gmp.Bigrational) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_add_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn add_q_ctx (b Bigfloat, c gmp.Bigrational, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_add_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sub_q (&Bigfloat, &Bigfloat, &gmp.Bigrational, Round) int

pub fn sub_q (b Bigfloat, c gmp.Bigrational) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sub_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sub_q_ctx (b Bigfloat, c gmp.Bigrational, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sub_q (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_cmp_q (&Bigfloat, &gmp.Bigrational) int

pub fn cmp_q (a Bigfloat, b gmp.Bigrational) int {
	return C.mpfr_cmp_q (&a, &b)
}

fn C.mpfr_get_q (&gmp.Bigrational, &Bigfloat)

pub fn get_q (a gmp.Bigrational, b Bigfloat) {
	C.mpfr_get_q (&a, &b)
}

// #endif
fn C.mpfr_set_str (&Bigfloat, &char, int, Round) int

pub fn set_str (s &char, b int) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set_str (&a, s, b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_str_ctx (s &char, b int, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set_str (&a, s, b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_init_set_str (&Bigfloat, &char, int, Round) int

pub fn from_str (s string) ?Bigfloat {
	a := Bigfloat{ _mpfr_d: 0 }
	ctx := get_def_print_ctx()
	retval := C.mpfr_init_set_str (&a, s.str, ctx.base, ctx.rnd)
	set_retval(retval)
	if retval != 0 {
		return error('Invalid string')
	}
	return a
}

fn C.mpfr_set4 (&Bigfloat, &Bigfloat, Round, int) int

pub fn set4 (b Bigfloat, f int) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set4 (&a, &b, ctx.rnd, f)
	set_retval(retval)
	return a
}

pub fn set4_ctx (b Bigfloat, f int, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set4 (&a, &b, ctx.rnd, f)
	set_retval(retval)
	return a
}

fn C.mpfr_abs (&Bigfloat, &Bigfloat, Round) int

pub fn abs (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_abs (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn abs_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_abs (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_set (&Bigfloat, &Bigfloat, Round) int

pub fn set (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_set (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn set_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_set (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_neg (&Bigfloat, &Bigfloat, Round) int

pub fn neg (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_neg (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn neg_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_neg (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_signbit (&Bigfloat) int

pub fn signbit (a Bigfloat) int {
	return C.mpfr_signbit (&a)
}

fn C.mpfr_setsign (&Bigfloat, &Bigfloat, int, Round) int

pub fn setsign (b Bigfloat, i int) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_setsign (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn setsign_ctx (b Bigfloat, i int, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_setsign (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_copysign (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn copysign (mut a Bigfloat, b Bigfloat, c Bigfloat, r Round) int {
	return C.mpfr_copysign (&a, &b, &c, r)
}

fn C.mpfr_get_z_2exp (&gmp.Bigint, &Bigfloat) i64

pub fn get_z_2exp (a gmp.Bigint, s Bigfloat) i64 {
	return C.mpfr_get_z_2exp (&a, &s)
}

fn C.mpfr_get_flt (&Bigfloat, Round) f32

pub fn (a Bigfloat) f32 () f32 {
	ctx := get_def_math_ctx()
	return C.mpfr_get_flt (&a, ctx.rnd)
}

pub fn (a Bigfloat) f32_ctx (ctx MathContext) f32 {
	return C.mpfr_get_flt (&a, ctx.rnd)
}

fn C.mpfr_get_d (&Bigfloat, Round) f64

pub fn (a Bigfloat) f64 () f64 {
	ctx := get_def_math_ctx()
	return C.mpfr_get_d (&a, ctx.rnd)
}

pub fn (a Bigfloat) f64_ctx (ctx MathContext) f64 {
	return C.mpfr_get_d (&a, ctx.rnd)
}

// #ifdef MPFR_WANT_DECIMAL_FLOATS
// _Decimal64 C.mpfr_get_decimal64 (&Bigfloat, Round)
// _Decimal128 C.mpfr_get_decimal128 (&Bigfloat, Round)
// #endif
// fn C.mpfr_get_ld (&Bigfloat, Round) f80

// pub fn get_ld (a Bigfloat, r Round) f80 {
// 	return C.mpfr_get_ld (&a, r)
// }

fn C.mpfr_get_d1 (&Bigfloat) f64

pub fn get_d1 (a Bigfloat) f64 {
	return C.mpfr_get_d1 (&a)
}

pub fn get_d1_ctx (a Bigfloat, ctx MathContext) f64 {
	return C.mpfr_get_d1 (&a)
}

fn C.mpfr_get_d_2exp (&i64, &Bigfloat, Round) f64

pub fn get_f64_2exp (e &i64, s Bigfloat, r Round) f64 {
	return C.mpfr_get_d_2exp (e, &s, r)
}

pub fn get_f64_2exp_ctx (e &i64, s Bigfloat, r Round, ctx MathContext) f64 {
	return C.mpfr_get_d_2exp (e, &s, r)
}

// fn C.mpfr_get_ld_2exp (&i64, &Bigfloat, Round) f80

// pub fn get_ld_2exp (e &i64, s Bigfloat, r Round) f80 {
// 	return C.mpfr_get_ld_2exp (e, &s, r)
// }

fn C.mpfr_frexp (&i64, &Bigfloat, &Bigfloat, Round) int

pub fn frexp (e &i64, g Bigfloat, s Bigfloat, r Round) int {
	return C.mpfr_frexp (e, &g, &s, r)
}

pub fn frexp_ctx (e &i64, g Bigfloat, s Bigfloat, r Round, ctx MathContext) int {
	return C.mpfr_frexp (e, &g, &s, r)
}

fn C.mpfr_get_si (&Bigfloat, Round) i64

pub fn (a Bigfloat) i64 () i64 {
	ctx := get_def_math_ctx()
	return C.mpfr_get_si (&a, ctx.rnd)
}

pub fn (a Bigfloat) i64_ctx (ctx MathContext) i64 {
	return C.mpfr_get_si (&a, ctx.rnd)
}

fn C.mpfr_get_ui (&Bigfloat, Round) u64

pub fn (a Bigfloat) u64 () u64 {
	ctx := get_def_math_ctx()
	return C.mpfr_get_ui (&a, ctx.rnd)
}

pub fn (a Bigfloat) u64_ctx (ctx MathContext) u64 {
	return C.mpfr_get_ui (&a, ctx.rnd)
}

fn C.mpfr_get_str_ndigits (int, Mpfr_prec) u64

pub fn get_str_ndigits (n int, p Mpfr_prec) u64 {
	return C.mpfr_get_str_ndigits (n, p)
}

pub struct PrintContext {
pub mut:
	base int
	ndigits u64
	rnd Round
}

pub fn get_def_print_ctx () PrintContext {
	base := 10 // used twice below
	return PrintContext {
		base: base
		ndigits: mathutil.min(u64(17), 
			get_str_ndigits(base, get_default_prec()) - 1) // last digit is often unreliable
		rnd: .rndn
	}
}

fn C.mpfr_get_str (&char, &i64, int, u64, &Bigfloat, Round) &char

pub fn (s Bigfloat) str_ctx (ctx PrintContext) string {
	exp := i64(0)
	mut t_str := ''
	c_str := C.mpfr_get_str (0, &exp, ctx.base, ctx.ndigits, &s, ctx.rnd)
	unsafe {
		t_str = c_str.vstring()
		t_str = tos_clone(c_str)
	}
	n_digits := int(ctx.ndigits)
	iexp := int(exp)
	n_zero := nb_trailing_zeros(t_str)
	mut e_sign := '@'
	if ctx.base == 10 {
		e_sign = 'e'
	} else if ctx.base == 2 {
		e_sign = 'p'
	}
	mut t_sign := ''
	if t_str.len == 0 {
		return '0'
	} 
	if nan_p(s) || inf_p(s) {
		unsafe { t_str = c_str.vstring() }
		return t_str
	}
	if t_str.len > 0 && t_str[0] == `-`{
		t_sign = '-'
		t_str = t_str[1..]
	}
	mut add_exp := false
	if iexp > n_digits {
		t_str = t_str[0..1] + '.' + t_str[1..]
		add_exp = true
	} else if iexp > 0 {
		t_str = t_str[0..iexp] + '.' + t_str[iexp..]
	} else if iexp > - n_zero {
		t_str = '0.' + '0'.repeat(-iexp) + t_str
	} else /* iexp <= - n_zero */ {
		t_str = t_str[0..1] + '.' + t_str[1..]
		add_exp = true
	}
	t_str = t_str.trim_right("0")
	t_str = t_str.trim_suffix('.')
	if add_exp {
		t_str += '${e_sign}${iexp - 1}'
	}
	return t_sign + t_str
}

fn nb_trailing_zeros(s string) int {
	mut r := s.len
	mut n := 0
	for r > 0 {
		r--
		if s[r] != `0` {
			return n
		}
		n++
	}
	return n
}

pub fn (a Bigfloat) str () string {
	ctx := get_def_print_ctx()
	s := a.str_ctx(ctx)
	return s
}

fn C.mpfr_get_z (&gmp.Bigint, &Bigfloat, Round) int

pub fn get_z (a gmp.Bigint, b Bigfloat, r Round) int {
	return C.mpfr_get_z (&a, &b, r)
}

pub fn get_z_ctx (a gmp.Bigint, b Bigfloat, r Round, ctx MathContext) int {
	return C.mpfr_get_z (&a, &b, r)
}


fn C.mpfr_free_str (&char)

pub fn free_str (s &char) {
	C.mpfr_free_str (s)
}


fn C.mpfr_urandom (&Bigfloat, &gmp.Randstate, Round) int

pub fn urandom (mut st gmp.Randstate) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_urandom (&a, &st, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn urandom_ctx (mut st gmp.Randstate, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_urandom (&a, &st, ctx.rnd)
	set_retval(retval)
	return a
}

// #ifndef _MPFR_NO_DEPRECATED_GRANDOM /* for the test of this function */
// MPFR_DEPRECATED
// #endif
fn C.mpfr_grandom (&Bigfloat, &Bigfloat, &gmp.Randstate, Round)

pub fn grandom (mut a Bigfloat, b Bigfloat, st gmp.Randstate, r Round) {
	C.mpfr_grandom (&a, &b, &st, r)
}

pub fn grandom_ctx (mut a Bigfloat, b Bigfloat, st gmp.Randstate, r Round, ctx MathContext) {
	C.mpfr_grandom (&a, &b, &st, r)
}

fn C.mpfr_nrandom (&Bigfloat, &gmp.Randstate, Round) int

pub fn nrandom (st gmp.Randstate) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_nrandom (&a, &st, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn nrandom_ctx (st gmp.Randstate, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_nrandom (&a, &st, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_erandom (&Bigfloat, &gmp.Randstate, Round) int

pub fn erandom (st gmp.Randstate) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_erandom (&a, &st, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn erandom_ctx (st gmp.Randstate, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_erandom (&a, &st, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_urandomb (&Bigfloat, &gmp.Randstate) int

pub fn urandomb (st gmp.Randstate) Bigfloat {
	a := new()
	retval := C.mpfr_urandomb (&a, &st)
	set_retval(retval)
	return a
}


fn C.mpfr_nextabove (&Bigfloat)

pub fn nextabove (mut a Bigfloat) {
	C.mpfr_nextabove (&a)
}

fn C.mpfr_nextbelow (&Bigfloat)

pub fn nextbelow (mut a Bigfloat) {
	C.mpfr_nextbelow (&a)
}

fn C.mpfr_nexttoward (&Bigfloat, &Bigfloat)

pub fn nexttoward (mut a Bigfloat, b Bigfloat) {
	C.mpfr_nexttoward (&a, &b)
}


// #ifndef MPFR_USE_MINI_GMP
// fn C.mpfr_printf (&char, ...) int

// pub fn printf (&char, ...) int {
// 	return C.mpfr_printf (&char, ...)
// }

// fn C.mpfr_asprintf (&&char, &char, ...) int

// pub fn asprintf (&&char, &char, ...) int {
// 	return C.mpfr_asprintf (&&char, &char, ...)
// }

// fn C.mpfr_sprintf (&char, &char, ...) int

// pub fn sprintf (&char, &char, ...) int {
// 	return C.mpfr_sprintf (&char, &char, ...)
// }

// fn C.mpfr_snprintf (&char, size_t, &char, ...) int

// pub fn snprintf (&char, size_t, &char, ...) int {
// 	return C.mpfr_snprintf (&char, size_t, &char, ...)
// }

// #endif

fn C.mpfr_pow (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn pow (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_pow (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn pow_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_pow (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_pow_si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn pow_i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_pow_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn pow_i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_pow_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_pow_ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn pow_u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_pow_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn pow_u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_pow_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_ui_pow_ui (&Bigfloat, u64, u64, Round) int

pub fn u64_pow_u64 (u u64, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_ui_pow_ui (&a, u, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn u64_pow_u64_ctx (u u64, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_ui_pow_ui (&a, u, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_ui_pow (&Bigfloat, u64, &Bigfloat, Round) int

pub fn u64_pow (u u64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_ui_pow (&a, u, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn u64_pow_ctx (u u64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_ui_pow (&a, u, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_pow_z (&Bigfloat, &Bigfloat, &gmp.Bigint, Round) int

pub fn pow_z (b Bigfloat, c gmp.Bigint) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_pow_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn pow_z_ctx (b Bigfloat, c gmp.Bigint, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_pow_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_sqrt (&Bigfloat, &Bigfloat, Round) int

pub fn sqrt (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sqrt (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sqrt_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sqrt (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sqrt_ui (&Bigfloat, u64, Round) int

pub fn sqrt_u64 (f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sqrt_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sqrt_u64_ctx (f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sqrt_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_rec_sqrt (&Bigfloat, &Bigfloat, Round) int

pub fn rec_sqrt (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_rec_sqrt (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn rec_sqrt_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rec_sqrt (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_add (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn (b Bigfloat) + (c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_add (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn add_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_add (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sub (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn (b Bigfloat) - (c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sub (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sub_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sub (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn (b Bigfloat) * (c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn (b Bigfloat) / (c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_add_ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn add_u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_add_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn add_u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_add_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sub_ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn sub_u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sub_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sub_u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sub_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_ui_sub (&Bigfloat, u64, &Bigfloat, Round) int

pub fn u64_sub (u u64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_ui_sub (&a, u, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn u64_sub_ctx (u u64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_ui_sub (&a, u, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul_ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn mul_u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn div_u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_ui_div (&Bigfloat, u64, &Bigfloat, Round) int

pub fn u64_div (u u64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_ui_div (&a, u, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn u64_div_ctx (u u64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_ui_div (&a, u, &s, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_add_si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn add_i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_add_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn add_i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_add_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sub_si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn sub_i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sub_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sub_i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sub_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_si_sub (&Bigfloat, i64, &Bigfloat, Round) int

pub fn i64_sub (i i64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_si_sub (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn i64_sub_ctx (i i64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_si_sub (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul_si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn mul_i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn div_i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_si_div (&Bigfloat, i64, &Bigfloat, Round) int

pub fn i64_div (i i64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_si_div (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn i64_div_ctx (i i64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_si_div (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_add_d (&Bigfloat, &Bigfloat, f64, Round) int

pub fn add_f64 (b Bigfloat, f f64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_add_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn add_f64_ctx (b Bigfloat, f f64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_add_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sub_d (&Bigfloat, &Bigfloat, f64, Round) int

pub fn sub_f64 (b Bigfloat, f f64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sub_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sub_f64_ctx (b Bigfloat, f f64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sub_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_d_sub (&Bigfloat, f64, &Bigfloat, Round) int

pub fn f64_sub (f f64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_d_sub (&a, f, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn f64_sub_ctx (f f64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_d_sub (&a, f, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul_d (&Bigfloat, &Bigfloat, f64, Round) int

pub fn mul_f64 (b Bigfloat, f f64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_f64_ctx (b Bigfloat, f f64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_d (&Bigfloat, &Bigfloat, f64, Round) int

pub fn div_f64 (b Bigfloat, f f64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_f64_ctx (b Bigfloat, f f64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_d (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_d_div (&Bigfloat, f64, &Bigfloat, Round) int

pub fn f64_div (f f64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_d_div (&a, f, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn f64_div_ctx (f f64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_d_div (&a, f, &s, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_sqr (&Bigfloat, &Bigfloat, Round) int

pub fn sqr (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sqr (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sqr_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sqr (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_const_pi (&Bigfloat, Round) int

pub fn pi () Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_const_pi (&a, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn pi_ctx (ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_const_pi (&a, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_const_log2 (&Bigfloat, Round) int

pub fn const_log2 () Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_const_log2 (&a, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn const_log2_ctx (ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_const_log2 (&a, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_const_euler (&Bigfloat, Round) int

pub fn const_euler () Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_const_euler (&a, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn const_euler_ctx (ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_const_euler (&a, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_const_catalan (&Bigfloat, Round) int

pub fn const_catalan () Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_const_catalan (&a, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn const_catalan_ctx (ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_const_catalan (&a, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_agm (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn agm (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_agm (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn agm_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_agm (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_log (&Bigfloat, &Bigfloat, Round) int

pub fn log (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_log (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn log_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_log (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_log2 (&Bigfloat, &Bigfloat, Round) int

pub fn log2 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_log2 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn log2_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_log2 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_log10 (&Bigfloat, &Bigfloat, Round) int

pub fn log10 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_log10 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn log10_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_log10 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_log1p (&Bigfloat, &Bigfloat, Round) int

pub fn log1p (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_log1p (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn log1p_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_log1p (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_log_ui (&Bigfloat, u64, Round) int

pub fn log_u64 (f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_log_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn log_u64_ctx (f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_log_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_exp (&Bigfloat, &Bigfloat, Round) int

pub fn exp (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_exp (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn exp_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_exp (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_exp2 (&Bigfloat, &Bigfloat, Round) int

pub fn exp2 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_exp2 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn exp2_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_exp2 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_exp10 (&Bigfloat, &Bigfloat, Round) int

pub fn exp10 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_exp10 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn exp10_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_exp10 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_expm1 (&Bigfloat, &Bigfloat, Round) int

pub fn expm1 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_expm1 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn expm1_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_expm1 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_eint (&Bigfloat, &Bigfloat, Round) int

pub fn eint (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_eint (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn eint_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_eint (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_li2 (&Bigfloat, &Bigfloat, Round) int

pub fn li2 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_li2 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn li2_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_li2 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_cmp  (&Bigfloat, &Bigfloat) int

pub fn cmp  (a Bigfloat, b Bigfloat) int {
	return C.mpfr_cmp  (&a, &b)
}

pub fn (a Bigfloat) == (b Bigfloat) bool {
	return C.mpfr_cmp  (&a, &b) == 0
}

fn C.mpfr_cmp3 (&Bigfloat, &Bigfloat, int) int

pub fn cmp3 (a Bigfloat, b Bigfloat, i int) int {
	return C.mpfr_cmp3 (&a, &b, i)
}

fn C.mpfr_cmp_d (&Bigfloat, f64) int

pub fn cmp_f64 (a Bigfloat, f f64) int {
	return C.mpfr_cmp_d (&a, f)
}

// fn C.mpfr_cmp_ld (&Bigfloat, f80) int

// pub fn cmp_ld (a Bigfloat, i f80) int {
// 	return C.mpfr_cmp_ld (&a, i)
// }

fn C.mpfr_cmp_ui (&Bigfloat, u64) int

pub fn cmp_u64 (a Bigfloat, u u64) int {
	return C.mpfr_cmp_ui (&a, u)
}

fn C.mpfr_cmp_si (&Bigfloat, i64) int

pub fn cmp_i64 (a Bigfloat, i i64) int {
	return C.mpfr_cmp_si (&a, i)
}

fn C.mpfr_cmp_ui_2exp (&Bigfloat, u64, i64) int

pub fn cmp_u64_2exp (a Bigfloat, u u64, e i64) int {
	return C.mpfr_cmp_ui_2exp (&a, u, e)
}

fn C.mpfr_cmp_si_2exp (&Bigfloat, i64, i64) int

pub fn cmp_i64_2exp (a Bigfloat, i i64, j i64) int {
	return C.mpfr_cmp_si_2exp (&a, i, j)
}

fn C.mpfr_cmpabs (&Bigfloat, &Bigfloat) int

pub fn cmpabs (a Bigfloat, b Bigfloat) int {
	return C.mpfr_cmpabs (&a, &b)
}

fn C.mpfr_cmpabs_ui (&Bigfloat, u64) int

pub fn cmpabs_u64 (a Bigfloat, u u64) int {
	return C.mpfr_cmpabs_ui (&a, u)
}

fn C.mpfr_reldiff (&Bigfloat, &Bigfloat, &Bigfloat, Round)

pub fn reldiff (mut a Bigfloat, b Bigfloat, c Bigfloat, r Round) {
	C.mpfr_reldiff (&a, &b, &c, r)
}

pub fn reldiff_ctx (mut a Bigfloat, b Bigfloat, c Bigfloat, r Round, ctx MathContext) {
	C.mpfr_reldiff (&a, &b, &c, r)
}

fn C.mpfr_eq (&Bigfloat, &Bigfloat, u64) int

pub fn eq (a Bigfloat, b Bigfloat, f u64) int {
	return C.mpfr_eq (&a, &b, f)
}

fn C.mpfr_sgn (&Bigfloat) int

pub fn sgn (a Bigfloat) int {
	return C.mpfr_sgn (&a)
}


fn C.mpfr_mul_2exp (&Bigfloat, &Bigfloat, u64, Round) int

pub fn mul_2exp (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_2exp (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_2exp_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_2exp (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_2exp (&Bigfloat, &Bigfloat, u64, Round) int

pub fn div_2exp (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_2exp (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_2exp_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_2exp (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul_2ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn mul_2u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_2ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_2u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_2ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_2ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn div_2u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_2ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_2u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_2ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_mul_2si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn mul_2i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_2si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_2i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_2si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_2si (&Bigfloat, &Bigfloat, i64, Round) int

pub fn div_2i64 (b Bigfloat, i i64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_2si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}


pub fn div_2i64_ctx (b Bigfloat, i i64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_2si (&a, &b, i, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_rint (&Bigfloat, &Bigfloat, Round) int

pub fn rint (b Bigfloat, r Round) Bigfloat {
	a := new()
	retval := C.mpfr_rint (&a, &b, r)
	set_retval(retval)
	return a
}

fn C.mpfr_roundeven (&Bigfloat, &Bigfloat) int

pub fn roundeven (b Bigfloat) Bigfloat {
	a := new()
	retval := C.mpfr_roundeven (&a, &b)
	set_retval(retval)
	return a
}

fn C.mpfr_round (&Bigfloat, &Bigfloat) int

pub fn round (b Bigfloat) Bigfloat {
	a := new()
	retval := C.mpfr_round (&a, &b)
	set_retval(retval)
	return a
}

fn C.mpfr_trunc (&Bigfloat, &Bigfloat) int

pub fn trunc (b Bigfloat) Bigfloat {
	a := new()
	retval := C.mpfr_trunc (&a, &b)
	set_retval(retval)
	return a
}

fn C.mpfr_ceil (&Bigfloat, &Bigfloat) int

pub fn ceil (b Bigfloat) Bigfloat {
	a := new()
	retval := C.mpfr_ceil (&a, &b)
	set_retval(retval)
	return a
}

fn C.mpfr_floor (&Bigfloat, &Bigfloat) int

pub fn floor (b Bigfloat) Bigfloat {
	a := new()
	retval := C.mpfr_floor (&a, &b)
	set_retval(retval)
	return a
}

fn C.mpfr_rint_roundeven (&Bigfloat, &Bigfloat, Round) int

pub fn rint_roundeven (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_rint_roundeven (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn rint_roundeven_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rint_roundeven (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_rint_round (&Bigfloat, &Bigfloat, Round) int

pub fn rint_round (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_rint_round (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn rint_round_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rint_round (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_rint_trunc (&Bigfloat, &Bigfloat, Round) int

pub fn rint_trunc (b Bigfloat, r Round) Bigfloat {
	a := new()
	retval := C.mpfr_rint_trunc (&a, &b, r)
	set_retval(retval)
	return a
}

pub fn rint_trunc_ctx (b Bigfloat, r Round, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rint_trunc (&a, &b, r)
	set_retval(retval)
	return a
}

fn C.mpfr_rint_ceil (&Bigfloat, &Bigfloat, Round) int

pub fn rint_ceil (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_rint_ceil (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn rint_ceil_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rint_ceil (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_rint_floor (&Bigfloat, &Bigfloat, Round) int

pub fn rint_floor (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_rint_floor (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn rint_floor_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rint_floor (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_frac (&Bigfloat, &Bigfloat, Round) int

pub fn frac (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_frac (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn frac_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_frac (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_modf (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn modf (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_modf (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn modf_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_modf (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_remquo (&Bigfloat, &i64, &Bigfloat, &Bigfloat, Round) int

pub fn remquo (i &i64, g Bigfloat, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_remquo (&a, i, &g, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn remquo_ctx (i &i64, g Bigfloat, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_remquo (&a, i, &g, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_remainder (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn remainder (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_print_ctx()
	retval := C.mpfr_remainder (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn remainder_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_remainder (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_fmod (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

// % : the quotient and the difference are both rounded toward zero
pub fn (b Bigfloat) % (c Bigfloat) Bigfloat {
	a := new()
	retval := C.mpfr_fmod (&a, &b, &c, .rndz)
	set_retval(retval)
	return a
}

pub fn fmod (b Bigfloat, c Bigfloat, r Round) Bigfloat {
	a := new()
	retval := C.mpfr_fmod (&a, &b, &c, r)
	set_retval(retval)
	return a
}

pub fn fmod_ctx (b Bigfloat, c Bigfloat, r Round, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fmod (&a, &b, &c, r)
	set_retval(retval)
	return a
}

fn C.mpfr_fmodquo (&Bigfloat, &i64, &Bigfloat, &Bigfloat, Round) int

pub fn fmodquo (i &i64, g Bigfloat, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_fmodquo (&a, i, &g, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn fmodquo_ctx (i &i64, g Bigfloat, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fmodquo (&a, i, &g, &s, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_fits_ulong_p (&Bigfloat, Round) int

pub fn fits_ulong_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_ulong_p (&a, r)
}

fn C.mpfr_fits_slong_p (&Bigfloat, Round) int

pub fn fits_slong_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_slong_p (&a, r)
}

fn C.mpfr_fits_uint_p (&Bigfloat, Round) int

pub fn fits_uint_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_uint_p (&a, r)
}

fn C.mpfr_fits_sint_p (&Bigfloat, Round) int

pub fn fits_sint_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_sint_p (&a, r)
}

fn C.mpfr_fits_ushort_p (&Bigfloat, Round) int

pub fn fits_ushort_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_ushort_p (&a, r)
}

fn C.mpfr_fits_sshort_p (&Bigfloat, Round) int

pub fn fits_sshort_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_sshort_p (&a, r)
}

fn C.mpfr_fits_uintmax_p (&Bigfloat, Round) int

pub fn fits_uintmax_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_uintmax_p (&a, r)
}

fn C.mpfr_fits_intmax_p (&Bigfloat, Round) int

pub fn fits_intmax_p (a Bigfloat, r Round) int {
	return C.mpfr_fits_intmax_p (&a, r)
}


pub fn fits_intmax_p_ctx (a Bigfloat, r Round, ctx MathContext) int {
	return C.mpfr_fits_intmax_p (&a, r)
}


fn C.mpfr_extract (&gmp.Bigint, &Bigfloat, u32)

pub fn extract (a gmp.Bigint, s Bigfloat, u u32) {
	C.mpfr_extract (&a, &s, u)
}

fn C.mpfr_swap (&Bigfloat, &Bigfloat)

pub fn swap (mut a Bigfloat, mut b Bigfloat) {
	C.mpfr_swap (&a, &b)
}

fn C.mpfr_dump (&Bigfloat)

pub fn mpfr_dump (a Bigfloat) {
	C.mpfr_dump (&a)
}


pub fn mpfr_dump_ctx (a Bigfloat, ctx MathContext) {
	C.mpfr_dump (&a)
}


fn C.mpfr_nan_p (&Bigfloat) int

pub fn nan_p(a Bigfloat) bool {
	return C.mpfr_nan_p (&a) != 0
}

fn C.mpfr_inf_p (&Bigfloat) int

pub fn inf_p (a Bigfloat) bool {
	return C.mpfr_inf_p (&a) != 0
}

fn C.mpfr_number_p (&Bigfloat) int

pub fn number_p (a Bigfloat) int {
	return C.mpfr_number_p (&a)
}

fn C.mpfr_integer_p (&Bigfloat) int

pub fn integer_p (a Bigfloat) int {
	return C.mpfr_integer_p (&a)
}

fn C.mpfr_zero_p (&Bigfloat) int

pub fn zero_p (a Bigfloat) bool {
	return C.mpfr_zero_p (&a) != 0
}

fn C.mpfr_regular_p (&Bigfloat) int

pub fn regular_p (a Bigfloat) int {
	return C.mpfr_regular_p (&a)
}


pub fn regular_p_ctx (a Bigfloat, ctx MathContext) int {
	return C.mpfr_regular_p (&a)
}


fn C.mpfr_greater_p (&Bigfloat, &Bigfloat) int

pub fn greater_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_greater_p (&a, &b)
}

fn C.mpfr_greaterequal_p (&Bigfloat, &Bigfloat) int

pub fn greaterequal_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_greaterequal_p (&a, &b)
}

fn C.mpfr_less_p (&Bigfloat, &Bigfloat) int

pub fn less_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_less_p (&a, &b)
}

pub fn (a Bigfloat) < (b Bigfloat) bool {
	return C.mpfr_less_p (&a, &b) == 1
}

fn C.mpfr_lessequal_p (&Bigfloat, &Bigfloat) int

pub fn lessequal_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_lessequal_p (&a, &b)
}

fn C.mpfr_lessgreater_p (&Bigfloat, &Bigfloat) int

pub fn lessgreater_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_lessgreater_p (&a, &b)
}

fn C.mpfr_equal_p (&Bigfloat, &Bigfloat) int

pub fn equal_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_equal_p (&a, &b)
}

fn C.mpfr_unordered_p (&Bigfloat, &Bigfloat) int

pub fn unordered_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_unordered_p (&a, &b)
}


fn C.mpfr_atanh (&Bigfloat, &Bigfloat, Round) int

pub fn atanh (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_atanh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn atanh_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_atanh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_acosh (&Bigfloat, &Bigfloat, Round) int

pub fn acosh (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_acosh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn acosh_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_acosh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_asinh (&Bigfloat, &Bigfloat, Round) int

pub fn asinh (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_asinh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn asinh_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_asinh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_cosh (&Bigfloat, &Bigfloat, Round) int

pub fn cosh (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_cosh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn cosh_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_cosh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sinh (&Bigfloat, &Bigfloat, Round) int

pub fn sinh (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sinh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sinh_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sinh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_tanh (&Bigfloat, &Bigfloat, Round) int

pub fn tanh (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_tanh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn tanh_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_tanh (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sinh_cosh (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn sinh_cosh (c Bigfloat) (Bigfloat, Bigfloat) {
	a := new()
	b := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sinh_cosh (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a, b
}


pub fn sinh_cosh_ctx (c Bigfloat, ctx MathContext) (Bigfloat, Bigfloat) {
	a := new()
	b := new()
	retval := C.mpfr_sinh_cosh (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a, b
}


fn C.mpfr_sech (&Bigfloat, &Bigfloat, Round) int

pub fn sech (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sech (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sech_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sech (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_csch (&Bigfloat, &Bigfloat, Round) int

pub fn csch (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_csch (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn csch_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_csch (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_coth (&Bigfloat, &Bigfloat, Round) int

pub fn coth (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_coth (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn coth_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_coth (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_acos (&Bigfloat, &Bigfloat, Round) int

pub fn acos (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_acos (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn acos_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_acos (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_asin (&Bigfloat, &Bigfloat, Round) int

pub fn asin (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_asin (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn asin_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_asin (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_atan (&Bigfloat, &Bigfloat, Round) int

pub fn atan (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_atan (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn atan_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_atan (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sin (&Bigfloat, &Bigfloat, Round) int

pub fn sin (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sin (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sin_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sin (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sin_cos (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn sin_cos (c Bigfloat) (Bigfloat, Bigfloat) {
	a := new()
	b := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sin_cos (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a, b
}

pub fn sin_cos_ctx (c Bigfloat, ctx MathContext) (Bigfloat, Bigfloat) {
	a := new()
	b := new()
	retval := C.mpfr_sin_cos (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a, b
}

fn C.mpfr_cos (&Bigfloat, &Bigfloat, Round) int

pub fn cos (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_cos (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn cos_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_cos (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_tan (&Bigfloat, &Bigfloat, Round) int

pub fn tan (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_tan (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn tan_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_tan (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_atan2 (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn atan2 (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_atan2 (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn atan2_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_atan2 (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sec (&Bigfloat, &Bigfloat, Round) int

pub fn sec (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sec (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sec_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sec (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_csc (&Bigfloat, &Bigfloat, Round) int

pub fn csc (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_csc (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn csc_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_csc (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_cot (&Bigfloat, &Bigfloat, Round) int

pub fn cot (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_cot (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn cot_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_cot (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_hypot (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn hypot (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_hypot (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn hypot_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_hypot (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_erf (&Bigfloat, &Bigfloat, Round) int

pub fn erf (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_erf (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn erf_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_erf (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_erfc (&Bigfloat, &Bigfloat, Round) int

pub fn erfc (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_erfc (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn erfc_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_erfc (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_cbrt (&Bigfloat, &Bigfloat, Round) int

pub fn cbrt (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_cbrt (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn cbrt_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_cbrt (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

// #ifndef _MPFR_NO_DEPRECATED_ROOT /* for the test of this function */
// MPFR_DEPRECATED
// #endif
fn C.mpfr_root (&Bigfloat, &Bigfloat, u64, Round) int

pub fn root (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_root (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn root_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_root (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_rootn_ui (&Bigfloat, &Bigfloat, u64, Round) int

pub fn rootn_u64 (b Bigfloat, f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_rootn_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn rootn_u64_ctx (b Bigfloat, f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_rootn_ui (&a, &b, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_gamma (&Bigfloat, &Bigfloat, Round) int

pub fn gamma (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_gamma (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn gamma_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_gamma (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_gamma_inc (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn gamma_inc (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_gamma_inc (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn gamma_inc_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_gamma_inc (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_beta (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn beta (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_beta (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn beta_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_beta (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_lngamma (&Bigfloat, &Bigfloat, Round) int

pub fn lngamma (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_lngamma (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn lngamma_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_lngamma (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_lgamma (&Bigfloat, &int, &Bigfloat, Round) int

pub fn lgamma (i &int, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_lgamma (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn lgamma_ctx (i &int, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_lgamma (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_digamma (&Bigfloat, &Bigfloat, Round) int

pub fn digamma (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_digamma (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn digamma_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_digamma (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_zeta (&Bigfloat, &Bigfloat, Round) int

pub fn zeta (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_zeta (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn zeta_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_zeta (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_zeta_ui (&Bigfloat, u64, Round) int

pub fn zeta_u64 (f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_zeta_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn zeta_u64_ctx (f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_zeta_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_fac_ui (&Bigfloat, u64, Round) int

pub fn fac_u64 (f u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_fac_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn fac_u64_ctx (f u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fac_ui (&a, f, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_j0 (&Bigfloat, &Bigfloat, Round) int

pub fn j0 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_j0 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn j0_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_j0 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_j1 (&Bigfloat, &Bigfloat, Round) int

pub fn j1 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_j1 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn j1_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_j1 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_jn (&Bigfloat, i64, &Bigfloat, Round) int

pub fn jn (i i64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_jn (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn jn_ctx (i i64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_jn (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_y0 (&Bigfloat, &Bigfloat, Round) int

pub fn y0 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_y0 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn y0_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_y0 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_y1 (&Bigfloat, &Bigfloat, Round) int

pub fn y1 (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_y1 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn y1_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_y1 (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_yn (&Bigfloat, i64, &Bigfloat, Round) int

pub fn yn (i i64, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_yn (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn yn_ctx (i i64, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_yn (&a, i, &s, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_ai (&Bigfloat, &Bigfloat, Round) int

pub fn ai (b Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_ai (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn ai_ctx (b Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_ai (&a, &b, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_min (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn min (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_min (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn min_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_min (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_max (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn max (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_max (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_dim (&Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn dim (b Bigfloat, c Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_dim (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn dim_ctx (b Bigfloat, c Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_dim (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_mul_z (&Bigfloat, &Bigfloat, &gmp.Bigint, Round) int

pub fn mul_z (b Bigfloat, c gmp.Bigint) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_mul_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn mul_z_ctx (b Bigfloat, c gmp.Bigint, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_mul_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_div_z (&Bigfloat, &Bigfloat, &gmp.Bigint, Round) int

pub fn div_z (b Bigfloat, c gmp.Bigint) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_div_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn div_z_ctx (b Bigfloat, c gmp.Bigint, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_div_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_add_z (&Bigfloat, &Bigfloat, &gmp.Bigint, Round) int

pub fn add_z (b Bigfloat, c gmp.Bigint) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_add_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn add_z_ctx (b Bigfloat, c gmp.Bigint, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_add_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sub_z (&Bigfloat, &Bigfloat, &gmp.Bigint, Round) int

pub fn sub_z (b Bigfloat, c gmp.Bigint) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sub_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sub_z_ctx (b Bigfloat, c gmp.Bigint, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sub_z (&a, &b, &c, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_z_sub (&Bigfloat, &gmp.Bigint, &Bigfloat, Round) int

pub fn z_sub (b gmp.Bigint, s Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_z_sub (&a, &b, &s, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn z_sub_ctx (b gmp.Bigint, s Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_z_sub (&a, &b, &s, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_cmp_z (&Bigfloat, &gmp.Bigint) int

pub fn cmp_z (a Bigfloat, b gmp.Bigint) int {
	return C.mpfr_cmp_z (&a, &b)
}


fn C.mpfr_fma (&Bigfloat, &Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn fma (b Bigfloat, c Bigfloat, d Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_fma (&a, &b, &c, &d, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn fma_ctx (b Bigfloat, c Bigfloat, d Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fma (&a, &b, &c, &d, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_fms (&Bigfloat, &Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn fms (b Bigfloat, c Bigfloat, d Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_fms (&a, &b, &c, &d, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn fms_ctx (b Bigfloat, c Bigfloat, d Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fms (&a, &b, &c, &d, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_fmma (&Bigfloat, &Bigfloat, &Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn fmma (b Bigfloat, c Bigfloat, d Bigfloat, e Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_fmma (&a, &b, &c, &d, &e, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn fmma_ctx (b Bigfloat, c Bigfloat, d Bigfloat, e Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fmma (&a, &b, &c, &d, &e, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_fmms (&Bigfloat, &Bigfloat, &Bigfloat, &Bigfloat, &Bigfloat, Round) int

pub fn fmms (b Bigfloat, c Bigfloat, d Bigfloat, e Bigfloat) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_fmms (&a, &b, &c, &d, &e, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn fmms_ctx (b Bigfloat, c Bigfloat, d Bigfloat, e Bigfloat, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_fmms (&a, &b, &c, &d, &e, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_sum (&Bigfloat, &Bigfloat, u64, Round) int

pub fn sum (b &Bigfloat, n u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_sum (&a, b, n, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn sum_ctx (b &Bigfloat, n u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_sum (&a, b, n, ctx.rnd)
	set_retval(retval)
	return a
}

fn C.mpfr_dot (&Bigfloat, &Bigfloat, &Bigfloat, u64, Round) int

pub fn dot (b &Bigfloat, c &Bigfloat, n u64) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_dot (&a, b, c, n, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn dot_ctx (b &Bigfloat, c &Bigfloat, n u64, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_dot (&a, b, c, n, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_free_cache ()

pub fn free_cache () {
	C.mpfr_free_cache ()
}

fn C.mpfr_free_cache2 (C.mpfr_free_cache_t)

pub fn free_cache2 (c C.mpfr_free_cache_t) {
	C.mpfr_free_cache2 (c)
}

fn C.mpfr_free_pool ()

pub fn free_pool () {
	C.mpfr_free_pool ()
}

fn C.mpfr_mp_memory_cleanup () int

pub fn mp_memory_cleanup () int {
	return C.mpfr_mp_memory_cleanup ()
}


fn C.mpfr_subnormalize (&Bigfloat, int, Round) int

pub fn subnormalize (i int) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_subnormalize (&a, i, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn subnormalize_ctx (i int, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_subnormalize (&a, i, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_strtofr (&Bigfloat, &char, &&char, int, Round) int

pub fn strtofr (s &char, d &&char, b int) Bigfloat {
	a := new()
	ctx := get_def_math_ctx()
	retval := C.mpfr_strtofr (&a, s, d, b, ctx.rnd)
	set_retval(retval)
	return a
}

pub fn strtofr_ctx (s &char, d &&char, b int, ctx MathContext) Bigfloat {
	a := new()
	retval := C.mpfr_strtofr (&a, s, d, b, ctx.rnd)
	set_retval(retval)
	return a
}


fn C.mpfr_round_nearest_away_begin (&Bigfloat)

pub fn round_nearest_away_begin (mut a Bigfloat) {
	C.mpfr_round_nearest_away_begin (&a)
}

fn C.mpfr_round_nearest_away_end (&Bigfloat, int) int

pub fn round_nearest_away_end (i int) Bigfloat {
	a := new()
	retval := C.mpfr_round_nearest_away_end (&a, i)
	set_retval(retval)
	return a
}


fn C.mpfr_custom_get_size (Mpfr_prec) u64

pub fn custom_get_size (p Mpfr_prec) u64 {
	return C.mpfr_custom_get_size (p)
}

fn C.mpfr_custom_init (voidptr, Mpfr_prec)

pub fn custom_init (ptr voidptr, p Mpfr_prec) {
	C.mpfr_custom_init (ptr, p)
}

 
fn C.mpfr_custom_get_significand (&Bigfloat) voidptr

pub fn custom_get_significand (a Bigfloat) voidptr {
	return C.mpfr_custom_get_significand (&a)
}

fn C.mpfr_custom_get_exp (&Bigfloat) i64

pub fn custom_get_exp (a Bigfloat) i64 {
	return C.mpfr_custom_get_exp (&a)
}

fn C.mpfr_custom_move (&Bigfloat, voidptr)

pub fn custom_move (mut a Bigfloat, ptr voidptr) {
	C.mpfr_custom_move (&a, ptr)
}

fn C.mpfr_custom_init_set (&Bigfloat, int, i64, Mpfr_prec, voidptr)

pub fn custom_init_set (mut a Bigfloat, k int, e i64, p Mpfr_prec, ptr voidptr) {
	C.mpfr_custom_init_set (&a, k, e, p, ptr)
}

fn C.mpfr_custom_get_kind (&Bigfloat) int

pub fn custom_get_kind (a Bigfloat) int {
	return C.mpfr_custom_get_kind (&a)
}


fn C.mpfr_total_order_p (&Bigfloat, &Bigfloat) int

pub fn total_order_p (a Bigfloat, b Bigfloat) int {
	return C.mpfr_total_order_p (&a, &b)
}


