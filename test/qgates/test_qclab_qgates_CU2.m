classdef test_qclab_qgates_CU2 < matlab.unittest.TestCase
  methods (Test)
    function test_CU2(test)
      cu2 = qclab.qgates.CU2() ;
      test.verifyEqual( cu2.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( cu2.fixed );                 % fixed
      test.verifyTrue( cu2.controlled );             % controlled
      test.verifyEqual( cu2.control, int64(0) );     % control
      test.verifyEqual( cu2.target, int64(1) );      % target
      test.verifyEqual( cu2.controlState, int64(1)); % controlState
      
      % matrix
      mat_check = [1.0000         0         0         0
                        0    1.0000         0         0
                        0         0    0.707106781186547  -0.707106781186547
                        0         0    0.707106781186547   0.707106781186547 ];
      test.verifyEqual(cu2.matrix, mat_check, 'AbsTol', 4*eps );
      
      % qubit
      test.verifyEqual( cu2.qubit, int64(0) );
      
      % qubits
      qubits = cu2.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int64(0) );
      test.verifyEqual( qubits(2), int64(1) );
      qnew = [5, 3] ;
      cu2.setQubits( qnew );
      test.verifyEqual( table(cu2.qubits()).Var1(1), int64(3) );
      test.verifyEqual( table(cu2.qubits()).Var1(2), int64(5) );
      qnew = [0, 1];
      cu2.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('cu2.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('cu2(%.15f, %.15f) q[0], q[1];',cu2.phi,cu2.lambda);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = cu2.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cu2.setControlState( 0  );
      [out] = cu2.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      cu2.setControl(3);
      cu2.update( pi/3, pi/5 );
      [out] = cu2.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      cu2.setControlState(1);
      [out] = cu2.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      cu2.setControl(0);
      cu2.update( 0, 0 );
      
      % TeX
      [out] = cu2.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      cu2.setControlState( 0  );
      [out] = cu2.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      cu2.setControl(3);
      cu2.update( pi/3, pi/5 );
      [out] = cu2.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      cu2.setControlState(1);
      [out] = cu2.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      cu2.setControl(0);
      cu2.update( 0, 0 );
      
      % gate
      U2 = qclab.qgates.U2() ;
      test.verifyTrue( cu2.gate == U2 );
      test.verifyEqual( cu2.gate.matrix, U2.matrix );
      
      % operators == and ~=
      test.verifyTrue( cu2 ~= U2 );
      test.verifyFalse( cu2 == U2 );
      cu22 = qclab.qgates.CU2 ;
      test.verifyTrue( cu2 == cu22 );
      test.verifyFalse( cu2 ~= cu22 );
      
      % set control, target controlState
      cu2.setControl(3);
      cu2.setTarget(5);
      test.verifyTrue( cu2 == cu22 );
      test.verifyFalse( cu2 ~= cu22 );
      cu2.setControl(4);
      cu2.setTarget(1);
      test.verifyTrue( cu2 ~= cu22 );
      test.verifyFalse( cu2 == cu22 );      
      cu2.setTarget(2);
      cu2.setControl(1);
      test.verifyTrue( cu2 == cu22 );
      test.verifyFalse( cu2 ~= cu22 );      
      cu2.setControl(0);
      cu2.setTarget(1);
      cu2.setControlState(0);
      test.verifyTrue( cu2 ~= cu22 );
      test.verifyFalse( cu2 == cu22 );
      
      % makeFixed, makeVariable
      cu2.makeFixed() ;
      test.verifyTrue( cu2.fixed );
      cu2.makeVariable() ;
      test.verifyFalse( cu2.fixed );
      
      % angle, phi, lambda, sin, cos
      angle1 = qclab.QAngle ; angle2 = qclab.QAngle ;
      cu2angles = cu2.angles ;
      test.verifyTrue( cu2angles(1) == angle1 );
      test.verifyTrue( cu2angles(2) == angle2 );
      test.verifyEqual( cu2.phi(), 0 );
      test.verifyEqual( cu2.cosPhi(), 1 );
      test.verifyEqual( cu2.sinPhi(), 0 );
      test.verifyEqual( cu2.lambda(), 0 );
      test.verifyEqual( cu2.cosLambda(), 1 );
      test.verifyEqual( cu2.sinLambda(), 0 );
      
      
      % update(angle)
      angle1.update( pi/4 ); angle2.update( pi/5 );
      cu2.update( angle1, angle2 ) ;
      test.verifyEqual( cu2.phi, pi/4, 'AbsTol', eps );
      test.verifyEqual( cu2.cosPhi, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cu2.sinPhi, sin(pi/4), 'AbsTol', eps);
      test.verifyEqual( cu2.lambda, pi/5, 'AbsTol', eps );
      test.verifyEqual( cu2.cosLambda, cos(pi/5), 'AbsTol', eps);
      test.verifyEqual( cu2.sinLambda, sin(pi/5), 'AbsTol', eps);
      
      % update(values)
      cu2.update( pi, pi/2 );
      test.verifyEqual( cu2.phi, pi, 'AbsTol', eps );
      test.verifyEqual( cu2.cosPhi, -1, 'AbsTol', eps);
      test.verifyEqual( cu2.sinPhi, 0, 'AbsTol', eps);
      test.verifyEqual( cu2.lambda, pi/2, 'AbsTol', eps );
      test.verifyEqual( cu2.cosLambda, 0, 'AbsTol', eps);
      test.verifyEqual( cu2.sinLambda, 1, 'AbsTol', eps);
      
      % update(cos, sin)
      cu2.update( cos(pi/4), sin(pi/4), cos(pi/7), sin(pi/7) );
      test.verifyEqual( cu2.phi, pi/4, 'AbsTol', eps );
      test.verifyEqual( cu2.cosPhi, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cu2.sinPhi, sin(pi/4), 'AbsTol', eps);
      test.verifyEqual( cu2.lambda, pi/7, 'AbsTol', eps );
      test.verifyEqual( cu2.cosLambda, cos(pi/7), 'AbsTol', eps);
      test.verifyEqual( cu2.sinLambda, sin(pi/7), 'AbsTol', eps);
      
      % matrix (non-Id)
      cu2 = qclab.qgates.CU2(0, 1, 1, pi/4, pi/7) ;
      U2 = qclab.qgates.U2( 0, pi/4, pi/7 ) ;
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      mat2 = kron(E0,eye(2)) + kron(E1,U2.matrix);
      test.verifyEqual( cu2.matrix, mat2, 'AbsTol', eps );
      cu2.setControl(2);
      mat2 = kron(eye(2),E0) + kron(U2.matrix,E1);
      test.verifyEqual( cu2.matrix, mat2, 'AbsTol', eps );
      cu2.setControlState(0);
      mat2 = kron(eye(2),E1) + kron(U2.matrix,E0);
      test.verifyEqual( cu2.matrix, mat2, 'AbsTol', eps );
      cu2.setControl(0);
      mat2 = kron(E1,eye(2)) + kron(E0,U2.matrix);
      test.verifyEqual( cu2.matrix, mat2, 'AbsTol', eps );
      
      % ctranspose
      cu2 = qclab.qgates.CU2(1, 2, 0, pi/3, pi/4 ) ;
      cu2p = cu2';
      test.verifyEqual( cu2p.nbQubits, int64(2) );
      test.verifyEqual( cu2p.control, int64(1) );
      test.verifyEqual( cu2p.target, int64(2) );
      test.verifyEqual(cu2p.matrix, cu2.matrix', 'AbsTol', eps );
      
    end
    
    function test_CU2_copy(test)
      cu2 = qclab.qgates.CU2(0, 1, 1, pi/4, pi/3 ) ;
      ccu2 = copy(cu2);
      
      test.verifyEqual(cu2.qubits, ccu2.qubits);
      test.verifyEqual(cu2.phi, ccu2.phi);
      test.verifyEqual(cu2.lambda, ccu2.lambda);
      
      ccu2.update( 1, 1 );
      test.verifyEqual(cu2.qubits, ccu2.qubits);
      test.verifyNotEqual(cu2.phi, ccu2.phi);
      test.verifyNotEqual(cu2.lambda, ccu2.lambda);
      
      cu2.setControl(10);
      test.verifyNotEqual(cu2.qubits, ccu2.qubits);
      test.verifyNotEqual(cu2.phi, ccu2.phi);
      test.verifyNotEqual(cu2.lambda, ccu2.lambda);
    end
  end
end