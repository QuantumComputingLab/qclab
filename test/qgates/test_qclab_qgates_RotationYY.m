classdef test_qclab_qgates_RotationYY < matlab.unittest.TestCase
  methods (Test)
    function test_RotationYY(test)
      Ryy = qclab.qgates.RotationYY() ;
      test.verifyEqual( Ryy.nbQubits, int64(2) );    % nbQubits
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
      test.verifyEqual( qubits(1), int64(0) );
      test.verifyEqual( qubits(2), int64(1) );
      qnew = [5, 3] ;
      Ryy.setQubits( qnew );
      test.verifyEqual( table(Ryy.qubits()).Var1(1), int64(3) );
      test.verifyEqual( table(Ryy.qubits()).Var1(2), int64(5) );
      
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
      
      % draw gate
      Ryy.setQubits([7 6]);
      [out] = Ryy.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Ryy.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Ryy.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % TeX gate
      Ryy.setQubits([7 6]);
      [out] = Ryy.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Ryy.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Ryy.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [2, 1] );
      
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
      
      % equalType
      Rxx = qclab.qgates.RotationXX();
      Rzz = qclab.qgates.RotationZZ();
      test.verifyTrue( Ryy.equalType( Ryy2 ) );
      test.verifyFalse( Ryy.equalType( Rxx ) );
      test.verifyFalse( Ryy.equalType( Rzz ) );
      
      % mtimes
      Ryy2.setQubits(Ryy.qubits);
      Ryy1t2 = Ryy * Ryy2 ;
      Ryy2t1 = Ryy2 * Ryy ;
      test.verifyEqual( Ryy1t2.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyEqual( Ryy2t1.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyTrue( Ryy1t2 == Ryy2t1 );
      test.verifyEqual( Ryy1t2.matrix, Ryy.matrix * Ryy2.matrix, 'AbsTol', eps );
      
      % mrdivide
      Ryy1mr2 = Ryy / Ryy2 ;
      Ryy2mr1 = Ryy2 / Ryy ;
      test.verifyEqual( Ryy1mr2.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Ryy2mr1.theta, 1 -2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Ryy1mr2.matrix, Ryy.matrix / Ryy2.matrix, 'AbsTol', eps );
      test.verifyEqual( Ryy2mr1.matrix, Ryy2.matrix / Ryy.matrix, 'AbsTol', eps );
      
      % mldivide
      Ryy1ml2 = Ryy \ Ryy2 ;
      Ryy2ml1 = Ryy2 \ Ryy ;
      test.verifyEqual( Ryy1ml2.theta, 1 - 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Ryy2ml1.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Ryy1ml2.matrix, Ryy.matrix \ Ryy2.matrix, 'AbsTol', eps );
      test.verifyEqual( Ryy2ml1.matrix, Ryy2.matrix \ Ryy.matrix, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.qgates.RotationYY( [3, 5], cos(-pi/3), sin(-pi/3) );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(Ryy) );
      iRyy = inv(Ryy);
      test.verifyEqual( iRyy.matrix, inv(Ryy.matrix), 'AbsTol', eps );
      
      % ctranspose
      Ryy = qclab.qgates.RotationYY([0,1], pi/3);
      Ryyp = Ryy';
      test.verifyEqual( Ryyp.nbQubits, int64(2) );
      test.verifyEqual(Ryyp.matrix, Ryy.matrix', 'AbsTol', eps );
      
    end

    function test_fuse( test )      
      tol = 10*eps;
      RYY = @qclab.qgates.RotationYY ;
      G1 = RYY() ;
      G1.update( pi/4 );
      G2 = RYY() ;
      G2.update( pi/7 );
      G1c = copy(G1);
      G1.fuse( G2 );
      test.verifyEqual( G1.matrix, G2.matrix * G1c.matrix, 'AbsTol', tol );
      G12 = G1c * G2;
      test.verifyEqual( G1.matrix, G12.matrix , 'AbsTol', tol );
    end
    
    function test_turnover( test )
      tol = 10*eps;
      RYY = @qclab.qgates.RotationYY ;
      RXX = @qclab.qgates.RotationXX ;
      RZZ = @qclab.qgates.RotationZZ ;
      RX = @qclab.qgates.RotationX ;
      RZ = @qclab.qgates.RotationZ ;
      
      Circuit = @qclab.QCircuit ;
      
      % (A) test Vee to Hat: YY - ZZ - YY
      theta1 = 5.33;
      qubits1 = int64([0, 1]);
      G1 = RYY(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int64([1, 2]);
      G2 = RZZ(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RYY(qubits1, theta3 );
      
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
      
      % (B) test Hat to Vee YY - XX - YY
      theta1 = 5.33;
      qubits1 = int64([1, 2]);
      G1 = RYY(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int64([0, 1]);
      G2 = RXX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RYY(qubits1, theta3 );
      
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
      
      % (C) test TFIM turnover: YY - ZI - YY
      theta1 = 5.33;
      qubits1 = int64([0, 1]);
      G1 = RYY(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int64(0);
      G2 = RZ(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RYY(qubits1, theta3 );
      
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
      
      % (D) test TFIM turnover: YY - IX - YY
      theta1 = 5.33;
      qubits1 = int64([0, 1]);
      G1 = RYY(qubits1, theta1 );
      theta2 = -2.21;
      qubits2 = int64(1);
      G2 = RX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RYY(qubits1, theta3 );
      
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