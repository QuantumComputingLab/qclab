classdef test_qclab_qgates_CY < matlab.unittest.TestCase
  methods (Test)
    function test_CY(test)
      cy = qclab.qgates.CY() ;
      test.verifyEqual( cy.nbQubits, int32(2) );
      test.verifyTrue( cy.fixed );
      test.verifyTrue( cy.controlled ) ;
      test.verifyEqual( cy.control, int32(0) );
      test.verifyEqual( cy.target, int32(1) );
      test.verifyEqual( cy.controlState, int32(1) );
      
      % matrix
      CY_check = [1, 0, 0, 0;
                    0, 1, 0, 0;
                    0, 0, 0, -1i;
                    0, 0, 1i, 0];
      test.verifyEqual(cy.matrix, CY_check );
      
      % qubit
      test.verifyEqual( cy.qubit, int32(0) );
      
      % qubits
      qubits = cy.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      cy.setQubits( qnew );
      test.verifyEqual( table(cy.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(cy.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      cy.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('cy.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'cy q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = cy.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cy.setControlState( 0 );
      [out] = cy.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      cy.setControl(3);
      [out] = cy.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      cy.setControlState(1);
      [out] = cy.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      cy.setControl(0);
      
      % TeX
      [out] = cy.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      cy.setControlState( 0 );
      [out] = cy.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      cy.setControl(3);
      [out] = cy.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      cy.setControlState(1);
      [out] = cy.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      cy.setControl(0);
      
      % gate
      Y = qclab.qgates.PauliY ;
      test.verifyTrue( cy.gate == Y );
      test.verifyEqual( cy.gate.matrix, Y.matrix );
      
      % operators == and ~=
      test.verifyTrue( cy ~= Y );
      test.verifyFalse( cy == Y );
      cy2 = qclab.qgates.CY ;
      test.verifyTrue( cy == cy2 );
      test.verifyFalse( cy ~= cy2 );
      
      % set control, target controlState
      cy.setControl(3);
      cy.setTarget(5);
      test.verifyTrue( cy == cy2 );
      test.verifyFalse( cy ~= cy2 );
      cy.setControl(4);
      cy.setTarget(1);
      test.verifyTrue( cy ~= cy2 );
      test.verifyFalse( cy == cy2 );      
      cy.setTarget(2);
      cy.setControl(1);
      test.verifyTrue( cy == cy2 );
      test.verifyFalse( cy ~= cy2 );      
      cy.setControl(0);
      cy.setTarget(1);
      cy.setControlState(0);
      test.verifyTrue( cy ~= cy2 );
      test.verifyFalse( cy == cy2 );
      
      % ctranspose
      cy = qclab.qgates.CY() ;
      cyp = cy';
      test.verifyEqual( cyp.nbQubits, int32(2) );
      test.verifyEqual( cyp.control, int32(0) );
      test.verifyEqual( cyp.target, int32(1) );
      test.verifyEqual(cyp.matrix, cy.matrix' );
    end
    
    function test_CY_copy(test)
      cy = qclab.qgates.CY(0, 1 ) ;
      ccy = copy(cy);
      
      test.verifyEqual(cy.qubits, ccy.qubits);
      
      cy.setControl(10);
      test.verifyNotEqual(cy.qubits, ccy.qubits);
      
      ccy.setControl(10);
      test.verifyEqual(cy.qubits, ccy.qubits);
      
      ccy.setTarget(5);
      test.verifyNotEqual(cy.qubits, ccy.qubits);
    end
  end
end