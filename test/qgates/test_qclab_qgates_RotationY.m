classdef test_qclab_qgates_RotationY < matlab.unittest.TestCase
  methods (Test)
    function test_RotationY(test)
      Ry = qclab.qgates.RotationY() ;
      test.verifyEqual( Ry.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( Ry.fixed );             % fixed
      test.verifyFalse( Ry.controlled );        % controlled
      test.verifyEqual( Ry.cos, 1.0 );          % cos
      test.verifyEqual( Ry.sin, 0.0 );          % sin
      test.verifyEqual( Ry.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Ry.matrix, eye(2) );
      
      % qubit
      test.verifyEqual( Ry.qubit, int32(0) );
      Ry.setQubit( 2 ) ;
      test.verifyEqual( Ry.qubit, int32(2) );
      
      % qubits
      qubits = Ry.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) )
      qnew = 3 ;
      Ry.setQubits( qnew );
      test.verifyEqual( Ry.qubit, int32(3) );
      
      % fixed
      Ry.makeFixed();
      test.verifyTrue( Ry.fixed );
      Ry.makeVariable();
      test.verifyFalse( Ry.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Ry.update( new_angle ) ;
      test.verifyEqual( Ry.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( Ry.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Ry.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Ry.update( pi/2 );
      test.verifyEqual( Ry.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( Ry.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Ry.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      mat = [cos(pi/4), -sin(pi/4); sin(pi/4), cos(pi/4)];
      test.verifyEqual( Ry.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Ry.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('ry(%.15f) q[3];',Ry.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % update(cos, sin)
      Ry.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Ry.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Ry.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Ry.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Ry2 = qclab.qgates.RotationY( 0, cos(pi/3), sin(pi/3) );
      test.verifyTrue( Ry == Ry2 );
      test.verifyFalse( Ry ~= Ry2 );
      Ry2.update( 1 );
      test.verifyTrue( Ry ~= Ry2 );
      test.verifyFalse( Ry == Ry2 );
    end
    
  end
end