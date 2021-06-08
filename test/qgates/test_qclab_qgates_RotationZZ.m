classdef test_qclab_qgates_RotationZZ < matlab.unittest.TestCase
  methods (Test)
    function test_RotationZZ(test)
      Rzz = qclab.qgates.RotationZZ() ;
      test.verifyEqual( Rzz.nbQubits, int32(2) );    % nbQubits
      test.verifyFalse( Rzz.fixed );             % fixed
      test.verifyFalse( Rzz.controlled );        % controlled
      test.verifyEqual( Rzz.cos, 1.0 );          % cos
      test.verifyEqual( Rzz.sin, 0.0 );          % sin
      test.verifyEqual( Rzz.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Rzz.matrix, eye(4) );
      
      % qubits
      qubits = Rzz.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int32(0) );
      test.verifyEqual( qubits(2), int32(1) );
      qnew = [5, 3] ;
      Rzz.setQubits( qnew );
      test.verifyEqual( table(Rzz.qubits()).Var1(1), int32(3) );
      test.verifyEqual( table(Rzz.qubits()).Var1(2), int32(5) );
      
      % fixed
      Rzz.makeFixed();
      test.verifyTrue( Rzz.fixed );
      Rzz.makeVariable();
      test.verifyFalse( Rzz.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Rzz.update( new_angle ) ;
      test.verifyEqual( Rzz.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( Rzz.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Rzz.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Rzz.update( pi/2 );
      test.verifyEqual( Rzz.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( Rzz.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Rzz.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      c = cos(pi/4); s = 1i*sin(pi/4);
      mat = [c-s, 0, 0, 0;
             0, c+s, 0, 0;
             0, 0, c+s, 0;
             0, 0, 0, c-s];
      test.verifyEqual( Rzz.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Rzz.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('rzz(%.15f) q[3], q[5];',Rzz.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      Rzz.setQubits([7 6]);
      [out] = Rzz.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Rzz.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Rzz.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % update(cos, sin)
      Rzz.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Rzz.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rzz.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Rzz.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Rzz2 = qclab.qgates.RotationZZ( [0, 1], cos(pi/3), sin(pi/3) );
      test.verifyTrue( Rzz == Rzz2 );
      test.verifyFalse( Rzz ~= Rzz2 );
      Rzz2.update( 1 );
      test.verifyTrue( Rzz ~= Rzz2 );
      test.verifyFalse( Rzz == Rzz2 );
      
      % equalType
      Ryy = qclab.qgates.RotationYY();
      Rxx = qclab.qgates.RotationXX();
      test.verifyTrue( Rzz.equalType( Rzz2 ) );
      test.verifyFalse( Rzz.equalType( Ryy ) );
      test.verifyFalse( Rzz.equalType( Rxx ) );
      
      % mtimes
      Rzz2.setQubits(Rzz.qubits);
      Rzz1t2 = Rzz * Rzz2 ;
      Rzz2t1 = Rzz2 * Rzz ;
      test.verifyEqual( Rzz1t2.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyEqual( Rzz2t1.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyTrue( Rzz1t2 == Rzz2t1 );
      test.verifyEqual( Rzz1t2.matrix, Rzz.matrix * Rzz2.matrix, 'AbsTol', eps );
      
      % mrdivide
      Rzz1mr2 = Rzz / Rzz2 ;
      Rzz2mr1 = Rzz2 / Rzz ;
      test.verifyEqual( Rzz1mr2.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rzz2mr1.theta, 1 -2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rzz1mr2.matrix, Rzz.matrix / Rzz2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rzz2mr1.matrix, Rzz2.matrix / Rzz.matrix, 'AbsTol', eps );
      
      % mldivide
      Rzz1ml2 = Rzz \ Rzz2 ;
      Rzz2ml1 = Rzz2 \ Rzz ;
      test.verifyEqual( Rzz1ml2.theta, 1 - 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rzz2ml1.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rzz1ml2.matrix, Rzz.matrix \ Rzz2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rzz2ml1.matrix, Rzz2.matrix \ Rzz.matrix, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.qgates.RotationZZ( [3, 5], cos(-pi/3), sin(-pi/3) );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(Rzz) );
      iRzz = inv(Rzz);
      test.verifyEqual( iRzz.matrix, inv(Rzz.matrix), 'AbsTol', eps );
      
    end
    
  end
end