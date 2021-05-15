classdef test_qclab_qgates_HandleGate2 < matlab.unittest.TestCase
  methods (Test)
    function test_HandleGate2(test)
      swap = qclab.qgates.SWAP ;
      H = qclab.qgates.HandleGate2( swap ) ;
      
      test.verifyEqual( H.nbQubits, int32(2) );     % nbQubits
      test.verifyTrue( H.fixed );               % fixed
      test.verifyFalse( H.controlled );         % controlled
      test.verifyEqual( H.qubit, int32(0) );    % qubit
      test.verifyEqual( H.offset, int32(0) );   % offset
      test.verifySameHandle( H.gateHandle, swap )       % handle
      
      % qubits
      qubits = H.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits, int32([0, 1]) );
      
      % matrix
      test.verifyEqual( H.matrix, swap.matrix );
      
      % toQASM
      [T,out] = evalc('H.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'swap q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % offset
      H.setOffset( 3 );
      qubits = H.qubits;
      test.verifyEqual( H.qubit, int32(3) );
      test.verifyEqual( qubits, int32([3, 4]) );
      test.verifyEqual( H.offset, int32(3) );
      [T,~] = evalc('H.toQASM(1)'); % capture output to std::out in T
      QASMstring = 'swap q[3], q[4];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % handle
      Hswap = H.gateHandle ;
      Hswap.setQubits( [7, 3] );
      qubits = H.qubits;
      test.verifyEqual( qubits, int32([6, 10]) );
      CX = H.gateCopy ;
      CX.setQubits( [17, 13] );
      qubits = H.qubits;
      test.verifyEqual( qubits, int32([6, 10]) );
      H.setGate(CX);
      qubits = H.qubits;
      test.verifyEqual( qubits, int32([16, 20]) );
      
      % operators == and ~=
      test.verifyTrue( H == swap );
      test.verifyFalse( H ~= swap );
      cnot = qclab.qgates.CNOT ;
      test.verifyTrue( H ~= cnot );
      test.verifyFalse( H == cnot );
      swap2 = qclab.qgates.SWAP ;
      Hswap = qclab.qgates.HandleGate2( swap2 ) ;
      Hcnot = qclab.qgates.HandleGate2( cnot ) ;
      test.verifyTrue( H == Hswap );
      test.verifyFalse( H ~= Hswap );
      test.verifyTrue( H ~= Hcnot );
      test.verifyFalse( H == Hcnot );
    end
  end
end