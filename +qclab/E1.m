%> @file E1.m
%> @brief Implements E1
% ==============================================================================
%> @brief E1
%
%> @param issparse 
%
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.  
% ==============================================================================
function [E1] = E1(issparse)
if nargin < 1; issparse = false; end
if issparse 
  E1 = sparse([0 0; 0 1]) ;
else
  E1 = [0 0; 0 1];
end
end

