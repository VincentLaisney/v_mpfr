import mpfr

fn test_new() {
	// mpfr.set_default_prec(100)
	a := mpfr.new()
	assert mpfr.nan_p(a)
}

fn test_set_nan () {
	mut a := mpfr.new()
	mpfr.set_nan(mut a)
	assert mpfr.nan_p(a)
	assert a.str() == '@NaN@'
}

fn test_set_inf () {
	mut a := mpfr.new()
	mpfr.set_inf(mut a, false)
	assert mpfr.inf_p(a)
	assert a.str() == '@Inf@'
}

fn test_set_zero () {
	mut a := mpfr.new()
	mpfr.set_zero(mut a, false)
	assert mpfr.zero_p(a)
	assert '$a' == '0'
}

fn test_str() {
	// mpfr.set_default_prec(100)
	n := mpfr.from_u64(20387)
	mut ctx := mpfr.get_def_print_ctx()
	mut str := n.str_ctx(ctx)
	assert str == '20387'
	m := mpfr.from_f64(54.9864)
	str = m.str_ctx(ctx)
	assert str == '54.9864'

	assert mpfr.from_u64(0).str() == '0'
	assert mpfr.from_u64(1).str() == '1'
	assert mpfr.from_u64(10).str() == '10'
	assert mpfr.from_i64(-1).str() == '-1'
	assert mpfr.from_i64(-3840).str() == '-3840'
	assert mpfr.from_f64(0.1).str() == '0.1'
	assert mpfr.from_f64(0.01).str() == '0.01'
	assert mpfr.from_f64(0.0000000001).str() == '0.0000000001'
	assert mpfr.from_f64(0.0000012345678925382).str() == '1.2345678925382e-6'
	a := mpfr.from_str('23106781544764764944') or {panic('in test_str()')}
	assert a.str() == '2.310678154476476e19'
	save_prec := mpfr.get_default_prec()
	mpfr.set_default_prec(70)
	ctx.ndigits = 21
	assert a.str_ctx(ctx) == '23106781544764764160'
	mpfr.set_default_prec(save_prec)
	// println(mpfr.get_default_prec())
	}

fn test_from_u64() {
	// mpfr.set_default_prec(100)
	save_prec := mpfr.get_default_prec()
	mpfr.set_default_prec(70)
	mut ctx := mpfr.get_def_print_ctx()
	ctx.ndigits = 22
	assert mpfr.from_u64(18446744073709551615).str_ctx(ctx) == '18446744073709551615'
	mpfr.set_default_prec(save_prec)
	assert mpfr.from_u64(6233557743477244810).str() == '6.233557743477245e18'
}

fn test_from_i64() {
	// mpfr.set_default_prec(100)
	assert mpfr.from_i64(0).str() == '0'
	assert mpfr.from_i64(9223372036854775807).str() == '9.223372036854776e18'

	save_prec := mpfr.get_default_prec()
	mpfr.set_default_prec(70)
	mut ctx := mpfr.get_def_print_ctx()
	ctx.ndigits = 20
	assert mpfr.from_i64(-9223372036854775808).str_ctx(ctx) == '-9223372036854775808'
	mpfr.set_default_prec(save_prec)
}

fn test_from_f32() {
	assert mpfr.from_f32(5406511.436).str() == '5406511.5'
}

fn test_from_f64() {
	// mpfr.set_default_prec(100)
	assert mpfr.from_f64(9.3847212e-23).str() == '9.3847212e-23'
}

fn test_from_str() ? {
	if x := mpfr.from_str('not a string') {
		assert true
	}
}

fn test_f32() {
	a := mpfr.from_str('28.5') or {panic('test_f32')}
	assert a.f32() == 28.5
}

fn test_f64() {
	a := mpfr.from_str('34.2') or {panic('test_f64')}
	assert a.f64() == 34.2
}

fn test_u64() {
	a := mpfr.from_str('7364') or {panic('test_u64')}
	assert a.u64() == 7364
}

fn test_i64() {
	a := mpfr.from_str('5281') or {panic('test_i64')}
	assert a.i64() == 5281
	b := mpfr.from_str('-837') or {panic('test_i64-2')}
	assert b.i64() == -837
}

