%> @file djAlgorithm.m
%> @brief Implements an example circuit for the Deutsch-Josza algorithm.
% ==============================================================================
%
%> Reference: 
%>    David Deutsch and Richard Jozsa (1992). "Rapid solutions of problems by 
%>    quantum computation". Proceedings of the Royal Society of London A. 
%>    439: 553–558.
%>
%>    Section 1.4.4 of Quantum Computation and Quantum Information. 
%>    M. Nielsen, and I. L. Chuang.
%>
%> This example is inspired by Qiskit: 
%>    https://qiskit.org/textbook/ch-algorithms/deutsch-jozsa.html
%>
%> The Deutsch-Josza algorithm decides if a function f is either constant for
%> all input bitstrings x of length n, or if f is a balanced functions for all
%> bitstrings x of length n.
%
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================

H = @qclab.qgates.Hadamard ;
X = @qclab.qgates.PauliX ;
CNOT = @qclab.qgates.CNOT ;
M = @qclab.Measurement ;

nbQubits = 3 ; % the length of the input string

% Constant Oracle
% ------------------------------------------------------------------------------
constantOracle = qclab.QCircuit( nbQubits + 1 );

output = randi([0 1]); % generate random 0 or 1
if output == 1
  constantOracle.push_back( X( nbQubits ) );
end

% Draw the constant oracle
fprintf( 1, '\n\nConstant oracle:\n\n' );
constantOracle.draw ;
% TeX circuit
fID = fopen('constant_oracle.tex','w');
constantOracle.toTex(fID, 'S');
fclose(fID);

% Balanced Oracle
% ------------------------------------------------------------------------------
balancedOracle = qclab.QCircuit( nbQubits + 1 );

bitString = sprintf('%d', randi([0 1], 1, nbQubits) )

% Place X-gates
for qubit = 1:length(bitString)
  if strcmp( bitString(qubit), '1' )
    balancedOracle.push_back( X( qubit - 1 ) );
  end
end

% Controlled-NOT gates
for qubit = 0:nbQubits-1
  balancedOracle.push_back( CNOT( qubit, nbQubits ) );
end

% Place X-gates
for qubit = 1:length(bitString)
  if strcmp( bitString(qubit), '1' )
    balancedOracle.push_back( X( qubit - 1 ) );
  end
end

% Draw the balanced oracle and write to TeX
fprintf( 1, '\n\nBalanced oracle:\n\n' );
balancedOracle.draw ;
% TeX circuit
fID = fopen('balanced_oracle.tex','w');
balancedOracle.toTex(fID, 'S');
fclose(fID);


% Complete Deutsch-Josza circuit
% ------------------------------------------------------------------------------
djCircuit = qclab.QCircuit( nbQubits + 1 );

% Initial superposition
for qubit = 0:nbQubits - 1
  djCircuit.push_back( H( qubit ) );
end

djCircuit.push_back( X( nbQubits ) );
djCircuit.push_back( H( nbQubits ) );

% Randomly add constant or balanced oracle
output = randi([0 1]); % generate random 0 or 1
if output == 0
  djCircuit.push_back( constantOracle );
  fprintf( 1, '\nAdding the constant Oracle to the circuit.\n' );
else
  djCircuit.push_back( balancedOracle );
  fprintf( 1, '\nAdding the balanced Oracle to the circuit.\n' );
end

% Repeat H-gates
for qubit = 0:nbQubits - 1
  djCircuit.push_back( H( qubit ) );
  djCircuit.push_back( M( qubit ) );
end

% Draw the Deutsch-Josza circuit
fprintf( 1, '\n\nDeutsch-Josza circuit:\n\n' );
djCircuit.draw ;
% TeX circuit
fID = fopen('Deutsch_Josza.tex','w');
djCircuit.toTex(fID, 'S');
fclose(fID);

% Simulate the circuit and interpret results
psi = eye( 2^(nbQubits + 1), 1 );
sim = djCircuit.simulate( psi );
results = sim.results
if strcmp(sim.results(1), '000')
  fprintf( 1, '\nDetected constant Oracle.\n' );
else
  fprintf( 1, '\nDetected balanced Oracle.\n' );
end

