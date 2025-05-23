classdef test_qclab_qgates_U2 < matlab.unittest.TestCase
  methods (Test)
    function test_U2(test)
      u2 = qclab.qgates.U2() ;
      test.verifyEqual( u2.nbQubits, int64(1) );    % nbQubits
      test.verifyFalse( u2.fixed );                 % fixed
      test.verifyFalse( u2.controlled );            % controlled
      test.verifyEqual( u2.cosPhi, 1.0 );           % cos(phi)
      test.verifyEqual( u2.sinPhi, 0.0 );           % sin(phi)
      test.verifyEqual( u2.phi, 0.0 );              % phi
      test.verifyEqual( u2.cosLambda, 1.0 );        % cos(lambda)
      test.verifyEqual( u2.sinLambda, 0.0 );        % sin(lambda)
      test.verifyEqual( u2.lambda, 0.0 );           % lambda
      
      % matrix
      mat1 = [1 -1; 1 1]/sqrt(2);
      test.verifyEqual( u2.matrix, mat1 );
      
      % qubit
      test.verifyEqual( u2.qubit, int64(0) );
      u2.setQubit( 2 ) ;
      test.verifyEqual( u2.qubit, int64(2) );
      
      % qubits
      qubits = u2.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(2) )
      qnew = 3 ;
      u2.setQubits( qnew );
      test.verifyEqual( u2.qubit, int64(3) );
      
      % fixed
      u2.makeFixed();
      test.verifyTrue( u2.fixed );
      u2.makeVariable();
      test.verifyFalse( u2.fixed );
      
      % update(angle_phi, angle_lambda)
      new_angle_phi = qclab.QAngle( 0.5 );
      new_angle_lambda = qclab.QAngle( 1.5 );
      u2.update( new_angle_phi, new_angle_lambda ) ;
      test.verifyEqual( u2.phi, 0.5, 'AbsTol', eps );
      test.verifyEqual( u2.cosPhi, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( u2.sinPhi, sin( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( u2.lambda, 1.5, 'AbsTol', eps );
      test.verifyEqual( u2.cosLambda, cos( 1.5 ), 'AbsTol', eps );
      test.verifyEqual( u2.sinLambda, sin( 1.5 ), 'AbsTol', eps );
      
      % update(phi, lambda)
      u2.update( pi/4, pi/8 );
      test.verifyEqual( u2.phi, pi/4, 'AbsTol', eps );
      test.verifyEqual( u2.cosPhi, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( u2.sinPhi, sin(pi/4), 'AbsTol', eps);
      test.verifyEqual( u2.lambda, pi/8, 'AbsTol', eps );
      test.verifyEqual( u2.cosLambda, cos(pi/8), 'AbsTol', eps);
      test.verifyEqual( u2.sinLambda, sin(pi/8), 'AbsTol', eps);
      
      % matrix
      mat1 = [1, -exp(1i*pi/8); exp(1i*pi/4), exp(1i*(pi/4 + pi/8))]/sqrt(2);
      test.verifyEqual( u2.matrix, mat1, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('u2.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('u2(%.15f, %.15f) q[3];', u2.phi, u2.lambda);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = u2.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = u2.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = u2.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX
      [out] = u2.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = u2.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = u2.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % update(cos_phi, sin_phi, cos_lambda, sin_lambda)
      u2.update( cos(pi/3), sin(pi/3), cos(-pi/7), sin(-pi/7) );
      test.verifyEqual( u2.phi, pi/3, 'AbsTol', eps );
      test.verifyEqual( u2.cosPhi, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( u2.sinPhi, sin(pi/3), 'AbsTol', eps);
      test.verifyEqual( u2.lambda, -pi/7, 'AbsTol', eps );
      test.verifyEqual( u2.cosLambda, cos(-pi/7), 'AbsTol', eps);
      test.verifyEqual( u2.sinLambda, sin(-pi/7), 'AbsTol', eps);
      
      % operators == and ~=
      u22 = qclab.qgates.U2( 0, cos(pi/3), sin(pi/3), cos(-pi/7), sin(-pi/7) );
      test.verifyTrue( u2 == u22 );
      test.verifyFalse( u2 ~= u22 );
      u22.update( 1, 2 );
      test.verifyTrue( u2 ~= u22 );
      test.verifyFalse( u2 == u22 );
      
      % ctranspose
      u2 = qclab.qgates.U2( 0, 1.2, -0.7 ) ;
      u2p = u2';
      test.verifyEqual(u2p.matrix, u2.matrix', 'AbsTol', 10*eps );
      
    end
    
    function test_U2_constructors( test )
      u2 = qclab.qgates.U2( 1, pi/2, pi/3 );
      test.verifyEqual( u2.qubit, int64(1) );       % qubit      
      test.verifyEqual( u2.nbQubits, int64(1) );    % nbQubits
      test.verifyFalse( u2.fixed );                 % fixed
      test.verifyFalse( u2.controlled );            % controlled
      test.verifyEqual( u2.cosPhi, cos(pi/2) );     % cos(phi)
      test.verifyEqual( u2.sinPhi, sin(pi/2) );     % sin(phi)
      test.verifyEqual( u2.phi, pi/2 );             % phi
      test.verifyEqual( u2.cosLambda, cos(pi/3) );  % cos(lambda)
      test.verifyEqual( u2.sinLambda, sin(pi/3) );  % sin(lambda)
      test.verifyEqual( u2.lambda, pi/3 );          % lambda
      
      
      u2 = qclab.qgates.U2( 5, pi/2, pi/3, true );
      test.verifyEqual( u2.qubit, int64(5) );       % qubit      
      test.verifyEqual( u2.nbQubits, int64(1) );    % nbQubits
      test.verifyTrue( u2.fixed );                  % fixed
      test.verifyFalse( u2.controlled );            % controlled
      test.verifyEqual( u2.cosPhi, cos(pi/2) );     % cos(phi)
      test.verifyEqual( u2.sinPhi, sin(pi/2) );     % sin(phi)
      test.verifyEqual( u2.phi, pi/2 );             % phi
      test.verifyEqual( u2.cosLambda, cos(pi/3) );  % cos(lambda)
      test.verifyEqual( u2.sinLambda, sin(pi/3) );  % sin(lambda)
      test.verifyEqual( u2.lambda, pi/3 );          % lambda
      
      u2 = qclab.qgates.U2( 5, cos(pi/4), sin(pi/4), cos(pi/5), sin(pi/5) );
      test.verifyEqual( u2.qubit, int64(5) );       % qubit      
      test.verifyEqual( u2.nbQubits, int64(1) );    % nbQubits
      test.verifyFalse( u2.fixed );                 % fixed
      test.verifyFalse( u2.controlled );            % controlled
      test.verifyEqual( u2.cosPhi, cos(pi/4) );     % cos(phi)
      test.verifyEqual( u2.sinPhi, sin(pi/4) );     % sin(phi)
      test.verifyEqual( u2.phi, pi/4 );             % phi
      test.verifyEqual( u2.cosLambda, cos(pi/5) );  % cos(lambda)
      test.verifyEqual( u2.sinLambda, sin(pi/5) );  % sin(lambda)
      test.verifyEqual( u2.lambda, pi/5 );          % lambda
      
      u2 = qclab.qgates.U2( 5, cos(pi/4), sin(pi/4), cos(pi/5), sin(pi/5), true );
      test.verifyEqual( u2.qubit, int64(5) );       % qubit      
      test.verifyEqual( u2.nbQubits, int64(1) );    % nbQubits
      test.verifyTrue( u2.fixed );                        % fixed
      test.verifyFalse( u2.controlled );            % controlled
      test.verifyEqual( u2.cosPhi, cos(pi/4) );     % cos(phi)
      test.verifyEqual( u2.sinPhi, sin(pi/4) );     % sin(phi)
      test.verifyEqual( u2.phi, pi/4 );             % phi
      test.verifyEqual( u2.cosLambda, cos(pi/5) );  % cos(lambda)
      test.verifyEqual( u2.sinLambda, sin(pi/5) );  % sin(lambda)
      test.verifyEqual( u2.lambda, pi/5 );          % lambda
    end
    
    function test_U2_copy(test)
      u2 = qclab.qgates.U2(0, cos(pi/4), sin(pi/4), cos(pi/5), sin(pi/5) ) ;
      cu2 = copy(u2);
      
      test.verifyEqual(u2.qubit, cu2.qubit);
      test.verifyEqual(u2.phi, cu2.phi);
      test.verifyEqual(u2.lambda, cu2.lambda);
      
      cu2.update( 1, 2 );
      test.verifyEqual(u2.qubit, cu2.qubit);
      test.verifyNotEqual(u2.phi, cu2.phi);
      test.verifyNotEqual(u2.lambda, cu2.lambda);
      
      u2.setQubit(10);
      test.verifyNotEqual(u2.qubit, cu2.qubit);
      test.verifyNotEqual(u2.phi, cu2.phi);
      test.verifyNotEqual(u2.lambda, cu2.lambda);
    end
  end
end