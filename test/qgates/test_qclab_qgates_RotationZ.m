classdef test_qclab_qgates_RotationZ < matlab.unittest.TestCase
  methods (Test)
    function test_RotationZ(test)
      Rz = qclab.qgates.RotationZ() ;
      test.verifyEqual( Rz.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( Rz.fixed );             % fixed
      test.verifyFalse( Rz.controlled );        % controlled
      test.verifyEqual( Rz.cos, 1.0 );          % cos
      test.verifyEqual( Rz.sin, 0.0 );          % sin
      test.verifyEqual( Rz.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Rz.matrix, eye(2) );
      
      % qubit
      test.verifyEqual( Rz.qubit, int32(0) );
      Rz.setQubit( 2 ) ;
      test.verifyEqual( Rz.qubit, int32(2) );
      
      % qubits
      qubits = Rz.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) )
      qnew = 3 ;
      Rz.setQubits( qnew );
      test.verifyEqual( Rz.qubit, int32(3) );
      
      % fixed
      Rz.makeFixed();
      test.verifyTrue( Rz.fixed );
      Rz.makeVariable();
      test.verifyFalse( Rz.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Rz.update( new_angle ) ;
      test.verifyEqual( Rz.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( Rz.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Rz.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Rz.update( pi/2 );
      test.verifyEqual( Rz.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( Rz.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Rz.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      mat = [cos(pi/4)-1i*sin(pi/4), 0; 0, cos(pi/4)+1i*sin(pi/4)];
      test.verifyEqual( Rz.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Rz.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('rz(%.15f) q[3];',Rz.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % update(cos, sin)
      Rz.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Rz.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rz.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Rz.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Rz2 = qclab.qgates.RotationZ( 0, cos(pi/3), sin(pi/3) );
      test.verifyTrue( Rz == Rz2 );
      test.verifyFalse( Rz ~= Rz2 );
      Rz2.update( 1 );
      test.verifyTrue( Rz ~= Rz2 );
      test.verifyFalse( Rz == Rz2 );
    end
    
  end
end