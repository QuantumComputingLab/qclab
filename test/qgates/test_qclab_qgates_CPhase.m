classdef test_qclab_qgates_CPhase < matlab.unittest.TestCase
  methods (Test)
    function test_CPhase(test)
      cphase = qclab.qgates.CPhase() ;
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(0) );     % control
      test.verifyEqual( cphase.target, int32(1) );      % target
      test.verifyEqual( cphase.controlState, int32(1)); % controlState
      
      % matrix
      test.verifyEqual(cphase.matrix, eye(4) );
      
      % qubit
      test.verifyEqual( cphase.qubit, int32(0) );
      
      % qubits
      qubits = cphase.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      cphase.setQubits( qnew );
      test.verifyEqual( table(cphase.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(cphase.qubits()).Var1(2), int32(5) );
      qnew = [0, 1];
      cphase.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('cphase.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('cp(%.15f) q[0], q[1];',cphase.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = cphase.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cphase.setControlState( 0 ); 
      [out] = cphase.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      cphase.setControl(3);
      cphase.update( pi/3 );
      [out] = cphase.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      cphase.setControlState(1);
      [out] = cphase.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      cphase.setControl(0);
      cphase.update( 0 );
      
      % TeX
      [out] = cphase.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      cphase.setControlState( 0 ); 
      [out] = cphase.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      cphase.setControl(3);
      cphase.update( pi/3 );
      [out] = cphase.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      cphase.setControlState(1);
      [out] = cphase.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      cphase.setControl(0);
      cphase.update( 0 );
      
      % gate
      P = qclab.qgates.Phase() ;
      test.verifyTrue( cphase.gate == P );
      test.verifyEqual( cphase.gate.matrix, P.matrix );
      
      % operators == and ~=
      test.verifyTrue( cphase ~= P );
      test.verifyFalse( cphase == P );
      cphase2 = qclab.qgates.CPhase ;
      test.verifyTrue( cphase == cphase2 );
      test.verifyFalse( cphase ~= cphase2 );
      
      % set control, target controlState
      cphase.setControl(3);
      cphase.setTarget(5);
      test.verifyTrue( cphase == cphase2 );
      test.verifyFalse( cphase ~= cphase2 );
      cphase.setControl(4);
      cphase.setTarget(1);
      test.verifyTrue( cphase ~= cphase2 );
      test.verifyFalse( cphase == cphase2 );      
      cphase.setTarget(2);
      cphase.setControl(1);
      test.verifyTrue( cphase == cphase2 );
      test.verifyFalse( cphase ~= cphase2 );      
      cphase.setControl(0);
      cphase.setTarget(1);
      cphase.setControlState(0);
      test.verifyTrue( cphase ~= cphase2 );
      test.verifyFalse( cphase == cphase2 );
      
      % makeFixed, makeVariable
      cphase.makeFixed() ;
      test.verifyTrue( cphase.fixed );
      cphase.makeVariable() ;
      test.verifyFalse( cphase.fixed );
      
      % angle, theta, sin, cos
      angle = qclab.QAngle ;
      test.verifyTrue( cphase.angle == angle );
      test.verifyEqual( cphase.theta(), 0 );
      test.verifyEqual( cphase.cos(), 1 );
      test.verifyEqual( cphase.sin(), 0 );
      
      % update(angle)
      angle.update( pi/4 );
      cphase.update( angle ) ;
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(theta)
      cphase.update( pi/2 );
      test.verifyEqual( cphase.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/2), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/2), 'AbsTol', eps);
      
      % update(cos, sin)
      cphase.update( cos(pi/4), sin(pi/4) );
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix (non-Id)
      cphase = qclab.qgates.CPhase(0, 1, cos(pi/4), sin(pi/4) ) ;
      P = qclab.qgates.Phase( 0, cos(pi/4), sin(pi/4) ) ;
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      mat2 = kron(E0,eye(2)) + kron(E1,P.matrix);
      test.verifyEqual( cphase.matrix, mat2, 'AbsTol', eps );
      cphase.setControl(2);
      mat2 = kron(eye(2),E0) + kron(P.matrix,E1);
      test.verifyEqual( cphase.matrix, mat2, 'AbsTol', eps );
      cphase.setControlState(0);
      mat2 = kron(eye(2),E1) + kron(P.matrix,E0);
      test.verifyEqual( cphase.matrix, mat2, 'AbsTol', eps );
      cphase.setControl(0);
      mat2 = kron(E1,eye(2)) + kron(E0,P.matrix);
      test.verifyEqual( cphase.matrix, mat2, 'AbsTol', eps );
      
      % ctranspose
      cphase = qclab.qgates.CPhase(1, 2, pi/3 ) ;
      cphasep = cphase';
      test.verifyEqual( cphasep.nbQubits, int32(2) );
      test.verifyEqual( cphasep.control, int32(1) );
      test.verifyEqual( cphasep.target, int32(2) );
      test.verifyEqual(cphasep.matrix, cphase.matrix', 'AbsTol', eps );
      
      
    end
    
    function test_CPhase_constructors( test )
      
      % angle, default controlState
      angle = qclab.QAngle( pi/4 );
      cphase = qclab.qgates.CPhase( 1, 3, angle );
      
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(1) );     % control
      test.verifyEqual( cphase.target, int32(3) );      % target
      test.verifyEqual( cphase.controlState, int32(1));        % controlState
      
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % angle, custom controlState
      cphase = qclab.qgates.CPhase( 1, 3, angle, 0 );
      
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(1) );     % control
      test.verifyEqual( cphase.target, int32(3) );      % target
      test.verifyEqual( cphase.controlState, int32(0));        % controlState
      
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % theta, default controlState
      cphase = qclab.qgates.CPhase( 1, 3, pi/4 );
      
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(1) );     % control
      test.verifyEqual( cphase.target, int32(3) );      % target
      test.verifyEqual( cphase.controlState, int32(1));        % controlState
      
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % theta, custom controlState
      cphase = qclab.qgates.CPhase( 1, 3, pi/4, 0 );
      
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(1) );     % control
      test.verifyEqual( cphase.target, int32(3) );      % target
      test.verifyEqual( cphase.controlState, int32(0));        % controlState
      
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % cos, sin, default controlState
      cphase = qclab.qgates.CPhase( 1, 3, cos(pi/4), sin(pi/4) );
      
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(1) );     % control
      test.verifyEqual( cphase.target, int32(3) );      % target
      test.verifyEqual( cphase.controlState, int32(1));        % controlState
      
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
      
      % cos, sin, custom controlState
      cphase = qclab.qgates.CPhase( 1, 3, cos(pi/4), sin(pi/4), 0 );
      
      test.verifyEqual( cphase.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( cphase.fixed );                 % fixed
      test.verifyTrue( cphase.controlled );             % controlled
      test.verifyEqual( cphase.control, int32(1) );     % control
      test.verifyEqual( cphase.target, int32(3) );      % target
      test.verifyEqual( cphase.controlState, int32(0));        % controlState
      
      test.verifyEqual( cphase.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( cphase.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( cphase.sin, sin(pi/4), 'AbsTol', eps);
    end
    
    function test_CPhase_copy(test)
      cphase = qclab.qgates.CPhase(0, 1, cos(pi/4), sin(pi/4) ) ;
      ccphase = copy(cphase);
      
      test.verifyEqual(cphase.qubits, ccphase.qubits);
      test.verifyEqual(cphase.theta, ccphase.theta);
      
      ccphase.update( 1 );
      test.verifyEqual(cphase.qubits, ccphase.qubits);
      test.verifyNotEqual(cphase.theta, ccphase.theta);
      
      cphase.setControl(10);
      test.verifyNotEqual(cphase.qubits, ccphase.qubits);
      test.verifyNotEqual(cphase.theta, ccphase.theta);
    end
  end
end