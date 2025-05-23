classdef test_qclab_qgates_PauliZ < matlab.unittest.TestCase
  methods (Test)
    function test_PauliZ(test)
      Z = qclab.qgates.PauliZ();
      
      test.verifyEqual( Z.nbQubits, int64(1) );     % nbQubits
      test.verifyTrue( Z.fixed );               % fixed
      test.verifyFalse( Z.controlled );         % controlled
      
      % qubit
      test.verifyEqual( Z.qubit, int64(0) );
      Z.setQubit( 2 );
      test.verifyEqual( Z.qubit, int64(2) );
      
      % qubits
      qubits = Z.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(2) );
      qnew = 3 ;
      Z.setQubits( qnew );
      test.verifyEqual( Z.qubit, int64(3) );
      
      % matrix
      test.verifyEqual( Z.matrix, [1, 0; 0 -1]);
      
      % toQASM      
      [T,out] = evalc('Z.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'z q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = Z.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Z.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX gate
      [out] = Z.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Z.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % operators == and ~=
      Z2 = qclab.qgates.PauliZ();
      test.verifyTrue( Z == Z2 );
      test.verifyFalse( Z ~= Z2 );
      
      % ctranspose
      Z = qclab.qgates.PauliZ();
      Zp = Z';
      test.verifyEqual( Zp.nbQubits, int64(1) );
      test.verifyEqual(Zp.matrix, Z.matrix' );
    end
  end
end