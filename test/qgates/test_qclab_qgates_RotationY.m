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
      
      % draw gate
      [out] = Ry.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Ry.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Ry.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX gate
      [out] = Ry.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Ry.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Ry.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
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
            
      % equalType
      Rx = qclab.qgates.RotationX();
      Rz = qclab.qgates.RotationZ();
      test.verifyTrue( Ry.equalType( Ry2 ) );
      test.verifyFalse( Ry.equalType( Rx ) );
      test.verifyFalse( Ry.equalType( Rz ) );
      
      % mtimes
      Ry2.setQubit(3);
      Ry1t2 = Ry * Ry2 ;
      Ry2t1 = Ry2 * Ry ;
      test.verifyEqual( Ry1t2.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyEqual( Ry2t1.theta, 2*pi/3 + 1, 'AbsTol', eps );
      test.verifyTrue( Ry1t2 == Ry2t1 );
      test.verifyEqual( Ry1t2.matrix, Ry.matrix * Ry2.matrix, 'AbsTol', eps );
      
      % mrdivide
      Ry1mr2 = Ry / Ry2 ;
      Ry2mr1 = Ry2 / Ry ;
      test.verifyEqual( Ry1mr2.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Ry2mr1.theta, 1 -2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Ry1mr2.matrix, Ry.matrix / Ry2.matrix, 'AbsTol', eps );
      test.verifyEqual( Ry2mr1.matrix, Ry2.matrix / Ry.matrix, 'AbsTol', eps );
      
      % mldivide
      Ry1ml2 = Ry \ Ry2 ;
      Ry2ml1 = Ry2 \ Ry ;
      test.verifyEqual( Ry1ml2.theta, 1 - 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( Ry2ml1.theta, 2*pi/3 - 1, 'AbsTol', eps );
      test.verifyEqual( Ry1ml2.matrix, Ry.matrix \ Ry2.matrix, 'AbsTol', eps );
      test.verifyEqual( Ry2ml1.matrix, Ry2.matrix \ Ry.matrix, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.qgates.RotationY( 0, cos(-pi/3), sin(-pi/3) );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(Ry) );
      iRy = inv(Ry);
      test.verifyEqual( iRy.matrix, inv(Ry.matrix), 'AbsTol', eps );
      
      % ctranspose
      Ry = qclab.qgates.RotationY(0, pi/3);
      Ryp = Ry';
      test.verifyEqual( Ryp.nbQubits, int32(1) );
      test.verifyEqual(Ryp.matrix, Ry.matrix', 'AbsTol', eps );
      
    end
    
    function test_fuse( test )
      tol = 10*eps;
      RY = @qclab.qgates.RotationY ;
      G1 = RY() ;
      G1.update( pi/4 );
      G2 = RY() ;
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
      RXX = @qclab.qgates.RotationXX ;
      RZZ = @qclab.qgates.RotationZZ ;
      
      Circuit = @qclab.QCircuit ;
      
      % (A) test Y - Z - Y to Z - Y - Z
      theta1 = 5.33;
      qubit = int32(0);
      G1 = RY(qubit, theta1 );
      theta2 = -2.21;
      G2 = RZ(qubit, theta2 );
      theta3 = pi/5;
      G3 = RY(qubit, theta3 );
      
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
      
      % (B) test Y - X - Y to X - Y - X
      theta1 = 5.33;
      qubit = int32(0);
      G1 = RY(qubit, theta1 );
      theta2 = -2.21;
      G2 = RX(qubit, theta2 );
      theta3 = pi/5;
      G3 = RY(qubit, theta3 );
      
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
      
      % (C) test YI - ZZ - YI to ZZ - YI - ZZ
      theta1 = 5.33;
      qubit = int32(0);
      G1 = RY(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int32([0,1]);
      G2 = RZZ(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RY(qubit, theta3 );
      
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
      
      % (D) test IY - ZZ - IY to ZZ - IY - ZZ
      theta1 = 5.33;
      qubit = int32(1);
      G1 = RY(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int32([0,1]);
      G2 = RZZ(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RY(qubit, theta3 );
      
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
      
      % (E) test YI - XX - YI to XX - YI - XX
      theta1 = 5.33;
      qubit = int32(0);
      G1 = RY(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int32([0,1]);
      G2 = RXX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RY(qubit, theta3 );
      
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
      
      % (F) test IY - XX - IY to XX - IY - XX
      theta1 = 5.33;
      qubit = int32(1);
      G1 = RY(qubit, theta1 );
      theta2 = -2.21;
      qubits2 = int32([0,1]);
      G2 = RXX(qubits2, theta2 );
      theta3 = pi/5;
      G3 = RY(qubit, theta3 );
      
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