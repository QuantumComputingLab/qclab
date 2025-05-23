classdef test_qclab_qgates_RotationZ < matlab.unittest.TestCase
  methods (Test)
    function test_RotationZ(test)
      Rz = qclab.qgates.RotationZ() ;
      test.verifyEqual( Rz.nbQubits, int64(1) );    % nbQubits
      test.verifyFalse( Rz.fixed );             % fixed
      test.verifyFalse( Rz.controlled );        % controlled
      test.verifyEqual( Rz.cos, 1.0 );          % cos
      test.verifyEqual( Rz.sin, 0.0 );          % sin
      test.verifyEqual( Rz.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Rz.matrix, eye(2) );
      
      % qubit
      test.verifyEqual( Rz.qubit, int64(0) );
      Rz.setQubit( 2 ) ;
      test.verifyEqual( Rz.qubit, int64(2) );
      
      % qubits
      qubits = Rz.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(2) )
      qnew = 3 ;
      Rz.setQubits( qnew );
      test.verifyEqual( Rz.qubit, int64(3) );
      
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
      
      % draw gate
      [out] = Rz.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Rz.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Rz.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX gate
      [out] = Rz.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Rz.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Rz.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
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
            
      % equalType
      Ry = qclab.qgates.RotationY();
      Rx = qclab.qgates.RotationX();
      test.verifyTrue( Rz.equalType( Rz2 ) );
      test.verifyFalse( Rz.equalType( Ry ) );
      test.verifyFalse( Rz.equalType( Rx ) );
      
      % mtimes
      Rz2.setQubit(3);
      Rz1t2 = Rz * Rz2 ;
      Rz2t1 = Rz2 * Rz ;
      test.verifyEqual( Rz1t2.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyEqual( Rz2t1.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyTrue( Rz1t2 == Rz2t1 );
      test.verifyEqual( Rz1t2.matrix, Rz.matrix * Rz2.matrix, 'AbsTol', eps );
      
      % mrdivide
      Rz1mr2 = Rz / Rz2 ;
      Rz2mr1 = Rz2 / Rz ;
      test.verifyEqual( Rz1mr2.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rz2mr1.theta, 1 -2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rz1mr2.matrix, Rz.matrix / Rz2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rz2mr1.matrix, Rz2.matrix / Rz.matrix, 'AbsTol', eps );
      
      % mldivide
      Rz1ml2 = Rz \ Rz2 ;
      Rz2ml1 = Rz2 \ Rz ;
      test.verifyEqual( Rz1ml2.theta, 1 - 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Rz2ml1.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Rz1ml2.matrix, Rz.matrix \ Rz2.matrix, 'AbsTol', eps );
      test.verifyEqual( Rz2ml1.matrix, Rz2.matrix \ Rz.matrix, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.qgates.RotationZ( 0, cos(-pi/3), sin(-pi/3) );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(Rz) );
      iRz = inv(Rz);
      test.verifyEqual( iRz.matrix, inv(Rz.matrix), 'AbsTol', eps );
      
      % ctranspose
      Rz = qclab.qgates.RotationZ(0, pi/3);
      Rzp = Rz';
      test.verifyEqual( Rzp.nbQubits, int64(1) );
      test.verifyEqual(Rzp.matrix, Rz.matrix', 'AbsTol', eps );
    end

    function test_fuse( test )
      tol = 10*eps;
      RZ = @qclab.qgates.RotationZ ;
      G1 = RZ() ;
      G1.update( pi/4 );
      G2 = RZ() ;
      G2.update( pi/7 );
      G1c = copy(G1);
      G1.fuse( G2 );
      test.verifyEqual( G1.matrix, G2.matrix * G1c.matrix, 'AbsTol', tol );
      G12 = G1c * G2;
      test.verifyEqual( G1.matrix, G12.matrix , 'AbsTol', tol );
    end

    function test_turnover( test )      
      tol = 10*eps;
      RX = @qclab.qgates.RotationX ;
      RY = @qclab.qgates.RotationY ;
      RZ = @qclab.qgates.RotationZ ;
      RYY = @qclab.qgates.RotationYY ;
      RXX = @qclab.qgates.RotationXX ;
      
      Circuit = @qclab.QCircuit ;
      
      % (A) test Z - X - Z to X - Z - X
      theta1 = 5.33;
      qubit = int64(0);
      G1 = RZ(qubit, theta1 );
      theta2 = -2.21;
      G2 = RX(qubit, theta2 );
      theta3 = pi/5;
      G3 = RZ(qubit, theta3 );
      
      C = Circuit(1);
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
      test.verifyEqual( qubitsA, qubit );
      test.verifyTrue( GA.equalType( G2 ) );
      
      qubitsB = GB.qubits;
      test.verifyEqual( qubitsB, qubit );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubit );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (B) test Z - Y - Z to Y - Z - Y
      theta1 = 5.33;
      qubit = int64(0);
      G1 = RZ(qubit, theta1 );
      theta2 = -2.21;
      G2 = RY(qubit, theta2 );
      theta3 = pi/5;
      G3 = RZ(qubit, theta3 );
      
      C = Circuit(1);
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
      test.verifyEqual( qubitsA, qubit );
      test.verifyTrue( GA.equalType( G2 ) );
      
      qubitsB = GB.qubits;
      test.verifyEqual( qubitsB, qubit );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubit );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (C) test ZI - XX - ZI to XX - ZI - XX
      theta1 = 5.33;
      qubit = int64(0);
      G1 = RZ(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int64([0,1]);
      G2 = RXX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZ(qubit, theta3 );
      
      C = Circuit(2);
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
      test.verifyEqual( qubitsB, qubit );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (D) test IZ - XX - IZ to XX - IZ - XX
      theta1 = 5.33;
      qubit = int64(1);
      G1 = RZ(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int64([0,1]);
      G2 = RXX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZ(qubit, theta3 );
      
      C = Circuit(2);
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
      test.verifyEqual( qubitsB, qubit );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (E) test ZI - YY - ZI to YY - ZI - YY
      theta1 = 5.33;
      qubit = int64(0);
      G1 = RZ(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int64([0,1]);
      G2 = RYY(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZ(qubit, theta3 );
      
      C = Circuit(2);
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
      test.verifyEqual( qubitsB, qubit );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;
      
      % (F) test IZ - YY - IZ to YY - IZ - YY
      theta1 = 5.33;
      qubit = int64(1);
      G1 = RZ(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int64([0,1]);
      G2 = RYY(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RZ(qubit, theta3 );
      
      C = Circuit(2);
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
      test.verifyEqual( qubitsB, qubit );
      test.verifyTrue( GB.equalType( G1 ) );
      
      qubitsC = GC.qubits;
      test.verifyEqual( qubitsC, qubits2 );
      test.verifyTrue( GC.equalType( G2 ) );
      
      % check circuit after turnover and compare with before
      test.verifyEqual( C.matrix, Mat, 'AbsTol', tol ) ;

    end
    
  end
end