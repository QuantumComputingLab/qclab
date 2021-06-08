classdef test_qclab_qgates_RotationXX < matlab.unittest.TestCase
  methods (Test)
    function test_RotationXX(test)
      Rxx = qclab.qgates.RotationXX() ;
      test.verifyEqual( Rxx.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( Rxx.fixed );             % fixed
      test.verifyFalse( Rxx.controlled );        % controlled
      test.verifyEqual( Rxx.cos, 1.0 );          % cos
      test.verifyEqual( Rxx.sin, 0.0 );          % sin
      test.verifyEqual( Rxx.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Rxx.matrix, eye(4) );
      
      % qubits
      qubits = Rxx.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      Rxx.setQubits( qnew );
      test.verifyEqual( table(Rxx.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(Rxx.qubits()).Var1(2), int32(5) );
      
      % fixed
      Rxx.makeFixed();
      test.verifyTrue( Rxx.fixed );
      Rxx.makeVariable();
      test.verifyFalse( Rxx.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Rxx.update( new_angle ) ;
      test.verifyEqual( Rxx.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( Rxx.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Rxx.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Rxx.update( pi/2 );
      test.verifyEqual( Rxx.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( Rxx.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Rxx.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      c = cos(pi/4); s = -1i*sin(pi/4);
      mat = [c, 0, 0, s;
             0, c, s, 0;
             0, s, c, 0;
             s, 0, 0, c];
      test.verifyEqual( Rxx.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Rxx.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('rxx(%.15f) q[3], q[5];',Rxx.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      Rxx.setQubits([7 6]);
      [out] = Rxx.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Rxx.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Rxx.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % update(cos, sin)
      Rxx.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Rxx.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rxx.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Rxx.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Rxx2 = qclab.qgates.RotationXX( [0, 1], cos(pi/3), sin(pi/3) );
      test.verifyTrue( Rxx == Rxx2 );
      test.verifyFalse( Rxx ~= Rxx2 );
      Rxx2.update( 1 );
      test.verifyTrue( Rxx ~= Rxx2 );
      test.verifyFalse( Rxx == Rxx2 );
      
      % equalType
      Ryy = qclab.qgates.RotationYY();
      Rzz = qclab.qgates.RotationZZ();
      test.verifyTrue( Rxx.equalType( Rxx2 ) );
      test.verifyFalse( Rxx.equalType( Ryy ) );
      test.verifyFalse( Rxx.equalType( Rzz ) );
      
      % mtimes
      Rxx2.setQubits(Rxx.qubits);
      Rxx1t2 = Rxx * Rxx2 ;
      Rxx2t1 = Rxx2 * Rxx ;
      test.verifyEqual( Rxx1t2.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyEqual( Rxx2t1.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyTrue( Rxx1t2 == Rxx2t1 );
      test.verifyEqual( Rxx1t2.matrix, Rxx.matrix * Rxx2.matrix, 'AbsTol', eps );
      
      % mrdivide
      Rxx1mr2 = Rxx / Rxx2 ;
      Rxx2mr1 = Rxx2 / Rxx ;
      test.verifyEqual( Rxx1mr2.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rxx2mr1.theta, 1 -2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rxx1mr2.matrix, Rxx.matrix / Rxx2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rxx2mr1.matrix, Rxx2.matrix / Rxx.matrix, 'AbsTol', eps );
      
      % mldivide
      Rxx1ml2 = Rxx \ Rxx2 ;
      Rxx2ml1 = Rxx2 \ Rxx ;
      test.verifyEqual( Rxx1ml2.theta, 1 - 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rxx2ml1.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rxx1ml2.matrix, Rxx.matrix \ Rxx2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rxx2ml1.matrix, Rxx2.matrix \ Rxx.matrix, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.qgates.RotationXX( [3, 5], cos(-pi/3), sin(-pi/3) );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(Rxx) );
      iRxx = inv(Rxx);
      test.verifyEqual( iRxx.matrix, inv(Rxx.matrix), 'AbsTol', eps );
    end
    
  end
end