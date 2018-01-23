function mu_minus_1 = lna_match_stabilization_helper(propval, fc, ckt, element, propname)
%LNA_MATCH_STABILIZATION_HELPER Return Stability MU-1.
%   MU_MINUS_1 = LNA_MATCH_STABILIZATION_HELPER(PROPVALUE, FC, CKT,
%   ELEMENT, PROPNAME) returns stability parameter MU-1 of a circuit, CKT
%   when the property called PROPNAME of an element, ELEMENT is set to
%   PROPVAL.
%
%   LNA_MATCH_STABILIZATION_HELPER is a helper function of RF
%   Toolbox demo: Designing Matching Networks (Part 1: Networks with an LNA
%   and Lumped Elements).

%   Copyright 2007-2008 The MathWorks, Inc.

set(element, propname, propval)
analyze(ckt, fc);
mu_minus_1 = stabilitymu(ckt.AnalyzedResult.S_Parameters) - 1;