classdef test_qclab_Barrier < matlab.unittest.TestCase
  methods (Test)
    function test_Barrier(test)
      B = qclab.Barrier([0,1]);
      
      test.verifyEqual( B.nbQubits, int32(2) );     % nbQubits
      test.verifyTrue( B.fixed );               % fixed
      test.verifyFalse( B.controlled );         % controlled
      
      % qubit
      test.verifyEqual( B.qubit, int32(0) );

      % visibility
      test.verifyEqual( B.visibility, false );
      
      % qubits
      qubits = B.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      
      % matrix
      test.verifyEqual( B.matrix, [1, 0, 0,0;0,1,0,0;0,0,1,0;0,0, 0, 1]);
      
      % toQASM      
      test.verifyEqual( B.toQASM, -1 );
      
      
      % draw gate
      [out] = B.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = B.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % TeX gate
      [out] = B.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = B.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [2, 1] );
      
      % operators == and ~=
      B2 = qclab.Barrier([0,1]);
      test.verifyTrue( B == B2 );
      test.verifyFalse( B ~= B2 );
      
      % ctranspose
      B = qclab.Barrier([0,1]);
      Bp = B';
      test.verifyEqual( Bp.nbQubits, int32(2) );
      test.verifyEqual(Bp.matrix, B.matrix' );
    end
  end
end