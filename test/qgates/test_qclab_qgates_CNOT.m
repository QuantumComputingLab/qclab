classdef test_qclab_qgates_CNOT < matlab.unittest.TestCase
  methods (Test)
    function test_CNOT(test)
      cnot = qclab.qgates.CNOT() ;
      test.verifyEqual( cnot.nbQubits, int32(2) );
      test.verifyTrue( cnot.fixed );
      test.verifyTrue( cnot.controlled ) ;
      test.verifyEqual( cnot.control, int32(0) );
      test.verifyEqual( cnot.target, int32(1) );
      test.verifyEqual( cnot.controlState, int32(1) );
      
      % matrix
      CNOT_check = [1, 0, 0, 0;
                    0, 1, 0, 0;
                    0, 0, 0, 1;
                    0, 0, 1, 0];
      test.verifyEqual(cnot.matrix, CNOT_check );
      
      % qubit
      test.verifyEqual( cnot.qubit, int32(0) );
      
      % qubits
      qubits = cnot.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      cnot.setQubits( qnew );
      test.verifyEqual( table(cnot.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(cnot.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      cnot.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('cnot.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'cx q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw
      [out] = cnot.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cnot.setControlState( 0 );
      [out] = cnot.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      cnot.setControl(3);
      [out] = cnot.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      cnot.setControlState(1);
      [out] = cnot.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      cnot.setControl(0);
      
      % TeX
      [out] = cnot.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      cnot.setControlState( 0 );
      [out] = cnot.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      cnot.setControl(3);
      [out] = cnot.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      cnot.setControlState(1);
      [out] = cnot.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      cnot.setControl(0);
      
      % gate
      X = qclab.qgates.PauliX ;
      test.verifyTrue( cnot.gate == X );
      test.verifyEqual( cnot.gate.matrix, X.matrix );
      
      % operators == and ~=
      test.verifyTrue( cnot ~= X );
      test.verifyFalse( cnot == X );
      cnot2 = qclab.qgates.CNOT ;
      test.verifyTrue( cnot == cnot2 );
      test.verifyFalse( cnot ~= cnot2 );
      
      % set control, target controlState
      cnot.setControl(3);
      cnot.setTarget(5);
      test.verifyTrue( cnot == cnot2 );
      test.verifyFalse( cnot ~= cnot2 );
      cnot.setControl(4);
      cnot.setTarget(1);
      test.verifyTrue( cnot ~= cnot2 );
      test.verifyFalse( cnot == cnot2 );      
      cnot.setTarget(2);
      cnot.setControl(1);
      test.verifyTrue( cnot == cnot2 );
      test.verifyFalse( cnot ~= cnot2 );      
      cnot.setControl(0);
      cnot.setTarget(1);
      cnot.setControlState(0);
      test.verifyTrue( cnot ~= cnot2 );
      test.verifyFalse( cnot == cnot2 );
      
      % ctranspose
       cnot = qclab.qgates.CNOT() ;
       cnotp = cnot';
       test.verifyEqual( cnotp.nbQubits, int32(2) );
       test.verifyEqual( cnotp.control, int32(0) );
       test.verifyEqual( cnotp.target, int32(1) );
       test.verifyEqual(cnotp.matrix, cnot.matrix' );
    end
    
    function test_CNOT_copy(test)
      cnot = qclab.qgates.CNOT(0, 1 ) ;
      ccnot = copy(cnot);
      
      test.verifyEqual(cnot.qubits, ccnot.qubits);
      
      cnot.setControl(10);
      test.verifyNotEqual(cnot.qubits, ccnot.qubits);
      
      ccnot.setControl(10);
      test.verifyEqual(cnot.qubits, ccnot.qubits);
      
      ccnot.setTarget(5);
      test.verifyNotEqual(cnot.qubits, ccnot.qubits);
    end
  end
end