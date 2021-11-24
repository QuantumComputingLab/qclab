classdef test_qclab_qgates_SWAP < matlab.unittest.TestCase
  methods (Test)
    function test_SWAP(test)
      swap = qclab.qgates.SWAP();
      test.verifyEqual( swap.nbQubits, int32(2) );
      test.verifyTrue( swap.fixed );
      test.verifyFalse( swap.controlled ) ;
      
      % qubit
      test.verifyEqual( swap.qubit, int32(0) );
      
      % qubits
      qubits = swap.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      swap.setQubits( qnew );
      test.verifyEqual( table(swap.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(swap.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      swap.setQubits( qnew );
      
      % matrix
      SWAP_check = [1, 0, 0, 0;
                    0, 0, 1, 0;
                    0, 1, 0, 0;
                    0, 0, 0, 1];
      test.verifyEqual(swap.matrix, SWAP_check );
      
      % toQASM
      [T,out] = evalc('swap.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'swap q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = swap.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      [out] = swap.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      swap.setQubits([3,1]);
      [out] = swap.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      [out] = swap.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      swap.setQubits([0,1]);
      
      % TeX gate
      [out] = swap.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      [out] = swap.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      swap.setQubits([3,1]);
      [out] = swap.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      [out] = swap.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      swap.setQubits([0,1]);      
   
      % operators == and ~=
      swap2 = qclab.qgates.SWAP(2, 4) ;
      test.verifyTrue( swap == swap2 );
      test.verifyFalse( swap ~= swap2 );
      
      % ctranspose
      swap = qclab.qgates.SWAP();
      swapp = swap';
      test.verifyEqual( swapp.nbQubits, int32(2) );
      test.verifyEqual(swapp.matrix, swap.matrix' );
      
    end
    
    function test_SWAP_apply(test)
      swap = qclab.qgates.SWAP(0, 1);
      
      % apply (2 qubits)
      mat2 = qclab.qId(2);
      mat2 = swap.apply( 'L', 'N', 2, mat2 );
      test.verifyTrue( isequal( mat2, swap.matrix ) );
      
      mat = [1  2  3  4;
             5  6  7  8;
             9  10 11 12;
             13 14 15 16];
           
      mat2 = mat;
      mat2 = swap.apply( 'L', 'N', 2, mat2 );
      test.verifyTrue( isequal( mat2, mat * swap.matrix ) );
      
      mat2 = mat;
      mat2 = swap.apply( 'R', 'N', 2, mat2 );
      test.verifyTrue( isequal( mat2, swap.matrix * mat ) );
      
      % apply (3 qubits)
      mat3 = qclab.qId(3);
      mat3 = swap.apply( 'L', 'N', 3, mat3 );
      test.verifyTrue( isequal( mat3, kron( swap.matrix, qclab.qId(1) ) ) );
      swap.setQubits( [1, 2] );
      mat3 = qclab.qId(3);
      mat3 = swap.apply( 'L', 'N', 3, mat3 );
      test.verifyTrue( isequal( mat3, kron( qclab.qId(1), swap.matrix ) ) );
      
      % 3 qubits, not nearest neighbor
      swap.setQubits( [0, 2] );
      check = zeros(8, 8);
      check(1, 1) = 1;
      check(5, 2) = 1;
      check(3, 3) = 1;
      check(7, 4) = 1;
      check(2, 5) = 1;
      check(6, 6) = 1;
      check(4, 7) = 1;
      check(8, 8) = 1;
      
      mat3 = qclab.qId(3);
      mat3 = swap.apply( 'L', 'N', 3, mat3 );
      test.verifyTrue( isequal( mat3, check ) );
      
    end
    
  end
end