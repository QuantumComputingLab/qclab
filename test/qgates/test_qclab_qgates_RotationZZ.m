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
      
      % ctranspose
      Rzz = qclab.qgates.RotationZZ([0,1], pi/3);
      Rzzp = Rzz';
      test.verifyEqual( Rzzp.nbQubits, int32(2) );
      test.verifyEqual(Rzzp.matrix, Rzz.matrix', 'AbsTol', eps );
      
    end

    function test_fuse( test )
      tol = 10*eps;
      RZZ = @qclab.qgates.RotationZZ ;
      G1 = RZZ() ;
      G1.update( pi/4 );
      G2 = RZZ() ;
      G2.update( pi/7 );
      G1c = copy(G1);
      G1.fuse( G2 );
      test.verifyEqual( G1.matrix, G2.matrix * G1c.matrix, 'AbsTol', tol );
      G12 = G1c * G2;
      test.verifyEqual( G1.matrix, G12.matrix , 'AbsTol', tol );
    end

    function test_turnover( test )
      tol = 10*eps;
      RZZ = @qclab.qgates.RotationZZ ;
      RXX = @qclab.qgates.RotationXX ;
      RYY = @qclab.qgates.RotationYY ;
      RX = @qclab.qgates.RotationX ;
      RY = @qclab.qgates.RotationY ;
      
      Circuit = @qclab.QCircuit ;
      
      % (A) test Vee to Hat: ZZ - YY - ZZ
      theta1 = 5.33;
      qubits1 = int32([0, 1]);
      G1 = RZZ(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int32([1, 2]);
      G2 = RYY(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZZ(qubits1, theta3 );
      
      C = Circuit(3);
      C.push_back( G1 );
      C.push_back( G2 );
      C.push_back( G3 );
      Mat = C.matrix ;
      
      [GA, GB, GC] = turnover( G1, G2, G3 );
      
      C.replace( 1, GA );
      C.replace( 2, GB );
      C.replace( 3, GC );
      
      % check qubits and types after turnover
      qubitsA = GA.qubits;
      test.verifyEqual( qubitsA, qubits2 );
      test.verifyTrue( GA.equalType( G2 ) );
      
      qubitsB = GB.qubits;
      test.verifyEqual( qubitsB, qubits1 );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (B) test Hat to Vee ZZ - XX - ZZ
      theta1 = 5.33;
      qubits1 = int32([1, 2]);
      G1 = RZZ(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int32([0, 1]);
      G2 = RXX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZZ(qubits1, theta3 );
      
      C = Circuit(3);
      C.push_back( G1 );
      C.push_back( G2 );
      C.push_back( G3 );
      Mat = C.matrix ;
      
      [GA, GB, GC] = turnover( G1, G2, G3 );
      
      C.replace( 1, GA );
      C.replace( 2, GB );
      C.replace( 3, GC );
      
      % check qubits and types after turnover
      qubitsA = GA.qubits;
      test.verifyEqual( qubitsA, qubits2 );
      test.verifyTrue( GA.equalType( G2 ) );
      
      qubitsB = GB.qubits;
      test.verifyEqual( qubitsB, qubits1 );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (C) test TFIM turnover: ZZ - YI - ZZ
      theta1 = 5.33;
      qubits1 = int32([0, 1]);
      G1 = RZZ(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int32(0);
      G2 = RY(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZZ(qubits1, theta3 );
      
      C = Circuit(3);
      C.push_back( G1 );
      C.push_back( G2 );
      C.push_back( G3 );
      Mat = C.matrix ;
      
      [GA, GB, GC] = turnover( G1, G2, G3 );
      
      C.replace( 1, GA );
      C.replace( 2, GB );
      C.replace( 3, GC );
      
      % check qubits and types after turnover
      qubitsA = GA.qubits;
      test.verifyEqual( qubitsA, qubits2 );
      test.verifyTrue( GA.equalType( G2 ) );
      
      qubitsB = GB.qubits;
      test.verifyEqual( qubitsB, qubits1 );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (D) test TFIM turnover: ZZ - IX - ZZ
      theta1 = 5.33;
      qubits1 = int32([0, 1]);
      G1 = RZZ(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int32(1);
      G2 = RX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZZ(qubits1, theta3 );
      
      C = Circuit(3);
      C.push_back( G1 );
      C.push_back( G2 );
      C.push_back( G3 );
      Mat = C.matrix ;
      
      [GA, GB, GC] = turnover( G1, G2, G3 );
      
      C.replace( 1, GA );
      C.replace( 2, GB );
      C.replace( 3, GC );
      
      % check qubits and types after turnover
      qubitsA = GA.qubits;
      test.verifyEqual( qubitsA, qubits2 );
      test.verifyTrue( GA.equalType( G2 ) );
      
      qubitsB = GB.qubits;
      test.verifyEqual( qubitsB, qubits1 );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
    end
    
  end
end