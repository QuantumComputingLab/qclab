classdef test_qclab_qgates_Phase90 < matlab.unittest.TestCase
  methods (Test)
    function test_Phase90(test)
      S = qclab.qgates.Phase90() ;
      test.verifyEqual( S.nbQubits, int32(1) );    % nbQubits
      test.verifyTrue( S.fixed );                  % fixed
      test.verifyFalse( S.controlled );            % controlled
      
      % qubit
      test.verifyEqual( S.qubit, int32(0) );
      S.setQubit( 2 );
      test.verifyEqual( S.qubit, int32(2) );
      
      % qubits
      qubits = S.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) );
      qnew = 3 ;
      S.setQubits( qnew );
      test.verifyEqual( S.qubit, int32(3) );
      
      % matrix
      test.verifyEqual( S.matrix, [1, 0; 0 1i]);
      
      % toQASM      
      [T,out] = evalc('S.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 's q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = S.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = S.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX gate
      [out] = S.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = S.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % operators == and ~=
      S2 = qclab.qgates.Phase90();
      test.verifyTrue( S == S2 );
      test.verifyFalse( S ~= S2 );
      
      % ctranspose
      S = qclab.qgates.Phase90();
      Sp = S';
      test.verifyEqual( Sp.nbQubits, int32(1) );
      test.verifyEqual(Sp.matrix, S.matrix', 'AbsTol', eps );
    end
  end
end