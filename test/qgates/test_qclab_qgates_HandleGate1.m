classdef test_qclab_qgates_HandleGate1 < matlab.unittest.TestCase
  methods (Test)
    function test_HandleGate1(test)
      X = qclab.qgates.PauliX ;
      H = qclab.qgates.HandleGate1( X ) ;
      
      test.verifyEqual( H.nbQubits, int32(1) );     % nbQubits
      test.verifyTrue( H.fixed );               % fixed
      test.verifyFalse( H.controlled );         % controlled
      test.verifyEqual( H.qubit, int32(0) );    % qubit
      test.verifyEqual( H.offset, int32(0) );   % offset
      test.verifySameHandle( H.gateHandle, X )       % handle
      
      % qubits
      qubits = H.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(0) );
      
      % matrix
      test.verifyEqual( H.matrix, X.matrix );
      
      % toQASM
      [T,out] = evalc('H.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'x q[0];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % offset
      H.setOffset( 3 );
      test.verifyEqual( H.qubit, int32(3) );
      test.verifyEqual( H.offset, int32(3) );
      qubits = H.qubits;
      test.verifyEqual( qubits(1), int32(3) );
      [T,~] = evalc('H.toQASM(1)'); % capture output to std::out in T
      QASMstring = 'x q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % handle
      HX = H.gateHandle ;
      HX.setQubit( 3 );
      test.verifyEqual( H.qubit, int32(6) );
      CX = H.gateCopy ;
      CX.setQubit( 1 );
      test.verifyEqual( H.qubit, int32(6) );
      H.setGate(CX);
      test.verifyEqual( H.qubit, int32(4) );
      
      % operators == and ~=
      test.verifyTrue( H == X );
      test.verifyFalse( H ~= X );
      Z = qclab.qgates.PauliZ ;
      test.verifyTrue( H ~= Z );
      test.verifyFalse( H == Z );
      X2 = qclab.qgates.PauliX ;
      HX = qclab.qgates.HandleGate1( X2 ) ;
      HZ = qclab.qgates.HandleGate1( Z ) ;
      test.verifyTrue( H == HX );
      test.verifyFalse( H ~= HX );
      test.verifyTrue( H ~= HZ );
      test.verifyFalse( H == HZ );
    end
  end
end