function [fit,errdb] = rationalfit(freq,data,varargin)
%RATIONALFIT Perform rational fitting to complex frequency-dependent data.
%   FIT = RATIONALFIT(FREQ,DATA) uses vector fitting with complex
%   frequencies S = j*2*pi*FREQ to construct a rational function fit
%
%            C(1)     C(2)           C(n)
%   F(S) =  ------ + ------ + ... + ------
%           S-A(1)   S-A(2)         S-A(n)
%
%   FREQ is a vector of nonnegative frequencies in Hz. DATA is a single
%   vector, or a 2-d array (column vectors), or a 3-d array of network
%   parameter data.  The length of the DATA vectors must be equal to the
%   length of FREQ. Fit results are returned as an RFMODEL.RATIONAL object.
%
%   FIT = RATIONALFIT(FREQ,DATA,TOL) constructs a fit that attempts to
%   satisfy a relative error tolerance specified in dB by the optional
%   argument TOL. The default value of TOL is -40 dB, i.e. 20*log10(1e-2).
%
%   FIT = RATIONALFIT(...,NAME1,VAL1,NAME2,VAL2,...) constructs a more
%   general fit
%
%            C(1)     C(2)           C(n)
%   F(S) = (------ + ------ + ... + ------ + D) * EXP(-S*DELAY*DELAYFACTOR)
%           S-A(1)   S-A(2)         S-A(n)
%
%   according to optional name-value pair arguments.
%
%   [FIT,ERRDB] = RATIONALFIT(...) returns ERRDB, the achieved relative
%   error in dB.
%
%   FIT = RATIONALFIT(S_OBJ,I,J,...) for S-parameters object S_OBJ fits Sij
%   using FREQ = S_OBJ.Frequencies and DATA = rfparam(S_OBJ,I,J).
%
%   FIT = RATIONALFIT(FREQ,DATA,TOL,WEIGHT,DELAYFACTOR,TENDSTOZERO,NPOLES,
%   ITERATIONLIMIT,SHOWBAR) also constructs a more general fit according to
%   non-empty input arguments. Empty arguments [] are left at their default
%   values. Support for this syntax will be removed in a future release.
%   Use name-value pairs instead.
%
%   Name-value pair arguments:
%   --------------------------
%
%   'Tolerance'         Relative error tolerance in decibels, specified as
%                       a scalar less than or equal to zero.
%
%                       Default: -40
%
%   'TendsToZero'       A logical variable specifying the behavior of the
%                       rational fit F(S) for large S. When true, the D
%                       term of the fit is set to zero so that the rational
%                       fit F(S) tends to zero as S approaches infinity.
%                       When false, a nonzero D will be allowed.
%
%                       Default: true (set D to zero so that F(S) -> 0)
%
%   'NPoles'            Either a scalar nonnegative integer specifying the
%                       number of poles, or a two-element vector of
%                       nonnegative integers specifying a search range. The
%                       number of poles might be less than specified if any
%                       computed residues are zero.
%
%                       Default: [0 48]
%
%   'Weight'            A nonnegative frequency-weighting array equal in
%                       size to the DATA array. WEIGHT values less than one
%                       de-emphasize the DATA at corresponding FREQ values.
%
%                       Default: ones(size(DATA)) (use equal weighting)
%
%   'DelayFactor'       A real scalar between 0 and 1 inclusive, specifying
%                       the fraction of estimated delay to extract from the
%                       DATA before rational fitting,
%                       NEW_DATA = DATA * EXP(S*DELAY*DELAYFACTOR).
%
%                       Default: 0 (do not remove any delay)
%
%   'IterationLimit'    The maximum number of rationalfit iterations,
%                       specified as a positive integer. Provide a
%                       two-element vector to specify the minimum and
%                       maximum.
%
%                       Default: [4 24]
%
%   'WaitBar'           A logical variable specifying whether to display a
%                       waitbar.
%
%                       Default: false (run without a waitbar)
%
%   EXAMPLE:
%
%   S = sparameters('passive.s2p');
%   fit = rationalfit(S,1,1,'TendsToZero',false);
%
%   See also S2TF, SNP2SMP, RFMODEL.RATIONAL

%   B. Gustavsen and A. Semlyen, "Rational Approximation of Frequency
%   Domain Responses by Vector Fitting", IEEE Transactions on Power
%   Delivery, Vol. 14, No. 3, pp. 1052-1061, July 1999.
%
%   B. Gustavsen, "Improving the Pole Relocating Properties of Vector
%   Fitting", IEEE Transactions on Power Delivery, Vol. 21, No. 3, pp.
%   1587-1592, July 2006.
%
%   D. Deschrijver, M. Mrozowski, T. Dhaene, D. De Zutter, "Macromodeling
%   of Multiport Systems Using a Fast Implementation of the Vector Fitting
%   Method", IEEE Microwave and Wireless Components Letters, Vol. 18, No.
%   6, pp. 383-385, June 2008.

%   Copyright 2006-2012 The MathWorks, Inc.


[fit,errdb] = rationalfitcore(freq,data,varargin{:});