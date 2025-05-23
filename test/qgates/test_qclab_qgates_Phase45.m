classdef test_qclab_qgates_Phase45 < matlab.unittest.TestCase
  methods (Test)
    function test_Phase45(test)
      T = qclab.qgates.Phase45() ;
      test.verifyEqual( T.nbQubits, int64(1) );    % nbQubits
      test.verifyTrue( T.fixed );                  % fixed
      test.verifyFalse( T.controlled );            % controlled
      
      % qubit
      test.verifyEqual( T.qubit, int64(0) );
      T.setQubit( 2 );
      test.verifyEqual( T.qubit, int64(2) );
      
      % qubits
      qubits = T.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(2) );
      qnew = 3 ;
      T.setQubits( qnew );
      test.verifyEqual( T.qubit, int64(3) );
      
      % matrix
      sqrt2 = 1/sqrt(2);
      test.verifyEqual( T.matrix, [1, 0; 0 sqrt2 + 1i*sqrt2]);
      
      % toQASM      
      [TT,out] = evalc('T.toQASM(1)'); % capture output to std::out in TT
      test.verifyEqual( out, 0 );
      QASMstring = 't q[3];';
      test.verifyEqual(TT(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = T.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = T.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX gate
      [out] = T.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = T.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % operators == and ~=
      T2 = qclab.qgates.Phase45();
      test.verifyTrue( T == T2 );
      test.verifyFalse( T ~= T2 );
      
      % ctranspose
      T = qclab.qgates.Phase45();
      Tp = T';
      test.verifyEqual( Tp.nbQubits, int64(1) );
      test.verifyEqual(Tp.matrix, T.matrix', 'AbsTol', eps );
    end
  end
end