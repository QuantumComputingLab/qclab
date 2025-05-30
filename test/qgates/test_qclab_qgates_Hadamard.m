classdef test_qclab_qgates_Hadamard < matlab.unittest.TestCase
  methods (Test)
    function test_Hadamard(test)
      H = qclab.qgates.Hadamard();
      
      test.verifyEqual( H.nbQubits, int64(1) );     % nbQubits
      test.verifyTrue( H.fixed );               % fixed
      test.verifyFalse( H.controlled );         % controlled
      
      % qubit
      test.verifyEqual( H.qubit, int64(0) );
      H.setQubit( 2 );
      test.verifyEqual( H.qubit, int64(2) );
      
      % qubits
      qubits = H.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(2) );
      qnew = 3 ;
      H.setQubits( qnew );
      test.verifyEqual( H.qubit, int64(3) );
      
      % matrix
      sqrt2 = 1/sqrt(2);
      test.verifyEqual( H.matrix, [sqrt2, sqrt2; sqrt2, -sqrt2]);
      
      % toQASM      
      [T,out] = evalc('H.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'h q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = H.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX gate
      [out] = H.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % operators == and ~=
      H2 = qclab.qgates.Hadamard();
      test.verifyTrue( H == H2 );
      test.verifyFalse( H ~= H2 );
      
      % ctranspose
      H = qclab.qgates.Hadamard();
      Hp = H';
      test.verifyEqual( Hp.nbQubits, int64(1) );
      test.verifyEqual(Hp.matrix, H.matrix' );
    end
  end
end