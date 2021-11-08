classdef test_qclab_qgates_CU3 < matlab.unittest.TestCase
  methods (Test)
    function test_CU3(test)
      cu3 = qclab.qgates.CU3() ;
      test.verifyEqual( cu3.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cu3.fixed );                 % fixed
      test.verifyTrue( cu3.controlled );             % controlled
      test.verifyEqual( cu3.control, int32(0) );     % control
      test.verifyEqual( cu3.target, int32(1) );      % target
      test.verifyEqual( cu3.controlState, int32(1)); % controlState
      
      % matrix
      test.verifyEqual(cu3.matrix, eye(4), 'AbsTol', 4*eps );
      
      % qubit
      test.verifyEqual( cu3.qubit, int32(0) );
      
      % qubits
      qubits = cu3.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      cu3.setQubits( qnew );
      test.verifyEqual( table(cu3.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(cu3.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      cu3.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('cu3.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('cu3(%.15f, %.15f, %.15f) q[0], q[1];', ...
         cu3.theta, cu3.phi,cu3.lambda);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = cu3.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cu3.setControlState( 0  );
      [out] = cu3.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      cu3.setControl(3);
      cu3.update( pi/3, pi/5, pi/7 );
      [out] = cu3.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      cu3.setControlState(1);
      [out] = cu3.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      cu3.setControl(0);
      cu3.update( 0, 0, 0 );
      
      % gate
      U3 = qclab.qgates.U3() ;
      test.verifyTrue( cu3.gate == U3 );
      test.verifyEqual( cu3.gate.matrix, U3.matrix );
      
      % operators == and ~=
      test.verifyTrue( cu3 ~= U3 );
      test.verifyFalse( cu3 == U3 );
      cu32 = qclab.qgates.CU3 ;
      test.verifyTrue( cu3 == cu32 );
      test.verifyFalse( cu3 ~= cu32 );
      
      % set control, target controlState
      cu3.setControl(3);
      cu3.setTarget(5);
      test.verifyTrue( cu3 == cu32 );
      test.verifyFalse( cu3 ~= cu32 );
      cu3.setControl(4);
      cu3.setTarget(1);
      test.verifyTrue( cu3 ~= cu32 );
      test.verifyFalse( cu3 == cu32 );      
      cu3.setTarget(2);
      cu3.setControl(1);
      test.verifyTrue( cu3 == cu32 );
      test.verifyFalse( cu3 ~= cu32 );      
      cu3.setControl(0);
      cu3.setTarget(1);
      cu3.setControlState(0);
      test.verifyTrue( cu3 ~= cu32 );
      test.verifyFalse( cu3 == cu32 );
      
      % makeFixed, makeVariable
      cu3.makeFixed() ;
      test.verifyTrue( cu3.fixed );
      cu3.makeVariable() ;
      test.verifyFalse( cu3.fixed );
      
      % TODO: more tests
    end
  end
end