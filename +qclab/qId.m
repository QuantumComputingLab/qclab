%> @file qId.m
%> @brief Implements quantum Identity matrix
% ==============================================================================
%> @brief Identity matrix on n qubits
%
%> @param n number of qubits
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function [I] = qId(n)
  I = eye(2^n) ;
end

