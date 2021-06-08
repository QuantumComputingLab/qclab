classdef test_qclab_qgates_RotationX < matlab.unittest.TestCase
  methods (Test)
    function test_RotationX(test)
      Rx = qclab.qgates.RotationX() ;
      test.verifyEqual( Rx.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( Rx.fixed );             % fixed
      test.verifyFalse( Rx.controlled );        % controlled
      test.verifyEqual( Rx.cos, 1.0 );          % cos
      test.verifyEqual( Rx.sin, 0.0 );          % sin
      test.verifyEqual( Rx.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Rx.matrix, eye(2) );
      
      % qubit
      test.verifyEqual( Rx.qubit, int32(0) );
      Rx.setQubit( 2 ) ;
      test.verifyEqual( Rx.qubit, int32(2) );
      
      % qubits
      qubits = Rx.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) )
      qnew = 3 ;
      Rx.setQubits( qnew );
      test.verifyEqual( Rx.qubit, int32(3) );
      
      % fixed
      Rx.makeFixed();
      test.verifyTrue( Rx.fixed );
      Rx.makeVariable();
      test.verifyFalse( Rx.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Rx.update( new_angle ) ;
      test.verifyEqual( Rx.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( Rx.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Rx.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Rx.update( pi/2 );
      test.verifyEqual( Rx.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( Rx.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Rx.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      mat = [cos(pi/4), -1i*sin(pi/4); -1i*sin(pi/4), cos(pi/4)];
      test.verifyEqual( Rx.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Rx.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('rx(%.15f) q[3];',Rx.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = Rx.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Rx.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Rx.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % update(cos, sin)
      Rx.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Rx.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rx.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Rx.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Rx2 = qclab.qgates.RotationX( 0, cos(pi/3), sin(pi/3) );
      test.verifyTrue( Rx == Rx2 );
      test.verifyFalse( Rx ~= Rx2 );
      Rx2.update( 1 );
      test.verifyTrue( Rx ~= Rx2 );
      test.verifyFalse( Rx == Rx2 );
      
      % equalType
      Ry = qclab.qgates.RotationY();
      Rz = qclab.qgates.RotationZ();
      test.verifyTrue( Rx.equalType( Rx2 ) );
      test.verifyFalse( Rx.equalType( Ry ) );
      test.verifyFalse( Rx.equalType( Rz ) );
      
      % mtimes
      Rx2.setQubit(3);
      Rx1t2 = Rx * Rx2 ;
      Rx2t1 = Rx2 * Rx ;
      test.verifyEqual( Rx1t2.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyEqual( Rx2t1.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyTrue( Rx1t2 == Rx2t1 );
      test.verifyEqual( Rx1t2.matrix, Rx.matrix * Rx2.matrix, 'AbsTol', eps );
      
      % mrdivide
      Rx1mr2 = Rx / Rx2 ;
      Rx2mr1 = Rx2 / Rx ;
      test.verifyEqual( Rx1mr2.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rx2mr1.theta, 1 -2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rx1mr2.matrix, Rx.matrix / Rx2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rx2mr1.matrix, Rx2.matrix / Rx.matrix, 'AbsTol', eps );
      
      % mldivide
      Rx1ml2 = Rx \ Rx2 ;
      Rx2ml1 = Rx2 \ Rx ;
      test.verifyEqual( Rx1ml2.theta, 1 - 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rx2ml1.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rx1ml2.matrix, Rx.matrix \ Rx2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rx2ml1.matrix, Rx2.matrix \ Rx.matrix, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.qgates.RotationX( 0, cos(-pi/3), sin(-pi/3) );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(Rx) );
      iRx = inv(Rx);
      test.verifyEqual( iRx.matrix, inv(Rx.matrix), 'AbsTol', eps );
    end
    
  end
end