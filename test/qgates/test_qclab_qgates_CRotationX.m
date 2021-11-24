classdef test_qclab_qgates_CRotationX < matlab.unittest.TestCase
  methods (Test)
    function test_CRotationX(test)
      crotx = qclab.qgates.CRotationX() ;
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(0) );     % control
      test.verifyEqual( crotx.target, int32(1) );      % target
      test.verifyEqual( crotx.controlState, int32(1)); % controlState
      
      % matrix
      test.verifyEqual(crotx.matrix, eye(4) );
      
      % qubit
      test.verifyEqual( crotx.qubit, int32(0) );
      
      % qubits
      qubits = crotx.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      crotx.setQubits( qnew );
      test.verifyEqual( table(crotx.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(crotx.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      crotx.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('crotx.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('crx(%.15f) q[0], q[1];',crotx.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = crotx.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      crotx.setControlState( 0  );
      [out] = crotx.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      crotx.setControl(3);
      crotx.update( pi/3 );
      [out] = crotx.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      crotx.setControlState(1);
      [out] = crotx.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      crotx.setControl(0);
      crotx.update( 0 );
      
      % TeX
      [out] = crotx.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      crotx.setControlState( 0  );
      [out] = crotx.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      crotx.setControl(3);
      crotx.update( pi/3 );
      [out] = crotx.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      crotx.setControlState(1);
      [out] = crotx.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      crotx.setControl(0);
      crotx.update( 0 );
      
      % gate
      RX = qclab.qgates.RotationX() ;
      test.verifyTrue( crotx.gate == RX );
      test.verifyEqual( crotx.gate.matrix, RX.matrix );
      
      % operators == and ~=
      test.verifyTrue( crotx ~= RX );
      test.verifyFalse( crotx == RX );
      crotx2 = qclab.qgates.CRotationX ;
      test.verifyTrue( crotx == crotx2 );
      test.verifyFalse( crotx ~= crotx2 );
      
      % set control, target controlState
      crotx.setControl(3);
      crotx.setTarget(5);
      test.verifyTrue( crotx == crotx2 );
      test.verifyFalse( crotx ~= crotx2 );
      crotx.setControl(4);
      crotx.setTarget(1);
      test.verifyTrue( crotx ~= crotx2 );
      test.verifyFalse( crotx == crotx2 );      
      crotx.setTarget(2);
      crotx.setControl(1);
      test.verifyTrue( crotx == crotx2 );
      test.verifyFalse( crotx ~= crotx2 );      
      crotx.setControl(0);
      crotx.setTarget(1);
      crotx.setControlState(0);
      test.verifyTrue( crotx ~= crotx2 );
      test.verifyFalse( crotx == crotx2 );
      
      % makeFixed, makeVariable
      crotx.makeFixed() ;
      test.verifyTrue( crotx.fixed );
      crotx.makeVariable() ;
      test.verifyFalse( crotx.fixed );
      
      % angle, theta, sin, cos
      angle = qclab.QAngle ;
      test.verifyTrue( crotx.angle == angle );
      test.verifyEqual( crotx.theta(), 0 );
      test.verifyEqual( crotx.cos(), 1 );
      test.verifyEqual( crotx.sin(), 0 );
      
      % update(angle)
      angle.update( pi/4 );
      crotx.update( angle ) ;
      test.verifyEqual( crotx.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(theta)
      crotx.update( pi );
      test.verifyEqual( crotx.theta, pi, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, 0, 'AbsTol', eps);
      test.verifyEqual( crotx.sin, 1, 'AbsTol', eps);
      
      % update(cos, sin)
      crotx.update( cos(pi/4), sin(pi/4) );
      test.verifyEqual( crotx.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix (non-Id)
      crotx = qclab.qgates.CRotationX(0, 1, cos(pi/4), sin(pi/4) ) ;
      RX = qclab.qgates.RotationX( 0, cos(pi/4), sin(pi/4) ) ;
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      mat2 = kron(E0,eye(2)) + kron(E1,RX.matrix);
      test.verifyEqual( crotx.matrix, mat2, 'AbsTol', eps );
      crotx.setControl(2);
      mat2 = kron(eye(2),E0) + kron(RX.matrix,E1);
      test.verifyEqual( crotx.matrix, mat2, 'AbsTol', eps );
      crotx.setControlState(0);
      mat2 = kron(eye(2),E1) + kron(RX.matrix,E0);
      test.verifyEqual( crotx.matrix, mat2, 'AbsTol', eps );
      crotx.setControl(0);
      mat2 = kron(E1,eye(2)) + kron(E0,RX.matrix);
      test.verifyEqual( crotx.matrix, mat2, 'AbsTol', eps );
      
      % ctranspose
      crotx = qclab.qgates.CRotationX(1, 2, pi/3 ) ;
      crotxp = crotx';
      test.verifyEqual( crotxp.nbQubits, int32(2) );
      test.verifyEqual( crotxp.control, int32(1) );
      test.verifyEqual( crotxp.target, int32(2) );
      test.verifyEqual(crotxp.matrix, crotx.matrix', 'AbsTol', eps );
      
    end
    
    function test_CRotationX_constructors( test )
      
      % angle, default controlState
      theta = pi/4;
      angle = qclab.QAngle( theta/2 );
      crotx = qclab.qgates.CRotationX( 1, 3, angle );
      
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(1) );     % control
      test.verifyEqual( crotx.target, int32(3) );      % target
      test.verifyEqual( crotx.controlState, int32(1));        % controlState
      
      test.verifyEqual( crotx.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(theta/2), 'AbsTol', eps);
      
      % angle, custom controlState
      crotx = qclab.qgates.CRotationX( 1, 3, angle, 0 );
      
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(1) );     % control
      test.verifyEqual( crotx.target, int32(3) );      % target
      test.verifyEqual( crotx.controlState, int32(0));        % controlState
      
      test.verifyEqual( crotx.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(theta/2), 'AbsTol', eps);
      
      % theta, default controlState
      crotx = qclab.qgates.CRotationX( 1, 3, theta );
      
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(1) );     % control
      test.verifyEqual( crotx.target, int32(3) );      % target
      test.verifyEqual( crotx.controlState, int32(1));        % controlState
      
      test.verifyEqual( crotx.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(theta/2), 'AbsTol', eps);
      
      % theta, custom controlState
      crotx = qclab.qgates.CRotationX( 1, 3, theta, 0 );
      
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(1) );     % control
      test.verifyEqual( crotx.target, int32(3) );      % target
      test.verifyEqual( crotx.controlState, int32(0));        % controlState
      
      test.verifyEqual( crotx.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(theta/2), 'AbsTol', eps);
      
      % cos, sin, default controlState
      crotx = qclab.qgates.CRotationX( 1, 3, cos(theta), sin(theta) );
      
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(1) );     % control
      test.verifyEqual( crotx.target, int32(3) );      % target
      test.verifyEqual( crotx.controlState, int32(1));        % controlState
      
      test.verifyEqual( crotx.theta, 2*theta, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(theta), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(theta), 'AbsTol', eps);
      
      % cos, sin, custom controlState
      crotx = qclab.qgates.CRotationX( 1, 3, cos(theta), sin(theta), 0 );
      
      test.verifyEqual( crotx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( crotx.fixed );                 % fixed
      test.verifyTrue( crotx.controlled );             % controlled
      test.verifyEqual( crotx.control, int32(1) );     % control
      test.verifyEqual( crotx.target, int32(3) );      % target
      test.verifyEqual( crotx.controlState, int32(0));        % controlState
      
      test.verifyEqual( crotx.theta, 2*theta, 'AbsTol', eps );
      test.verifyEqual( crotx.cos, cos(theta), 'AbsTol', eps);
      test.verifyEqual( crotx.sin, sin(theta), 'AbsTol', eps);
      
    end
    
    function test_CRotationX_copy(test)
      crotx = qclab.qgates.CRotationX(0, 1, cos(pi/4), sin(pi/4) ) ;
      ccrotx = copy(crotx);
      
      test.verifyEqual(crotx.qubits, ccrotx.qubits);
      test.verifyEqual(crotx.theta, ccrotx.theta);
      
      ccrotx.update( 1 );
      test.verifyEqual(crotx.qubits, ccrotx.qubits);
      test.verifyNotEqual(crotx.theta, ccrotx.theta);
      
      crotx.setControl(10);
      test.verifyNotEqual(crotx.qubits, ccrotx.qubits);
      test.verifyNotEqual(crotx.theta, ccrotx.theta);
    end
    
  end
end