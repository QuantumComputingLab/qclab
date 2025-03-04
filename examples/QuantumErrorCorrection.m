%> @file QuantumErrorCorrection.m
%> @brief Implements an example for quantum error correction.
% ==============================================================================
%
%> Reference:
%>
%>    Section 10.1.1 of Quantum Computation and Quantum Information.
%>    M. Nielsen, and I. L. Chuang.
%>
%> This example is inspired by qiskit:
%>    https://github.com/qiskit-community/qiskit-community-tutorials/blob/master
%>    /awards/teach_me_quantum_2018/intro2qc/10.Quantum%20error%20correction
%>    .ipynb
%>
%> Quantum error correction is a method to protect quantum information from
%> errors during transmission or computation. We look at a single bit flip
%> error on one qubit. This involves encoding the qubit into an entangled state,
%> detecting errors using ancilla qubits, and applying corrections based on the
%> detected error.
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================

% State to be protected
% ------------------------------------------------------------------------------
psi = rand(2,1)+1i*rand(2,1);
psi = psi/norm(psi);

% Building the quantum error correction circuit
% ------------------------------------------------------------------------------
CNOT = @qclab.qgates.CNOT;
X = @qclab.qgates.PauliX;
M = @qclab.Measurement;
MCX = @qclab.qgates.MCX;

qec = qclab.QCircuit(5);

% Entangle the state
qec.push_back(CNOT(0,1));
qec.push_back(CNOT(0,2));

% Introducing an potential single bit flip error
error = randi([0,3],1,1);

if error == 1
  qec.push_back(X(0));
elseif error == 2
  qec.push_back(X(1));
elseif error == 3
  qec.push_back(X(2));
end

% Detect the potential error
qec.push_back(CNOT(0,3));
qec.push_back(CNOT(1,3));
qec.push_back(CNOT(0,4));
qec.push_back(CNOT(2,4));

qec.push_back(M(3));
qec.push_back(M(4));

% Fix the error if necessary
qec.push_back(MCX([3,4],2,[0,1]))
qec.push_back(MCX([3,4],1,[1,0]))
qec.push_back(MCX([3,4],0,[1,1]))

% Detangle the state
qec.push_back(CNOT(0,1));
qec.push_back(CNOT(0,2));

% draw circuit
% ------------------------------------------------------------------------------

qec.draw;

%initial statevector, first qubit in state psi and other qubits in state 0
%simulate circuit on the initial statevector 
% ------------------------------------------------------------------------------
v = kron(psi,eye(16,1));
res = qec.simulate(v);

% Reduce the statevector to the first qubit, given that the second and third 
% qubits are in the state 0, and the fourth and fifth qubits are in the state 
% measured midway through the circuit.
% ------------------------------------------------------------------------------

red = qclab.reducedStatevector(res.states(1),[1:4],['00',res.results(1)]);

fprintf( 1, ['\n State before noisy channel:\n'] );
disp(psi)
if error == 0
  fprintf( 1, [' No bit flip error occured\n'] );
elseif error == 1
  fprintf( 1, [' Bit flip error on first qubit\n'] );
elseif error == 2
  fprintf( 1, [' Bit flip error on second qubit\n'] );
else
  fprintf( 1, [' Bit flip error on third qubit\n'] );
end

fprintf( 1, ['\n State after noisy channel:\n'] );
disp(red)




