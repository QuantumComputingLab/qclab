classdef test_qclab_qgates_iSWAP < matlab.unittest.TestCase
  methods (Test)
    function test_iSWAP(test)
      iswap = qclab.qgates.iSWAP();
      test.verifyEqual( iswap.nbQubits, int32(2) );
      test.verifyTrue( iswap.fixed );
      test.verifyFalse( iswap.controlled ) ;
      
      % qubit
      test.verifyEqual( iswap.qubit, int32(0) );
      
      % qubits
      qubits = iswap.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      iswap.setQubits( qnew );
      test.verifyEqual( table(iswap.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(iswap.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      iswap.setQubits( qnew );
      
      % matrix
      iSWAP_check = [1, 0, 0, 0;
                    0, 0, 1i, 0;
                    0, 1i, 0, 0;
                    0, 0, 0, 1];
      test.verifyEqual(iswap.matrix, iSWAP_check );
      
      % toQASM
      [T,out] = evalc('iswap.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'iswap q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = iswap.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      [out] = iswap.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      iswap.setQubits([3,1]);
      [out] = iswap.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      [out] = iswap.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      iswap.setQubits([0,1]);
      
      % operators == and ~=
      iswap2 = qclab.qgates.iSWAP(2, 4) ;
      test.verifyTrue( iswap == iswap2 );
      test.verifyFalse( iswap ~= iswap2 );
      
      % ctranspose
      iswap = qclab.qgates.iSWAP();
      iswapp = iswap';
      test.verifyEqual( iswapp.nbQubits, int32(2) );
      test.verifyEqual(iswapp.matrix, iswap.matrix', 'AbsTol', 10*eps );
    end
    
    function test_iSWAP_apply(test)
      tol = 100 * eps;
      iswap = qclab.qgates.iSWAP(0, 1);
      
      % apply (2 qubits)
      mat2 = qclab.qId(2);
      mat2 = iswap.apply( 'L', 'N', 2, mat2 );
      test.verifyEqual( mat2, iswap.matrix, 'AbsTol', tol );
      
      mat = [1  2  3  4;
             5  6  7  8;
             9  10 11 12;
             13 14 15 16];
           
      mat2 = mat;
      mat2 = iswap.apply( 'L', 'N', 2, mat2 );
      test.verifyEqual( mat2, mat * iswap.matrix, 'AbsTol', tol );
      
      mat2 = mat;
      mat2 = iswap.apply( 'R', 'N', 2, mat2 );
      test.verifyEqual( mat2, iswap.matrix * mat, 'AbsTol', tol );
      
      iswapH = iswap.matrix' ;
      
      mat2 = mat;
      mat2 = iswap.apply( 'L', 'H', 2, mat2 );
      test.verifyEqual( mat2, mat * iswapH, 'AbsTol', tol );
      
      mat2 = mat;
      mat2 = iswap.apply( 'R', 'H', 2, mat2 );
      test.verifyEqual( mat2, iswapH * mat, 'AbsTol', tol );
      
      % apply (3 qubits)
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'L', 'N', 3, mat3 );
      test.verifyEqual( mat3, kron( iswap.matrix, qclab.qId(1) ), 'AbsTol', tol );
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'R', 'N', 3, mat3 );
      test.verifyEqual( mat3, kron( iswap.matrix, qclab.qId(1) ), 'AbsTol', tol );
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'L', 'H', 3, mat3 );
      test.verifyEqual( mat3, kron( iswapH, qclab.qId(1) ), 'AbsTol', tol );
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'R', 'H', 3, mat3 );
      test.verifyEqual( mat3, kron( iswapH, qclab.qId(1) ), 'AbsTol', tol );
      
      iswap.setQubits( [1, 2] );
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'L', 'N', 3, mat3 );
      test.verifyEqual( mat3, kron( qclab.qId(1), iswap.matrix ), 'AbsTol', tol );
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'R', 'N', 3, mat3 );
      test.verifyEqual( mat3, kron( qclab.qId(1), iswap.matrix ), 'AbsTol', tol );
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'L', 'H', 3, mat3 );
      test.verifyEqual( mat3, kron( qclab.qId(1), iswapH ), 'AbsTol', tol );
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'R', 'H', 3, mat3 );
      test.verifyEqual( mat3, kron( qclab.qId(1), iswapH ), 'AbsTol', tol );
      
      % 3 qubits, not nearest neighbor
      iswap.setQubits( [0, 2] );
      check = zeros(8, 8);
      check(1, 1) = 1;
      check(5, 2) = 1i;
      check(3, 3) = 1;
      check(7, 4) = 1i;
      check(2, 5) = 1i;
      check(6, 6) = 1;
      check(4, 7) = 1i;
      check(8, 8) = 1;
      
      mat3 = qclab.qId(3);
      mat3 = iswap.apply( 'L', 'N', 3, mat3 );
      test.verifyEqual( mat3, check, 'AbsTol', tol );
      
    end
  end
end