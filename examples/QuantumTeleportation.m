%> @file QuantumTeleportation.m
%> @brief Implements an example circuit for Quantum Teleportation.
% ==============================================================================
%
%> Reference: 
%>
%>    Section 6.1 of Quantum Computation and Quantum Information. 
%>    M. Nielsen, and I. L. Chuang.
%>
%> Quantum teleportation transfers a state \(\ket{v}\) from one qubit (sender) 
%> to another (receiver) using entanglement and classical communication.
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================

% State to be teleported
% ------------------------------------------------------------------------------
v = rand(2,1)+1i*rand(2,1);
v = v/norm(v);

fprintf( 1, '\n State to be teleported:\n' );

disp(v)

% Bell State
% ------------------------------------------------------------------------------
bell = [1/sqrt(2);0;0;1/sqrt(2)];

% create initial state
% ------------------------------------------------------------------------------
initial_state = kron(v,bell);

% building the circuit
% ------------------------------------------------------------------------------
CNOT = @qclab.qgates.CNOT;
H = @qclab.qgates.Hadamard;
M = @qclab.Measurement;
CZ = @qclab.qgates.CZ;

qt = qclab.QCircuit(3);
qt.push_back(CNOT(0,1));
qt.push_back(H(0));
qt.barrier
qt.push_back(M(0));
qt.push_back(M(1));
qt.push_back(CNOT(1,2));
qt.push_back(CZ(0,2));

% draw and simulate circuit
% ------------------------------------------------------------------------------

fprintf( 1, '\n Simulate the following circuit:\n' );

qt.draw;
res = qt.simulate(initial_state);

% check if the teleportation was successful by comparing the statevector
% reduced to the third qubit for all four measurement outcomes with v
% ------------------------------------------------------------------------------
tol=1e-10;
success = all(arrayfun(@(i) all(abs(v - qclab.reducedStatevector(...
              res.states(i), [0,1], res.results(i))) < tol), 1:4));

fprintf(1, '\nTeleportation successful: %s\n', string(success));

