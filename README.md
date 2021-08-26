# V_mpfr is a MPFR porting to V #

## This is highly experimental ##

The MPFR is the GNU Multiprecision Floating-point Computations with _correct rounding_.

See the test file mpfr_test.v to examples

The documentation is to be taken from the original MPFR documents: [mpdf.pdf](https://www.mpfr.org/mpfr-current/mpfr.pdf)

## API ##
See the docs folder.

The Api has been adaptated to the naming of V. The routines ending in _ui, _si and _d have been renamed in _u64, _i64 and _f64.

Most of the routines taking a pointer to the result as first argument return instead the result.

## Licence ##
MPFR is distributed under the [GNU Lesser General Public License](https://www.gnu.org/licenses/lgpl-3.0.html).

v_mpfr is under the [MIT License](https://mit-license.org/)