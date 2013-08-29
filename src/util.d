module util;

/**
 * Optimized versions of functions that can be found in the
 * standard library, or small ubiquitous functions that have no
 * other home.
 */

import types : coeff_t;
import sig : CoeffIPair;
import std.range : isInputRange, array, zip, iota;
import std.algorithm : map, sort;

import std.math : abs;

T min(T)(T a, T b)
{
	return (a < b) ? a : b;
}

T max(T)(T a, T b)
{
	return (a > b) ? a : b;
}

CoeffIPair[] largestCoeffs(C)(C[] coeffs, int num_coeffs, short skip_head_amt = 0)
if(is(C : coeff_t))
{
	short i = skip_head_amt;

	version(DigitalMars)
	{
		// Workaround for DMD 2.063 bug
		scope coeff_set =
		  zip(
		  	iota(i, cast(short)coeffs.length),
		  	coeffs[i..$]).
		  map!(a => CoeffIPair(a[0], a[1])).array();
	}
	else
	{
		// Ah, nice, fast, and consice.
		scope coeff_set = coeffs[i..$].map!(a => CoeffIPair(i++, a))().array();
	}

	sort!((a, b) => abs(a.coeff) > abs(b.coeff))(coeff_set);

	return coeff_set[0..num_coeffs].array(); //.array because coeff_set is scope
}

unittest {
	auto coeffs = [1.0, 2.0, 5.0, 3.0];
	assert(coeffs.largestCoeffs(2) ==
		[CoeffIPair(2, 5.0), CoeffIPair(3, 3.0)]);
	assert(coeffs.largestCoeffs(3) ==
		[CoeffIPair(2, 5.0), CoeffIPair(3, 3.0), CoeffIPair(1, 2.0)]);
	assert(coeffs.largestCoeffs(0) ==
		[]);
}

unittest {
	auto coeffs = [1.0, -2.0, -6.0, 3.0];
	assert(coeffs.largestCoeffs(2) ==
		[CoeffIPair(2, -6.0), CoeffIPair(3, 3.0)]);
}