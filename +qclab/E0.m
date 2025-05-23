%> @file E0.m
%> @brief Implements E0
% ==============================================================================
%> @brief E0
%
%> @param issparse 
%
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.  
% ==============================================================================
function [E0] = E0(issparse)
if nargin < 1; issparse = false; end
if issparse 
  E0 = sparse([1 0; 0 0]) ;
else
  E0 = [1 0; 0 0];
end
end

