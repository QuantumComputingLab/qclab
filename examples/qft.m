%> @file qft.m
%> @brief Implements qft example circuit.
% ==============================================================================
%
%> Reference: 
%>    Quantum Fourier transform revisited. D. Camps, R. Van Beeumen, and C. Yang
%>    Numer Linear Algebra Appl. 2021;28:2331. DOI: 10.1002/nla.2331
%
% (C) Copyright Roel Van Beeumen and Daan Camps 2021.  
% ==============================================================================

nbQubits = 8;
maxPrint = 10;

circuit = qclab.QCircuit( nbQubits ) ;
qftCircuit( circuit );

% Verify unitary
if ( nbQubits <= maxPrint )
  matrix = circuit.matrix 
  norm(matrix - fft(qclab.qId(nbQubits))./2^(nbQubits/2))
end

% QASM
fID = 1;
fprintf( fID, '\n\nQASM output:\n\n' );
fprintf( fID, 'OPENQASM 2.0;\ninclude "qelib1.inc";\n\n');
fprintf( fID, 'qreg q[%d];\n',nbQubits);
circuit.toQASM( fID );

% Draw circuit
fprintf( fID, '\n\nCircuit diagram:\n\n' );
circuit.draw( fID, 'S' );

function qftCircuit( circuit )
  H = @qclab.qgates.Hadamard ;
  CP = @qclab.qgates.CPhase ;
  SWAP = @qclab.qgates.SWAP ;
  
  n = double(circuit.nbQubits) ;
  % B blocks
  for i = 0 : n - 1
    % Hadamard
    circuit.push_back( H( i ) );
    % diagonal blocks
    for j = 2 : n-i
      control = j + i - 1 ;
      theta = -2*pi/2^j ;
      circuit.push_back( CP( control, i, theta ) ) ;
    end
  end
  
  % swaps
  for i = 0 : floor(n/2) - 1
    circuit.push_back( SWAP( i, n - i - 1 ) );
  end
end