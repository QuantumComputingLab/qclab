%> @file qId.m
%> @brief Implements quantum Identity matrix
% ==============================================================================
%> @brief Identity matrix on n qubits
%
%> @param n number of qubits
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function [I] = qId(n,issparse)
if nargin < 2; issparse = false; end
if issparse 
  I = speye(2^n) ;
else
  I = eye(2^n);
end
end

