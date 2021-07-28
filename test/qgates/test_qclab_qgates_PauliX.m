classdef test_qclab_qgates_PauliX < matlab.unittest.TestCase
  methods (Test)
    function test_PauliX(test)
      X = qclab.qgates.PauliX();
      
      test.verifyEqual( X.nbQubits, int32(1) );     % nbQubits
      test.verifyTrue( X.fixed );               % fixed
      test.verifyFalse( X.controlled );         % controlled
      
      % qubit
      test.verifyEqual( X.qubit, int32(0) );
      X.setQubit( 2 );
      test.verifyEqual( X.qubit, int32(2) );
      
      % qubits
      qubits = X.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) );
      qnew = 3 ;
      X.setQubits( qnew );
      test.verifyEqual( X.qubit, int32(3) );
      
      % matrix
      test.verifyEqual( X.matrix, [0, 1; 1 0]);
      
      % toQASM      
      [T,out] = evalc('X.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'x q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = X.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = X.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      
      % operators == and ~=
      X2 = qclab.qgates.PauliX();
      test.verifyTrue( X == X2 );
      test.verifyFalse( X ~= X2 );
      
      % ctranspose
      X = qclab.qgates.PauliX();
      Xp = X';
      test.verifyEqual( Xp.nbQubits, int32(1) );
      test.verifyEqual(Xp.matrix, X.matrix' );
    end
  end
end