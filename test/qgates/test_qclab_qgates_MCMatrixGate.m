classdef test_qclab_qgates_MCMatrixGate < matlab.unittest.TestCase
  methods (Test)
    function test_MCMatrixGate(test)
      MCMatrixGate = @qclab.qgates.MCMatrixGate ;
      unitary = [1, 0, 0, 0; 
                 0, 0, 1, 0;
                 0, 1, 0, 0;
                 0, 0, 0, 1];
      % no varargin
      gate = MCMatrixGate( [0,1], [2,3], unitary ) ;
      test.verifyEqual( gate.nbQubits, int64(4) ) ;
      test.verifyTrue( gate.fixed ) ;
      test.verifyTrue( gate.controlled ) ;
      test.verifyEqual( gate.controls, int64( [0,1]) ) ;
      test.verifyEqual( gate.targets, int64( [2,3]) ) ;
      test.verifyEqual( gate.controlStates, int64( [1,1]) ) ;

      gate.setQubits([2,3,4,5]) ;
      test.verifyEqual( gate.controls, int64( [2,3] ) ) ;
      test.verifyEqual( gate.targets, int64( [4,5] ) ) ;

      % one varargin label
      gate = MCMatrixGate([0,1], [2,3], unitary, 'hi') ;
      test.verifyEqual( gate.nbQubits, int64(4) );
      test.verifyTrue( gate.fixed );
      test.verifyTrue( gate.controlled ) ;
      test.verifyEqual( gate.controls, int64([0,1]) );
      test.verifyEqual( gate.targets, int64([2,3]) );
      test.verifyEqual( gate.controlStates, int64([1,1]) );
      test.verifyEqual( gate.label, ' hi ') ;

      gate.setQubits([5,1,3,4]) ;
      test.verifyEqual( gate.controls, int64( [1,5] ) ) ;
      test.verifyEqual( gate.targets, int64( [3,4] ) ) ;

      % one varargin controlstates
      gate = MCMatrixGate([0,1], [2,3], unitary, [0,0]) ;
      test.verifyEqual( gate.nbQubits, int64(4) );
      test.verifyTrue( gate.fixed );
      test.verifyTrue( gate.controlled ) ;
      test.verifyEqual( gate.controls, int64([0,1]) );
      test.verifyEqual( gate.targets, int64([2,3]) );
      test.verifyEqual( gate.controlStates, int64([0,0]) );
      test.verifyEqual( gate.label, ' U ') ;
      % two varargin controlstates and label
      gate = MCMatrixGate([0,1], [2,3], unitary, 'hi', [1,1]) ;
      test.verifyEqual( gate.nbQubits, int64(4) );
      test.verifyTrue( gate.fixed );
      test.verifyTrue( gate.controlled ) ;
      test.verifyEqual( gate.controls, int64([0,1]) );
      test.verifyEqual( gate.targets, int64([2,3]) );
      test.verifyEqual( gate.controlStates, int64([1,1]) );
      test.verifyEqual( gate.label, ' hi ') ;
      % two varargin controlstates and label
      gate = MCMatrixGate([0,1], [2,3], unitary, [1,1],'hi') ;
      test.verifyEqual( gate.nbQubits, int64(4) );
      test.verifyTrue( gate.fixed );
      test.verifyTrue( gate.controlled ) ;
      test.verifyEqual( gate.controls, int64([0,1]) );
      test.verifyEqual( gate.targets, int64([2,3]) );
      test.verifyEqual( gate.controlStates, int64([1,1]) );
      test.verifyEqual( gate.label, ' hi ') ;

      % matrix
      matrix_check = eye(16);
      matrix_check(14,14) = 0;
      matrix_check(14,15) = 1;
      matrix_check(15,14) = 1;
      matrix_check(15,15) = 0;
      test.verifyEqual(gate.matrix, matrix_check );

      gate.setControlStates([0,0]) ;
      matrix_check = eye(16);
      matrix_check(2,2) = 0;
      matrix_check(2,3) = 1;
      matrix_check(3,2) = 1;
      matrix_check(3,3) = 0;
      test.verifyEqual(gate.matrix, matrix_check );

      gate.setControlStates([0,1]) ;
      matrix_check = eye(16);
      matrix_check(6,6) = 0;
      matrix_check(6,7) = 1;
      matrix_check(7,6) = 1;
      matrix_check(7,7) = 0;
      test.verifyEqual(gate.matrix, matrix_check );

      gate.setControlStates([1,0]) ;
      matrix_check = eye(16);
      matrix_check(10,10) = 0;
      matrix_check(10,11) = 1;
      matrix_check(11,10) = 1;
      matrix_check(11,11) = 0;
      test.verifyEqual(gate.matrix, matrix_check );

      % apply
      % 1 target qubit
      Y = @qclab.qgates.PauliY ;
      MCY = @qclab.qgates.MCY ;
      gate = MCMatrixGate( [1,5,4], 0, Y(0).matrix, [0,0,1] );
      gate_check = MCY( [1,5,4], 0, [0,0,1] );
      test.verifyEqual( gate.matrix, gate_check.matrix );
      mat = qclab.qId(7) ;
      mat1 = gate.apply('R','N', 7, mat, 0);
      mat2 = gate_check.apply('R','N', 7, mat, 0);
      test.verifyEqual( mat1, mat2 );
      vec = eye(2^7,1);
      vec1 = gate.apply('R','N', 7, vec, 0);
      vec2 = gate_check.apply('R','N', 7, vec, 0);
      test.verifyEqual( vec1, vec2 );

      gate.setQubits([2,3,4,5]) ;
      test.verifyEqual( gate.controls, int64( [2,3,4] ) ) ;
      test.verifyEqual( gate.targets, int64( 5 ) ) ;

      Y = @qclab.qgates.PauliY ;
      MCY = @qclab.qgates.MCY ;
      gate = MCMatrixGate( [1,5,4], 3, Y(0).matrix, [0,0,1] );
      gate_check = MCY( [1,5,4], 3, [0,0,1] );
      test.verifyEqual( gate.matrix, gate_check.matrix );
      mat = qclab.qId(7) ;
      mat1 = gate.apply('R','N', 7, mat, 0);
      mat2 = gate_check.apply('R','N', 7, mat, 0);
      test.verifyEqual( mat1, mat2 );
      vec = eye(2^7,1);
      vec1 = gate.apply('R','N', 7, vec, 0);
      vec2 = gate_check.apply('R','N', 7, vec, 0);
      test.verifyEqual( vec1, vec2 );

      Y = @qclab.qgates.PauliY ;
      MCY = @qclab.qgates.MCY ;
      gate = MCMatrixGate( [1,5,4], 6, Y(0).matrix, [0,0,0] );
      gate_check = MCY( [1,5,4], 6, [0,0,0] );
      test.verifyEqual( gate.matrix, gate_check.matrix );
      mat = qclab.qId(7) ;
      mat1 = gate.apply('R','N', 7, mat, 0);
      mat2 = gate_check.apply('R','N', 7, mat, 0);
      test.verifyEqual( mat1, mat2 );
      vec = eye(2^7,1);
      vec1 = gate.apply('R','N', 7, vec, 0);
      vec2 = gate_check.apply('R','N', 7, vec, 0);
      test.verifyEqual( vec1, vec2 );
      
      gate.setQubits([2,3,4,5]) ;
      test.verifyEqual( gate.controls, int64( [2,3,4]) ) ;
      test.verifyEqual( gate.targets, int64(5) ) ;

      % 2 target qubits
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1); 

      gate = MCMatrixGate([0,2],[3,4],unitary,[1,0]);
      mat = qclab.qId(5) ;
      mat = gate.apply('R','N', 5, mat, 0);
      Cup = kron( E1, kron( I1, E0 ) );
      ICup = qclab.qId(log2(size(Cup,1))) - Cup;
      mat_check = kron(Cup, unitary) + ...
                  kron(ICup, kron(I1,I1)) ;
      test.verifyEqual(mat, mat_check );    
      
      gate = MCMatrixGate([3,4],[0,1],unitary,[0,1]);
      mat = qclab.qId(5) ;
      mat = gate.apply('R','N', 5, mat, 0);

      Cdown = kron(E0, E1);
      ICdown = qclab.qId(log2(size(Cdown,1))) - Cdown;
      mat_check = kron(unitary, kron(I1, Cdown)) + ...
                  kron(kron(I1,I1), kron(I1, ICdown)) ;
      test.verifyEqual(mat, mat_check );  

      gate = MCMatrixGate([1,5],[2,3],unitary,[0,0]);
      mat = qclab.qId(7) ;
      mat = gate.apply('R','N', 7, mat, 0);
      Cup = kron(I1, E0) ; 
      ICup = qclab.qId(log2(size(Cup,1))) - Cup;

      Cdown = kron(kron(I1,E0),I1) ;
      ICdown = qclab.qId(log2(size(Cdown,1))) - Cdown;

      mat_check = kron(Cup, kron(unitary, Cdown)) + ...
                  kron(ICup, kron(kron(I1,I1), Cdown)) + ...
                  kron(Cup, kron(kron(I1,I1), ICdown)) + ...
                  kron(ICup, kron(kron(I1,I1), ICdown)) ;
      test.verifyEqual(mat, mat_check );   

      % 3 target qubits
      U1 = [  1,  2        
              3,  4  ];
      U2 = [  0,          1,          0,           0;
             1/sqrt(2),  0,          0,          -1/sqrt(2);
             0,          0,          1,           0;
             1/sqrt(2),  0,          0,           1/sqrt(2) ];
      U3 = kron(U1,U2) ;

      gate = qclab.qgates.MCMatrixGate(0,[1,2,3],U3,0) ;
      gate_check = qclab.qgates.MatrixGate([1,2,3],U3,'test') ;
      vec = eye(2^7,1);
      vec1 = gate.apply('R','N', 7, vec, 0);
      vec2 = gate_check.apply('R','N', 7, vec, 0);
      test.verifyEqual( vec1, vec2 );

      gate.setQubits([2,3,4,5]) ;
      test.verifyEqual( gate.controls, int64(2)) ;
      test.verifyEqual( gate.targets, int64( [3,4,5]) ) ;

      gate = qclab.qgates.MCMatrixGate([0,6],[1,2,3],U3,[0,0]) ;
      gate_check = qclab.qgates.MatrixGate([1,2,3],U3,'test') ;
      vec = eye(2^7,1);
      vec1 = gate.apply('R','N', 7, vec, 0);
      vec2 = gate_check.apply('R','N', 7, vec, 0);
      test.verifyEqual( vec1, vec2 );

      gate.setQubits([3,2,4,5,6]) ;
      test.verifyEqual( gate.controls, int64( [2,3]) ) ;
      test.verifyEqual( gate.targets, int64( [4,5,6]) ) ;

      gate = qclab.qgates.MCMatrixGate([0,6],[1,2,3],U3,[0,1]) ;
      vec = eye(2^7,1);
      vec1 = gate.apply('R','N', 7, vec, 0);
      test.verifyEqual( vec1, vec );

      % draw tests
      gate = MCMatrixGate([0,2],[3,4],unitary,[1,0]);
      gate.draw();

      gate = MCMatrixGate([0,2,6],[3,4],unitary,[1,0,0]);
      gate.draw();

      gate = MCMatrixGate([1,2,5],[3,4],unitary,[0,0,0]);
      gate.draw();

      gate = MCMatrixGate([2,5],[0,1],unitary,[0,0]);
      gate.draw();

      % TeX tests
      gate = MCMatrixGate([0,2],[3,4],unitary,[1,0]);
      gate.toTex();

      gate = MCMatrixGate([0,2,6],[3,4],unitary,[1,0,0]);
      gate.toTex();

      gate = MCMatrixGate([1,2,5],[3,4],unitary,[0,0,0]);
      gate.toTex();

      gate = MCMatrixGate([2,5],[0,1],unitary,[0,0]);
      gate.toTex();

      % unitarity tests
      target = [3,4] ;
      ctrl = [1,5,6] ;
      gate =  MCMatrixGate(ctrl, target, unitary, [0,0,0]);
      gatemat = gate.matrix ;
      test.verifyEqual(gatemat'*gatemat, eye(size(gatemat)),'AbsTol', eps);

      mat = qclab.qId(7);
      mat = gate.apply('R', 'N', 7, mat);
      test.verifyEqual(mat'*mat, eye(size(mat)),'AbsTol', eps);

    end
  end
end