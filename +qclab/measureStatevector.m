%> @file measureStatevector.m
%> @brief Implements a quantum measurement of a state vector
% ==============================================================================
%> @brief Simulates the measurement of a single qubit given a state vector
%
%> @param statevector state vector of the state which should be measured
%> @param qubit which should be measured
%> @param nbQubits qubit size of `statevector`
%> @param basisChange objects of qclab.qgates.QGate1 represent the basis
%> change
%> @param tol tolerance up to which a probability is considered as zero
%
%> @retval prob_1 probabilty that measurement result is 1
%> @retval state_0 collapsed state after measuring 0
%> @retval state_1 collapsed state after measuring 1
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================

function [prob_1,state_0, state_1] = measureStatevector( ...
  statevector, qubit, nbQubits, basisChange, tol)

% basis change
for i = 1:length(basisChange)
  basisChange(i).setQubit(qubit);
  statevector = apply(basisChange(i), 'R', 'N', nbQubits, ...
    statevector);
end

% measuring in 'z'-basis

% Computes for every index if qubit is 0 or 1 in that basis state
qubit_basis_states = bitget(0:length(statevector)-1, ...
  log2(length(statevector)) - qubit);
% Calculate the probability to measure 1
prob_1 = sum(abs(statevector(qubit_basis_states == 1)).^2);
% if probability measuring 0 is 0
if abs(prob_1 - 1) < tol
  state_1 = statevector;
  state_1(qubit_basis_states == 0) = 0;
  state_1 = 1/sqrt(prob_1) * state_1;
  state_0 = [];
  % basis change back
  for i = length(basisChange):-1:1
    state_1 = apply(basisChange(i), 'R', 'C', nbQubits, ...
      state_1);
  end
% if probability measuring 1 is 0
elseif abs(prob_1) < tol
  state_0 = statevector;
  state_0(qubit_basis_states == 1) = 0;
  state_0 = 1/sqrt(1-prob_1) * state_0;
  state_1 = [];
  % basis change back
  for i = length(basisChange):-1:1
    state_0 = apply(basisChange(i), 'R', 'C', nbQubits, ...
      state_0);
  end
% if both probability are non zero 
else
  % New state vector when 0 is measured
  state_0 = statevector;
  state_0(qubit_basis_states == 1) = 0;
  state_0 = 1/sqrt(1-prob_1) * state_0;
  % New state vector when 1 is measured
  state_1 = statevector;
  state_1(qubit_basis_states == 0) = 0;
  state_1 = 1/sqrt(prob_1) * state_1;
  % basis change back
  for i = length(basisChange):-1:1
    state_0 = apply(basisChange(i), 'R', 'C', nbQubits, ...
      state_0);
    state_1 = apply(basisChange(i), 'R', 'C', nbQubits, ...
      state_1);
  end
end
end