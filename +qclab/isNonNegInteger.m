%> @file isNonNegInteger.m
%> @brief Implements non-negative integer check
% ==============================================================================
%> @brief Checks if `i` is a scalar, non-negative integer
%
%> @param i potential non-negative integer
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function [tf] = isNonNegInteger(i)
if ~isnumeric(i) || ~isscalar(i) || ~isreal(i) || mod(i,1) ~= 0 || i < 0
  tf = false ;
else
  tf = true ;
end
end