fn test_plus () {
	mpfr.clear_flags() // dont forget!
	a := mpfr.from_u64(372682)
	b := mpfr.from_i64(2972)
	assert '${a + b}' == '375654'
	assert mpfr.get_retval() == 0 // no rounding
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.divby0_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert ! mpfr.inexflag_p()

	mpfr.clear_flags() // dont forget!
	mut n := mpfr.new()
	mpfr.set_nan(mut n)
	assert mpfr.nanflag_p()
	mpfr.clear_nanflag()
	assert '${a + n}' == '@NaN@'
	assert mpfr.nanflag_p()
}

fn test_minus () {
	mpfr.clear_flags() // dont forget!
	a := mpfr.from_u64(94837)
	b := mpfr.from_i64(92528)
	assert '${a - b}' == '2309'
	assert '${b - a}' == '-2309'
	assert mpfr.get_retval() == 0 // no rounding
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.divby0_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert ! mpfr.inexflag_p()
}

fn test_mul () {
	mpfr.clear_flags() // dont forget!
	a := mpfr.from_u64(3857)
	b := mpfr.from_i64(6291)
	assert '${a * b}' == '24264387'
	assert mpfr.get_retval() == 0 // no rounding
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.divby0_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert ! mpfr.inexflag_p()

	c := mpfr.from_f64(38.57)
	d := mpfr.from_i64(-6291)
	assert '${c * d}' == '-242643.87'
	assert mpfr.get_retval() == 1 // UP rounding !
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.divby0_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert mpfr.inexflag_p() // thus inexact
}

fn test_divide () {
	mpfr.clear_flags() // dont forget!
	a := mpfr.from_u64(3857)
	b := mpfr.from_i64(6291)
	c := a / b
	assert '${c}' == '6.130980766173899e-1'
	assert mpfr.get_retval() == -1 // DOWN rounding
	d_ctx := mpfr.get_def_print_ctx() // change only display
	ctx := mpfr.PrintContext{...d_ctx ndigits: 5}
	assert c.str_ctx(ctx) == '0.6131'
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.divby0_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert mpfr.inexflag_p() // thus inexact

	d := b / a
	assert '${d}' == '1.631060409644802'
}

fn test_div_by_zero () {
	mpfr.clear_flags() // dont forget!
	a := mpfr.from_u64(3857)
	b := mpfr.from_i64(0)
	assert '${a / b}' == '@Inf@'
	assert mpfr.get_retval() == 0
	assert mpfr.divby0_p()
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert ! mpfr.inexflag_p() // EXACT
}

fn test_mod () {
	mpfr.clear_flags() // dont forget!
	a := mpfr.from_u64(38537)
	b := mpfr.from_i64(6291)
	c :=  a / b
	d :=  mpfr.rint_trunc(c, .rndz)
	assert d.str() == '6'
	mpfr.clear_flags() // dont forget!
	assert '${a % b}' == '791'
	assert mpfr.get_retval() == 0
	assert ! mpfr.divby0_p()
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert ! mpfr.inexflag_p()
}

fn test_divrem () {
	// division to the nearest and remainder from this division
	a := mpfr.from_u64(38537)
	b := mpfr.from_i64(6291)
	mpfr.clear_flags()
	c :=  a / b
	d := mpfr.rint(c, .rndn) // rounded to nearst
	assert d.str() == '6'
	assert mpfr.get_retval() == -2 // Down rounded
	assert mpfr.inexflag_p() // thus inexact
	assert ! mpfr.divby0_p()
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()

	mpfr.clear_flags()
	e := mpfr.remainder(a, b) // rounded according to defaut MathContext
	assert e.str() == '791'
	assert mpfr.get_retval() == 0
	assert ! mpfr.divby0_p()
	assert ! mpfr.underflow_p()
	assert ! mpfr.overflow_p()
	assert ! mpfr.nanflag_p()
	assert ! mpfr.erangeflag_p()
	assert ! mpfr.inexflag_p()
}