classdef test_qclab_qgates_CRotationZ < matlab.unittest.TestCase
  methods (Test)
    function test_CRotationZ(test)
      crotz = qclab.qgates.CRotationZ() ;
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(0) );     % control
      test.verifyEqual( crotz.target, int64(1) );      % target
      test.verifyEqual( crotz.controlState, int64(1)); % controlState
      
      % matrix
      test.verifyEqual(crotz.matrix, eye(4) );
      
      % qubit
      test.verifyEqual( crotz.qubit, int64(0) );
      
      % qubits
      qubits = crotz.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int64(0) );
      test.verifyEqual( qubits(2), int64(1) );
      qnew = [5, 3] ;
      crotz.setQubits( qnew );
      test.verifyEqual( table(crotz.qubits()).Var1(1), int64(3) );
      test.verifyEqual( table(crotz.qubits()).Var1(2), int64(5) );
      qnew = [0, 1];
      crotz.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('crotz.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('crz(%.15f) q[0], q[1];',crotz.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = crotz.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      crotz.setControlState( 0  );
      [out] = crotz.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      crotz.setControl(3);
      crotz.update( pi/3 );
      [out] = crotz.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      crotz.setControlState(1);
      [out] = crotz.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      crotz.setControl(0);
      crotz.update( 0 );

      % TeX
      [out] = crotz.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      crotz.setControlState( 0  );
      [out] = crotz.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      crotz.setControl(3);
      crotz.update( pi/3 );
      [out] = crotz.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      crotz.setControlState(1);
      [out] = crotz.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      crotz.setControl(0);
      crotz.update( 0 );
      
      % gate
      RZ = qclab.qgates.RotationZ() ;
      test.verifyTrue( crotz.gate == RZ );
      test.verifyEqual( crotz.gate.matrix, RZ.matrix );
      
      % operators == and ~=
      test.verifyTrue( crotz ~= RZ );
      test.verifyFalse( crotz == RZ );
      crotz2 = qclab.qgates.CRotationZ ;
      test.verifyTrue( crotz == crotz2 );
      test.verifyFalse( crotz ~= crotz2 );
      
      % set control, target controlState
      crotz.setControl(3);
      crotz.setTarget(5);
      test.verifyTrue( crotz == crotz2 );
      test.verifyFalse( crotz ~= crotz2 );
      crotz.setControl(4);
      crotz.setTarget(1);
      test.verifyTrue( crotz ~= crotz2 );
      test.verifyFalse( crotz == crotz2 );      
      crotz.setTarget(2);
      crotz.setControl(1);
      test.verifyTrue( crotz == crotz2 );
      test.verifyFalse( crotz ~= crotz2 );      
      crotz.setControl(0);
      crotz.setTarget(1);
      crotz.setControlState(0);
      test.verifyTrue( crotz ~= crotz2 );
      test.verifyFalse( crotz == crotz2 );
      
      % makeFixed, makeVariable
      crotz.makeFixed() ;
      test.verifyTrue( crotz.fixed );
      crotz.makeVariable() ;
      test.verifyFalse( crotz.fixed );
      
      % angle, theta, sin, cos
      angle = qclab.QAngle ;
      test.verifyTrue( crotz.angle == angle );
      test.verifyEqual( crotz.theta(), 0 );
      test.verifyEqual( crotz.cos(), 1 );
      test.verifyEqual( crotz.sin(), 0 );
      
      % update(angle)
      angle.update( pi/4 );
      crotz.update( angle ) ;
      test.verifyEqual( crotz.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(theta)
      crotz.update( pi );
      test.verifyEqual( crotz.theta, pi, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, 0, 'AbsTol', eps);
      test.verifyEqual( crotz.sin, 1, 'AbsTol', eps);
      
      % update(cos, sin)
      crotz.update( cos(pi/4), sin(pi/4) );
      test.verifyEqual( crotz.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix (non-Id)
      crotz = qclab.qgates.CRotationZ(0, 1, cos(pi/4), sin(pi/4) ) ;
      RZ = qclab.qgates.RotationZ( 0, cos(pi/4), sin(pi/4) ) ;
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      mat2 = kron(E0,eye(2)) + kron(E1,RZ.matrix);
      test.verifyEqual( crotz.matrix, mat2, 'AbsTol', eps );
      crotz.setControl(2);
      mat2 = kron(eye(2),E0) + kron(RZ.matrix,E1);
      test.verifyEqual( crotz.matrix, mat2, 'AbsTol', eps );
      crotz.setControlState(0);
      mat2 = kron(eye(2),E1) + kron(RZ.matrix,E0);
      test.verifyEqual( crotz.matrix, mat2, 'AbsTol', eps );
      crotz.setControl(0);
      mat2 = kron(E1,eye(2)) + kron(E0,RZ.matrix);
      test.verifyEqual( crotz.matrix, mat2, 'AbsTol', eps );
      
      % ctranspose
      crotz = qclab.qgates.CRotationZ(1, 2, pi/3 ) ;
      crotzp = crotz';
      test.verifyEqual( crotzp.nbQubits, int64(2) );
      test.verifyEqual( crotzp.control, int64(1) );
      test.verifyEqual( crotzp.target, int64(2) );
      test.verifyEqual(crotzp.matrix, crotz.matrix', 'AbsTol', eps );
      
    end
    
    function test_CRotationZ_constructors( test )
      
      % angle, default controlState
      theta = pi/4;
      angle = qclab.QAngle( theta/2 );
      crotz = qclab.qgates.CRotationZ( 1, 3, angle );
      
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(1) );     % control
      test.verifyEqual( crotz.target, int64(3) );      % target
      test.verifyEqual( crotz.controlState, int64(1));        % controlState
      
      test.verifyEqual( crotz.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(theta/2), 'AbsTol', eps);
      
      % angle, custom controlState
      crotz = qclab.qgates.CRotationZ( 1, 3, angle, 0 );
      
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(1) );     % control
      test.verifyEqual( crotz.target, int64(3) );      % target
      test.verifyEqual( crotz.controlState, int64(0));        % controlState
      
      test.verifyEqual( crotz.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(theta/2), 'AbsTol', eps);
      
      % theta, default controlState
      crotz = qclab.qgates.CRotationZ( 1, 3, theta );
      
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(1) );     % control
      test.verifyEqual( crotz.target, int64(3) );      % target
      test.verifyEqual( crotz.controlState, int64(1));        % controlState
      
      test.verifyEqual( crotz.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(theta/2), 'AbsTol', eps);
      
      % theta, custom controlState
      crotz = qclab.qgates.CRotationZ( 1, 3, theta, 0 );
      
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(1) );     % control
      test.verifyEqual( crotz.target, int64(3) );      % target
      test.verifyEqual( crotz.controlState, int64(0));        % controlState
      
      test.verifyEqual( crotz.theta, theta, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(theta/2), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(theta/2), 'AbsTol', eps);
      
      % cos, sin, default controlState
      crotz = qclab.qgates.CRotationZ( 1, 3, cos(theta), sin(theta) );
      
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(1) );     % control
      test.verifyEqual( crotz.target, int64(3) );      % target
      test.verifyEqual( crotz.controlState, int64(1));        % controlState
      
      test.verifyEqual( crotz.theta, 2*theta, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(theta), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(theta), 'AbsTol', eps);
      
      % cos, sin, custom controlState
      crotz = qclab.qgates.CRotationZ( 1, 3, cos(theta), sin(theta), 0 );
      
      test.verifyEqual( crotz.nbQubits, int64(2) );    % nbQubits
      test.verifyFalse( crotz.fixed );                 % fixed
      test.verifyTrue( crotz.controlled );             % controlled
      test.verifyEqual( crotz.control, int64(1) );     % control
      test.verifyEqual( crotz.target, int64(3) );      % target
      test.verifyEqual( crotz.controlState, int64(0));        % controlState
      
      test.verifyEqual( crotz.theta, 2*theta, 'AbsTol', eps );
      test.verifyEqual( crotz.cos, cos(theta), 'AbsTol', eps);
      test.verifyEqual( crotz.sin, sin(theta), 'AbsTol', eps);
      
    end
    
    function test_CRotationZ_copy(test)
      crotz = qclab.qgates.CRotationZ(0, 1, cos(pi/4), sin(pi/4) ) ;
      ccrotz = copy(crotz);
      
      test.verifyEqual(crotz.qubits, ccrotz.qubits);
      test.verifyEqual(crotz.theta, ccrotz.theta);
      
      ccrotz.update( 1 );
      test.verifyEqual(crotz.qubits, ccrotz.qubits);
      test.verifyNotEqual(crotz.theta, ccrotz.theta);
      
      crotz.setControl(10);
      test.verifyNotEqual(crotz.qubits, ccrotz.qubits);
      test.verifyNotEqual(crotz.theta, ccrotz.theta);
    end
  end
end