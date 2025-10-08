%> @file GroverAlgorithm.m
%> @brief Implements an example circuit for the Grover algorithm.
% ==============================================================================
%
%> Reference: 
%>    Grover, L. K. (1996, July). A fast quantum mechanical algorithm for 
%>    database search. In Proceedings of the twenty-eighth annual ACM 
%>    symposium on Theory of computing (pp. 212-219).
%>
%>    Section 6.1 of Quantum Computation and Quantum Information. 
%>    M. Nielsen, and I. L. Chuang.
%>
%> This example is inspired by Qiskit:
%> https://github.com/Qiskit/textbook/blob/main/notebooks/ch-algorithms/
%> grover.ipynb
%>   
%>
%> Grover's Algorithm provides a quadratic speedup for unstructured search 
%> problems, allowing the solution to be found in O(sqrt(N)) time, where N is
%> the number of possible solutions.
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================

% We set N = 4 and assume we are looking for the state '11' within the
% states '00','01','10' and '11'. For that we need two qubits

nbQubits = 2;


% Oracle flipping the phase of the "good" state '11'. 
% ------------------------------------------------------------------------------

CZ = @qclab.qgates.CZ;

oracle = qclab.QCircuit( nbQubits );
oracle.push_back(CZ(0,1))

fprintf( 1, '\n\n grover oracle:\n\n' );
oracle.draw ;

oracle.asBlock('oracle');


% Check if oracle does the correct thing
% ------------------------------------------------------------------------------
H = @qclab.qgates.Hadamard;
M = @qclab.Measurement;

circuit = qclab.QCircuit( nbQubits );
circuit.push_back(H(0));
circuit.push_back(H(1));
circuit.push_back(oracle)
res = circuit.simulate('00');

fprintf( 1, '\n\n statevector after applying oracle:\n\n' );
statevector = res.states

% Implementing the diffuser
% ------------------------------------------------------------------------------
Z = @qclab.qgates.PauliZ;
 
diffuser = qclab.QCircuit( nbQubits );
diffuser.push_back(H(0));
diffuser.push_back(H(1));
diffuser.push_back(Z(0));
diffuser.push_back(Z(1));
diffuser.push_back(CZ(0,1));
diffuser.push_back(H(0));
diffuser.push_back(H(1));

fprintf( 1, '\n\n grover diffuser:\n\n' );
diffuser.draw ;

diffuser.asBlock('diffuser');

% Implementing the whole grover circuit
% ------------------------------------------------------------------------------

grover_circuit = qclab.QCircuit( nbQubits );
grover_circuit.push_back(H(0));
grover_circuit.push_back(H(1));
grover_circuit.push_back(oracle);
grover_circuit.push_back(diffuser);
grover_circuit.push_back(M(0));
grover_circuit.push_back(M(1));

fprintf( 1, '\n\n grover circuit:\n\n' );

grover_circuit.draw;

res = grover_circuit.simulate('00');

fprintf( 1, '\n We measure \n' );

res.results(1)

fprintf( 1, '\n with probability \n' );

res.probabilities(1)


