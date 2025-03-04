%> @file applyGateTo.m
%> @brief Implements the multiplication of a unitary gate to a matrix or a
%> struct
% ==============================================================================
%> @brief Checks if the current is a matrix or a struct and and muliplies a gate 
%> given as unitary matrix to it
%
%> @param current matrix or struct containing states where gate should be 
%> applied to
%> @param unitary unitary matrix which describes the gate
%> @param side 'L' or 'R' side application in quantum circuit
%
%> @retval current matrix or state after applying the gate 
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================
function [current] = applyGateTo(current, unitary, side)

 if isa(current, 'double') % apply to a matrix (can be a state vector)
     if strcmp(side, 'L') % left
        current = current * unitary ;
     else % right
        current = unitary * current ;
     end
 else % apply to a struct
     nbstatevector = length(current.states) ;
     for i = 1:nbstatevector
         current.states{i} = unitary*current.states{i} ;
     end   
end