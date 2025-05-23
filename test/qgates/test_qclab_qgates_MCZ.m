classdef test_qclab_qgates_MCZ < matlab.unittest.TestCase
  methods (Test)
    function test_MCZ(test)
      MCZ = @qclab.qgates.MCZ ;
      gate = MCZ([0,1],2) ;
      test.verifyEqual( gate.nbQubits, int64(3) );
      test.verifyTrue( gate.fixed );
      test.verifyTrue( gate.controlled ) ;
      test.verifyEqual( gate.controls, int64([0,1]) );
      test.verifyEqual( gate.targets, int64(2) );
      test.verifyEqual( gate.controlStates, int64([1,1]) );
      
      % matrix
      Toffoli_check = [1, 0, 0, 0, 0, 0, 0, 0;
                       0, 1, 0, 0, 0, 0, 0, 0;
                       0, 0, 1, 0, 0, 0, 0, 0;
                       0, 0, 0, 1, 0, 0, 0, 0;
                       0, 0, 0, 0, 1, 0, 0, 0;
                       0, 0, 0, 0, 0, 1, 0, 0;
                       0, 0, 0, 0, 0, 0, 1, 0;
                       0, 0, 0, 0, 0, 0, 0, -1];
      test.verifyEqual(gate.matrix, Toffoli_check );
      
      gate.setControlStates([0,0]) ;
      Toffoli_check = [1, 0, 0, 0, 0, 0, 0, 0;
                       0, -1, 0, 0, 0, 0, 0, 0;
                       0, 0, 1, 0, 0, 0, 0, 0;
                       0, 0, 0, 1, 0, 0, 0, 0;
                       0, 0, 0, 0, 1, 0, 0, 0;
                       0, 0, 0, 0, 0, 1, 0, 0;
                       0, 0, 0, 0, 0, 0, 1, 0;
                       0, 0, 0, 0, 0, 0, 0, 1];
      test.verifyEqual(gate.matrix, Toffoli_check );
      
      
      gate.setControlStates([0,1]) ;
      Toffoli_check = [1, 0, 0, 0, 0, 0, 0, 0;
                       0, 1, 0, 0, 0, 0, 0, 0;
                       0, 0, 1, 0, 0, 0, 0, 0;
                       0, 0, 0, -1, 0, 0, 0, 0;
                       0, 0, 0, 0, 1, 0, 0, 0;
                       0, 0, 0, 0, 0, 1, 0, 0;
                       0, 0, 0, 0, 0, 0, 1, 0;
                       0, 0, 0, 0, 0, 0, 0, 1];
      test.verifyEqual(gate.matrix, Toffoli_check );
      
      gate.setControlStates([1,0]) ;
      Toffoli_check = [1, 0, 0, 0, 0, 0, 0, 0;
                       0, 1, 0, 0, 0, 0, 0, 0;
                       0, 0, 1, 0, 0, 0, 0, 0;
                       0, 0, 0, 1, 0, 0, 0, 0;
                       0, 0, 0, 0, 1, 0, 0, 0;
                       0, 0, 0, 0, 0, -1, 0, 0;
                       0, 0, 0, 0, 0, 0, 1, 0;
                       0, 0, 0, 0, 0, 0, 0, 1];
      test.verifyEqual(gate.matrix, Toffoli_check );
      
      
      % apply
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1); Z = [1 0; 0 -1];
      
      gate = MCZ([0,2],4,[1,0]);
      mat = qclab.qId(5) ;
      mat = gate.apply('R','N', 5, mat, 0);
      Cup = kron( E1, kron( I1, E0 ) );
      ICup = qclab.qId(log2(size(Cup,1))) - Cup;
      mat_check = kron(Cup, kron(I1, Z)) + ...
                  kron(ICup, kron(I1,I1)) ;
      test.verifyEqual(mat, mat_check );    
      
      gate = MCZ([2,4],0,[0,1]);
      mat = qclab.qId(5) ;
      mat = gate.apply('R','N', 5, mat, 0);
      
      Cdown = kron( E0, kron( I1, E1 ) );
      ICdown = qclab.qId(log2(size(Cdown,1))) - Cdown;
      mat_check = kron(Z, kron(I1, Cdown)) + ...
                  kron(I1, kron(I1, ICdown)) ;
      test.verifyEqual(mat, mat_check );  
      
      gate = MCZ([1,5],3,[0,0]);
      mat = qclab.qId(7) ;
      mat = gate.apply('R','N', 7, mat, 0);
      Cup = kron(I1, kron(E0,I1)) ; 
      ICup = qclab.qId(log2(size(Cup,1))) - Cup;
      
      Cdown = kron(kron(I1,E0),I1) ;
      ICdown = qclab.qId(log2(size(Cdown,1))) - Cdown;

      mat_check = kron(Cup, kron(Z, Cdown)) + ...
                  kron(ICup, kron(I1, Cdown)) + ...
                  kron(Cup, kron(I1, ICdown)) + ...
                  kron(ICup, kron(I1, ICdown)) ;
      test.verifyEqual(mat, mat_check );       
      
      % draw tests
      gate = MCZ([0,2],4,[1,0]);
      gate.draw();
      
      gate = MCZ([0,2,6],4,[1,0,0]);
      gate.draw();
      
      gate = MCZ([2,3,5],1,[0,0,0]);
      gate.draw();
      
      % TeX tests
      gate = MCZ([0,2],4,[1,0]);
      gate.toTex();
      
      gate = MCZ([0,2,6],4,[1,0,0]);
      gate.toTex();
      
      gate = MCZ([2,3,5],1,[0,0,0]);
      gate.toTex();
      
      % unitarity tests
      target = 3 ;
      ctrl = [1,5,6] ;
      gate =  MCZ(ctrl, target, [0,0,0]);
      gatemat = gate.matrix ;
      test.verifyEqual(gatemat'*gatemat, eye(size(gatemat)),'AbsTol', eps);
      
      mat = qclab.qId(7);
      mat = gate.apply('R', 'N', 7, mat);
      test.verifyEqual(mat'*mat, eye(size(mat)),'AbsTol', eps);
    end
  end
end