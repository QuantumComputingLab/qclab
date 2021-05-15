classdef test_qclab_qgates_RotationYY < matlab.unittest.TestCase
  methods (Test)
    function test_RotationYY(test)
      Ryy = qclab.qgates.RotationYY() ;
      test.verifyEqual( Ryy.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( Ryy.fixed );             % fixed
      test.verifyFalse( Ryy.controlled );        % controlled
      test.verifyEqual( Ryy.cos, 1.0 );          % cos
      test.verifyEqual( Ryy.sin, 0.0 );          % sin
      test.verifyEqual( Ryy.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Ryy.matrix, eye(4) );
      
      % qubits
      qubits = Ryy.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      Ryy.setQubits( qnew );
      test.verifyEqual( table(Ryy.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(Ryy.qubits()).Var1(2), int32(5) );
      
      % fixed
      Ryy.makeFixed();
      test.verifyTrue( Ryy.fixed );
      Ryy.makeVariable();
      test.verifyFalse( Ryy.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Ryy.update( new_angle ) ;
      test.verifyEqual( Ryy.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( Ryy.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Ryy.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Ryy.update( pi/2 );
      test.verifyEqual( Ryy.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( Ryy.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Ryy.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      c = cos(pi/4); s = 1i*sin(pi/4);
      mat = [c, 0, 0, s;
             0, c, -s, 0;
             0, -s, c, 0;
             s, 0, 0, c];
      test.verifyEqual( Ryy.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Ryy.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('ryy(%.15f) q[3], q[5];',Ryy.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % update(cos, sin)
      Ryy.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Ryy.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Ryy.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Ryy.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Ryy2 = qclab.qgates.RotationYY( [0, 1], cos(pi/3), sin(pi/3) );
      test.verifyTrue( Ryy == Ryy2 );
      test.verifyFalse( Ryy ~= Ryy2 );
      Ryy2.update( 1 );
      test.verifyTrue( Ryy ~= Ryy2 );
      test.verifyFalse( Ryy == Ryy2 );
    end
    
  end
end