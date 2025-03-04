%> @file reducedStatevector.m
%> @brief Implements the reduction of a state vector
% ==============================================================================
%> @brief Reduces a state vector to certain qubits given that the state of the
%> other qubits is a known basis state
%
%> @param statevector state vector of the state which should be reduced
%> @param fixed_qubits qubits which are in a known basis state
%> @param fixed_states basis states of known qubits
%
%> @retval red reduced state vector of qubits other than the fixed_qubits
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================
function [red] = reducedStatevector(statevector, fixed_qubits, fixed_states, ...
  basisChange)
if nargin == 3, basisChange = cell(length(fixed_qubits),1); end
tol = 1e-10;
nbQubits = log2(length(statevector));
assert(mod(nbQubits, 1) == 0)
assert(all(fixed_qubits<nbQubits))
num_reduced_qubits = nbQubits - length(fixed_qubits);  % Number of qubits in
% reduced state
if num_reduced_qubits == 0
  red = [];
  return
end
num_reduced_states = 2^num_reduced_qubits;  % number basis states in reduced
% state

% Change basis if necessary
for i = 1:length(fixed_qubits)
  qubit = fixed_qubits(i);
  basisChange_qubit = basisChange{i};
  for j = 1:length(basisChange_qubit)
    basisChange_qubit(j).setQubit(qubit);
    statevector = apply(basisChange_qubit(j), 'R', 'N', nbQubits, ...
      statevector);
  end
end

% get the part of the basis states belonging to qubits
bitstr = dec2bin(0:length(statevector)-1,nbQubits);
red = zeros(num_reduced_states, 1);
j = 1;
for i = 1:length(statevector)
  if ~strcmp(bitstr(i,fixed_qubits+1),fixed_states)
    assert(statevector(i) <= tol, 'state vector does not fit known qubits');
  else
    red(j) = statevector(i);
    j = j+1;
  end
end
end