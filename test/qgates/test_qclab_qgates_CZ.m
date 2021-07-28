classdef test_qclab_qgates_CZ < matlab.unittest.TestCase
  methods (Test)
    function test_CZ(test)
      cz = qclab.qgates.CZ() ;
      test.verifyEqual( cz.nbQubits, int32(2) );
      test.verifyTrue( cz.fixed );
      test.verifyTrue( cz.controlled ) ;
      test.verifyEqual( cz.control, int32(0) );
      test.verifyEqual( cz.target, int32(1) );
      test.verifyEqual( cz.controlState, int32(1) );
      
      % matrix
      CZ_check = [1, 0, 0, 0;
                    0, 1, 0, 0;
                    0, 0, 1, 0;
                    0, 0, 0, -1];
      test.verifyEqual(cz.matrix, CZ_check );
      
      % qubit
      test.verifyEqual( cz.qubit, int32(0) );
      
      % qubits
      qubits = cz.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      cz.setQubits( qnew );
      test.verifyEqual( table(cz.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(cz.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      cz.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('cz.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'cz q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = cz.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cz.setControlState( 0 );
      [out] = cz.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      cz.setControl(3);
      [out] = cz.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      cz.setControlState(1);
      [out] = cz.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      cz.setControl(0);
      
      % gate
      Z = qclab.qgates.PauliZ ;
      test.verifyTrue( cz.gate == Z );
      test.verifyEqual( cz.gate.matrix, Z.matrix );
      
      % operators == and ~=
      test.verifyTrue( cz ~= Z );
      test.verifyFalse( cz == Z );
      cz2 = qclab.qgates.CZ ;
      test.verifyTrue( cz == cz2 );
      test.verifyFalse( cz ~= cz2 );
      
      % set control, target controlState
      cz.setControl(3);
      cz.setTarget(5);
      test.verifyTrue( cz == cz2 );
      test.verifyFalse( cz ~= cz2 );
      cz.setControl(4);
      cz.setTarget(1);
      test.verifyTrue( cz ~= cz2 );
      test.verifyFalse( cz == cz2 );      
      cz.setTarget(2);
      cz.setControl(1);
      test.verifyTrue( cz == cz2 );
      test.verifyFalse( cz ~= cz2 );      
      cz.setControl(0);
      cz.setTarget(1);
      cz.setControlState(0);
      test.verifyTrue( cz ~= cz2 );
      test.verifyFalse( cz == cz2 );
      
      % ctranspose
      cz = qclab.qgates.CZ() ;
      czp = cz';
      test.verifyEqual( czp.nbQubits, int32(2) );
      test.verifyEqual( czp.control, int32(0) );
      test.verifyEqual( czp.target, int32(1) );
      test.verifyEqual(czp.matrix, cz.matrix' );
    end
    
    function test_CZ_copy(test)
      cz = qclab.qgates.CZ(0, 1 ) ;
      ccz = copy(cz);
      
      test.verifyEqual(cz.qubits, ccz.qubits);
      
      cz.setControl(10);
      test.verifyNotEqual(cz.qubits, ccz.qubits);
      
      ccz.setControl(10);
      test.verifyEqual(cz.qubits, ccz.qubits);
      
      ccz.setTarget(5);
      test.verifyNotEqual(cz.qubits, ccz.qubits);
    end
  end
end