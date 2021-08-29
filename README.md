# V_mpfr is a MPFR porting to V #


The MPFR is the [GNU Multiprecision Floating-point](https://www.mpfr.org/) Computations with _correct rounding_.

The documentation is to be taken from the original MPFR documents: [mpdf.pdf](https://www.mpfr.org/mpfr-current/mpfr.pdf).

For the usage, see the docs folder.

## API ##
See the test file mpfr_test.v to examples.

The Api has been adaptated to the naming of V. The routines ending in _ui, _si and _d have been renamed in _u64, _i64 and _f64.

Most of the routines taking a pointer to the result as first argument return instead the result.

## Dependencies ##
Mpfr depends of gmp.
Use the _float_ branch of v_gmp for now until it is merged in the _main_ branch.


## Licence ##
MPFR is distributed under the [GNU Lesser General Public License](https://www.gnu.org/licenses/lgpl-3.0.html).

v_mpfr is under the [MIT License](https://mit-license.org/)