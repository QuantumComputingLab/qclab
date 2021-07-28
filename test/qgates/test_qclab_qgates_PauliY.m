classdef test_qclab_qgates_PauliY < matlab.unittest.TestCase
  methods (Test)
    function test_PauliY(test)
      Y = qclab.qgates.PauliY();
      
      test.verifyEqual( Y.nbQubits, int32(1) );     % nbQubits
      test.verifyTrue( Y.fixed );               % fixed
      test.verifyFalse( Y.controlled );         % controlled
      
      % qubit
      test.verifyEqual( Y.qubit, int32(0) );
      Y.setQubit( 2 );
      test.verifyEqual( Y.qubit, int32(2) );
      
      % qubits
      qubits = Y.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) );
      qnew = 3 ;
      Y.setQubits( qnew );
      test.verifyEqual( Y.qubit, int32(3) );
      
      % matrix
      test.verifyEqual( Y.matrix, [0, -1i; 1i 0]);
      
      % toQASM      
      [T,out] = evalc('Y.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'y q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = Y.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Y.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % operators == and ~=
      Y2 = qclab.qgates.PauliY();
      test.verifyTrue( Y == Y2 );
      test.verifyFalse( Y ~= Y2 );
      
      % ctranspose
      Y = qclab.qgates.PauliY();
      Yp = Y';
      test.verifyEqual( Yp.nbQubits, int32(1) );
      test.verifyEqual(Yp.matrix, Y.matrix' );
    end
  end
end