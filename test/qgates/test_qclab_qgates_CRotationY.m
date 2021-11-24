classdef test_qclab_qgates_CRotationY < matlab.unittest.TestCase
  methods (Test)
    function test_CRotationY(test)
      croty = qclab.qgates.CRotationY() ;
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(0) );     % control
      test.verifyEqual( croty.target, int32(1) );      % target
      test.verifyEqual( croty.controlState, int32(1)); % controlState
      
      % matrix
      test.verifyEqual(croty.matrix, eye(4) );
      
      % qubit
      test.verifyEqual( croty.qubit, int32(0) );
      
      % qubits
      qubits = croty.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      croty.setQubits( qnew );
      test.verifyEqual( table(croty.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(croty.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      croty.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('croty.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('cry(%.15f) q[0], q[1];',croty.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = croty.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      croty.setControlState( 0  );
      [out] = croty.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      croty.setControl(3);
      croty.update( pi/3 );
      [out] = croty.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      croty.setControlState(1);
      [out] = croty.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      croty.setControl(0);
      croty.update( 0 );
      
      % TeX
      [out] = croty.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      croty.setControlState( 0  );
      [out] = croty.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      croty.setControl(3);
      croty.update( pi/3 );
      [out] = croty.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      croty.setControlState(1);
      [out] = croty.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      croty.setControl(0);
      croty.update( 0 );
      
      % gate
      RY = qclab.qgates.RotationY() ;
      test.verifyTrue( croty.gate == RY );
      test.verifyEqual( croty.gate.matrix, RY.matrix );
      
      % operators == and ~=
      test.verifyTrue( croty ~= RY );
      test.verifyFalse( croty == RY );
      croty2 = qclab.qgates.CRotationY ;
      test.verifyTrue( croty == croty2 );
      test.verifyFalse( croty ~= croty2 );
      
      % set control, target controlState
      croty.setControl(3);
      croty.setTarget(5);
      test.verifyTrue( croty == croty2 );
      test.verifyFalse( croty ~= croty2 );
      croty.setControl(4);
      croty.setTarget(1);
      test.verifyTrue( croty ~= croty2 );
      test.verifyFalse( croty == croty2 );      
      croty.setTarget(2);
      croty.setControl(1);
      test.verifyTrue( croty == croty2 );
      test.verifyFalse( croty ~= croty2 );      
      croty.setControl(0);
      croty.setTarget(1);
      croty.setControlState(0);
      test.verifyTrue( croty ~= croty2 );
      test.verifyFalse( croty == croty2 );
      
      % makeFixed, makeVariable
      croty.makeFixed() ;
      test.verifyTrue( croty.fixed );
      croty.makeVariable() ;
      test.verifyFalse( croty.fixed );
      
      % angle, theta, sin, cos
      angle = qclab.QAngle ;
      test.verifyTrue( croty.angle == angle );
      test.verifyEqual( croty.theta(), 0 );
      test.verifyEqual( croty.cos(), 1 );
      test.verifyEqual( croty.sin(), 0 );
      
      % update(angle)
      angle.update( pi/4 );
      croty.update( angle ) ;
      test.verifyEqual( croty.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(theta)
      croty.update( pi );
      test.verifyEqual( croty.theta, pi, 'AbsTol', eps );
      test.verifyEqual( croty.cos, 0, 'AbsTol', eps);
      test.verifyEqual( croty.sin, 1, 'AbsTol', eps);
      
      % update(cos, sin)
      croty.update( cos(pi/4), sin(pi/4) );
      test.verifyEqual( croty.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix (non-Id)
      croty = qclab.qgates.CRotationY(0, 1, cos(pi/4), sin(pi/4) ) ;
      RY = qclab.qgates.RotationY( 0, cos(pi/4), sin(pi/4) ) ;
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      mat2 = kron(E0,eye(2)) + kron(E1,RY.matrix);
      test.verifyEqual( croty.matrix, mat2, 'AbsTol', eps );
      croty.setControl(2);
      mat2 = kron(eye(2),E0) + kron(RY.matrix,E1);
      test.verifyEqual( croty.matrix, mat2, 'AbsTol', eps );
      croty.setControlState(0);
      mat2 = kron(eye(2),E1) + kron(RY.matrix,E0);
      test.verifyEqual( croty.matrix, mat2, 'AbsTol', eps );
      croty.setControl(0);
      mat2 = kron(E1,eye(2)) + kron(E0,RY.matrix);
      test.verifyEqual( croty.matrix, mat2, 'AbsTol', eps );
      
      % ctranspose
      croty = qclab.qgates.CRotationY(1, 2, pi/3 ) ;
      crotyp = croty';
      test.verifyEqual( crotyp.nbQubits, int32(2) );
      test.verifyEqual( crotyp.control, int32(1) );
      test.verifyEqual( crotyp.target, int32(2) );
      test.verifyEqual(crotyp.matrix, croty.matrix', 'AbsTol', eps );
      
    end
    
    function test_CRotationY_constructors( test )
      
      % angle, default controlState
      theta = pi/4;
      angle = qclab.QAngle( theta/2 );
      croty = qclab.qgates.CRotationY( 1, 3, angle );
      
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(1) );     % control
      test.verifyEqual( croty.target, int32(3) );      % target
      test.verifyEqual( croty.controlState, int32(1));        % controlState
      
      test.verifyEqual( croty.theta, theta, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(theta/2), 'AbsTol', eps);
      
      % angle, custom controlState
      croty = qclab.qgates.CRotationY( 1, 3, angle, 0 );
      
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(1) );     % control
      test.verifyEqual( croty.target, int32(3) );      % target
      test.verifyEqual( croty.controlState, int32(0));        % controlState
      
      test.verifyEqual( croty.theta, theta, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(theta/2), 'AbsTol', eps);
      
      % theta, default controlState
      croty = qclab.qgates.CRotationY( 1, 3, theta );
      
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(1) );     % control
      test.verifyEqual( croty.target, int32(3) );      % target
      test.verifyEqual( croty.controlState, int32(1));        % controlState
      
      test.verifyEqual( croty.theta, theta, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(theta/2), 'AbsTol', eps);
      
      % theta, custom controlState
      croty = qclab.qgates.CRotationY( 1, 3, theta, 0 );
      
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(1) );     % control
      test.verifyEqual( croty.target, int32(3) );      % target
      test.verifyEqual( croty.controlState, int32(0));        % controlState
      
      test.verifyEqual( croty.theta, theta, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(theta/2), 'AbsTol', eps);
      
      % cos, sin, default controlState
      croty = qclab.qgates.CRotationY( 1, 3, cos(theta), sin(theta) );
      
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(1) );     % control
      test.verifyEqual( croty.target, int32(3) );      % target
      test.verifyEqual( croty.controlState, int32(1));        % controlState
      
      test.verifyEqual( croty.theta, 2*theta, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(theta), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(theta), 'AbsTol', eps);
      
      % cos, sin, custom controlState
      croty = qclab.qgates.CRotationY( 1, 3, cos(theta), sin(theta), 0 );
      
      test.verifyEqual( croty.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( croty.fixed );                 % fixed
      test.verifyTrue( croty.controlled );             % controlled
      test.verifyEqual( croty.control, int32(1) );     % control
      test.verifyEqual( croty.target, int32(3) );      % target
      test.verifyEqual( croty.controlState, int32(0));        % controlState
      
      test.verifyEqual( croty.theta, 2*theta, 'AbsTol', eps );
      test.verifyEqual( croty.cos, cos(theta), 'AbsTol', eps);
      test.verifyEqual( croty.sin, sin(theta), 'AbsTol', eps);
      
    end
    
    function test_CRotationY_copy(test)
      croty = qclab.qgates.CRotationY(0, 1, cos(pi/4), sin(pi/4) ) ;
      ccroty = copy(croty);
      
      test.verifyEqual(croty.qubits, ccroty.qubits);
      test.verifyEqual(croty.theta, ccroty.theta);
      
      ccroty.update( 1 );
      test.verifyEqual(croty.qubits, ccroty.qubits);
      test.verifyNotEqual(croty.theta, ccroty.theta);
      
      croty.setControl(10);
      test.verifyNotEqual(croty.qubits, ccroty.qubits);
      test.verifyNotEqual(croty.theta, ccroty.theta);
    end
  end
end