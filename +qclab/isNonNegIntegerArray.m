%> @file isNonNegIntegerArray.m
%> @brief Implements non-negative integer array check
% ==============================================================================
%> @brief Checks if `i` is an array of non-negative integers
%
%> @param i potential non-negative integer array
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function [tf] = isNonNegIntegerArray(i)
if ~isnumeric(i) || ~isreal(i) || sum(mod(i,1) == 0) ~= length(i) || ...
    ~isempty(i(i < 0))
  tf = false ;
else
  tf = true ;
end
end

