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
% (C) Copyright Roel Van Beeumen and Daan Camps 2021.  
% ==============================================================================

H = @qclab.qgates.Hadamard ;
X = @qclab.qgates.PauliX ;
CNOT = @qclab.qgates.CNOT ;

nbQubits = 5 ; % the length of the input string

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

% Draw the balanced oracle
fprintf( 1, '\n\nBalanced oracle:\n\n' );
balancedOracle.draw ;

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
end

% Draw the Deutsch-Josza circuit
fprintf( 1, '\n\nDeutsch-Josza circuit:\n\n' );
djCircuit.draw ;

% Simulate the circuit, interpret results and plot probabilities
psi = eye( 2^(nbQubits + 1), 1 );
psi = djCircuit.apply( 'R', 'N', nbQubits + 1, psi );
p = abs(psi).^2;

if p(1) + p(2) > 1 - eps(100)
  fprintf( 1, '\nDetected constant Oracle.\n' );
else
  fprintf( 1, '\nDetected balanced Oracle.\n' );
end

myXticklabels = cell( 2^(nbQubits + 1 ), 1 );
for i = 0:2^(nbQubits + 1)-1
  myXticklabels{i+1} = dec2bin( i, nbQubits );
end

figure(1); clf
bar( 1:2^(nbQubits + 1), p );
xticks( 1:2^(nbQubits + 1) );
xticklabels( myXticklabels );
ylabel('Probabilities');