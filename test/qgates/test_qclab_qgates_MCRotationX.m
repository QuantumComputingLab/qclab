classdef test_qclab_qgates_MCRotationX < matlab.unittest.TestCase
  methods (Test)
    function test_MCRotationX(test)
      mcrotx = qclab.qgates.MCRotationX([0,1],2) ;
      test.verifyEqual( mcrotx.nbQubits, int64(3) );    % nbQubits
      test.verifyFalse( mcrotx.fixed );                 % fixed
      test.verifyTrue( mcrotx.controlled );             % controlled
      test.verifyEqual( mcrotx.controls, int64([0,1]) );     % control
      test.verifyEqual( mcrotx.targets, int64(2) );      % target
      test.verifyEqual( mcrotx.controlStates, int64([1,1])); % controlState
      
      % matrix
      test.verifyEqual(mcrotx.matrix, eye(8) );
      
      % qubit
      test.verifyEqual( mcrotx.qubit, int64(0) );
      
      % qubits
      qubits = mcrotx.qubits;
      test.verifyEqual( length(qubits), 3 );
      test.verifyEqual( qubits(1), int64(0) );
      test.verifyEqual( qubits(2), int64(1) );
      test.verifyEqual( qubits(3), int64(2) );
      qnew = [5, 3, 1] ;
      mcrotx.setQubits( qnew );
      test.verifyEqual( table(mcrotx.qubits()).Var1(1), int64(3) );
      test.verifyEqual( table(mcrotx.qubits()).Var1(2), int64(5) );
      test.verifyEqual( table(mcrotx.qubits()).Var1(3), int64(1) );
      qnew = [0, 1, 2];
      mcrotx.setQubits( qnew );
      
      % toQASM
      [T,out] = evalc('mcrotx.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, -1 );
      
      % draw gate
      [out] = mcrotx.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      mcrotx.setControlStates( [0,0]  );
      [out] = mcrotx.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      mcrotx.setControls([3,1]);
      mcrotx.update( pi/3 );
      [out] = mcrotx.draw(1, 'L');
      test.verifyEqual( out, 0 );
      
      mcrotx.setControlStates([1,0]);
      [out] = mcrotx.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [9, 1] );
      
      mcrotx.setControls([0,1]);
      mcrotx.update( 0 );
      
      % TeX
      [out] = mcrotx.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      mcrotx.setControlStates( [0,0]  );
      [out] = mcrotx.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      mcrotx.setControls([3,1]);
      mcrotx.update( pi/3 );
      [out] = mcrotx.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      
      mcrotx.setControlStates([1,0]);
      [out] = mcrotx.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      mcrotx.setControls([0,1]);
      mcrotx.update( 0 );
      
      % gate
      RX = qclab.qgates.RotationX() ;
      test.verifyTrue( mcrotx.gate == RX );
      test.verifyEqual( mcrotx.gate.matrix, RX.matrix );
      
      % operators == and ~=
      test.verifyTrue( mcrotx ~= RX );
      test.verifyFalse( mcrotx == RX );
      mcrotx2 = qclab.qgates.MCRotationX([0,1],2,[1,0]) ;
      test.verifyTrue( mcrotx == mcrotx2 );
      test.verifyFalse( mcrotx ~= mcrotx2 );
      
      % set control, target controlState
      mcrotx.setControls([3,4]);
      mcrotx.setTargets(5);
      test.verifyTrue( mcrotx == mcrotx2 );
      test.verifyFalse( mcrotx ~= mcrotx2 );
      mcrotx.setControls([4,6]);
      mcrotx.setTargets(1);
      test.verifyTrue( mcrotx ~= mcrotx2 );
      test.verifyFalse( mcrotx == mcrotx2 );      
      
      % makeFixed, makeVariable
      mcrotx.makeFixed() ;
      test.verifyTrue( mcrotx.fixed );
      mcrotx.makeVariable() ;
      test.verifyFalse( mcrotx.fixed );
      
      % angle, theta, sin, cos
      angle = qclab.QAngle ;
      test.verifyTrue( mcrotx.angle == angle );
      test.verifyEqual( mcrotx.theta(), 0 );
      test.verifyEqual( mcrotx.cos(), 1 );
      test.verifyEqual( mcrotx.sin(), 0 );
      
      % update(angle)
      angle.update( pi/4 );
      mcrotx.update( angle ) ;
      test.verifyEqual( mcrotx.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( mcrotx.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( mcrotx.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(theta)
      mcrotx.update( pi );
      test.verifyEqual( mcrotx.theta, pi, 'AbsTol', eps );
      test.verifyEqual( mcrotx.cos, 0, 'AbsTol', eps);
      test.verifyEqual( mcrotx.sin, 1, 'AbsTol', eps);
      
      % update(cos, sin)
      mcrotx.update( cos(pi/4), sin(pi/4) );
      test.verifyEqual( mcrotx.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( mcrotx.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( mcrotx.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix (non-Id)
      mcrotx = qclab.qgates.MCRotationX(0, 1, 1, cos(pi/4), sin(pi/4) ) ;
      RX = qclab.qgates.RotationX( 0, cos(pi/4), sin(pi/4) ) ;
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      mat2 = kron(E0,eye(2)) + kron(E1,RX.matrix);
      test.verifyEqual( mcrotx.matrix, mat2, 'AbsTol', eps );
      mcrotx.setControls(2);
      mat2 = kron(eye(2),E0) + kron(RX.matrix,E1);
      test.verifyEqual( mcrotx.matrix, mat2, 'AbsTol', eps );
      mcrotx.setControlStates(0);
      mat2 = kron(eye(2),E1) + kron(RX.matrix,E0);
      test.verifyEqual( mcrotx.matrix, mat2, 'AbsTol', eps );
      mcrotx.setControls(0);
      mat2 = kron(E1,eye(2)) + kron(E0,RX.matrix);
      test.verifyEqual( mcrotx.matrix, mat2, 'AbsTol', eps );
      
      % ctranspose
      mcrotx = qclab.qgates.MCRotationX(1, 2, 1, pi/3 ) ;
      mcrotxp = mcrotx';
      test.verifyEqual( mcrotxp.nbQubits, int64(2) );
      test.verifyEqual( mcrotxp.controls, int64(1) );
      test.verifyEqual( mcrotxp.targets, int64(2) );
      test.verifyEqual(mcrotxp.matrix, mcrotx.matrix', 'AbsTol', eps );
      
    end
    
    
    
    function test_MCRotationX_copy(test)
      mcrotx = qclab.qgates.MCRotationX(0, 1, 1, cos(pi/4), sin(pi/4) ) ;
      cmcrotx = copy(mcrotx);
      
      test.verifyEqual(mcrotx.qubits, cmcrotx.qubits);
      test.verifyEqual(mcrotx.theta, cmcrotx.theta);
      
      cmcrotx.update( 1 );
      test.verifyEqual(mcrotx.qubits, cmcrotx.qubits);
      test.verifyNotEqual(mcrotx.theta, cmcrotx.theta);
      
      mcrotx.setControls(10);
      test.verifyNotEqual(mcrotx.qubits, cmcrotx.qubits);
      test.verifyNotEqual(mcrotx.theta, cmcrotx.theta);
    end
    
  end
end