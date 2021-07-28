classdef test_qclab_qgates_U3 < matlab.unittest.TestCase
  methods (Test)
    function test_U3(test)
      u3 = qclab.qgates.U3() ;
      test.verifyEqual( u3.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( u3.fixed );                 % fixed
      test.verifyFalse( u3.controlled );            % controlled
      test.verifyEqual( u3.cosTheta, 1.0 );         % cos(theta/2)
      test.verifyEqual( u3.sinTheta, 0.0 );         % sin(theta/2)
      test.verifyEqual( u3.theta, 0.0 );            % theta
      test.verifyEqual( u3.cosPhi, 1.0 );           % cos(phi)
      test.verifyEqual( u3.sinPhi, 0.0 );           % sin(phi)
      test.verifyEqual( u3.phi, 0.0 );              % phi
      test.verifyEqual( u3.cosLambda, 1.0 );        % cos(lambda)
      test.verifyEqual( u3.sinLambda, 0.0 );        % sin(lambda)
      test.verifyEqual( u3.lambda, 0.0 );           % lambda
      test.verifyEqual( u3.globalPhase, 1.0);       % global phase
      
      % matrix
      test.verifyEqual( u3.matrix, eye(2) );
      
      % qubit
      test.verifyEqual( u3.qubit, int32(0) );
      u3.setQubit( 2 ) ;
      test.verifyEqual( u3.qubit, int32(2) );
      
      % qubits
      qubits = u3.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) )
      qnew = 3 ;
      u3.setQubits( qnew );
      test.verifyEqual( u3.qubit, int32(3) );
      
      % fixed
      u3.makeFixed();
      test.verifyTrue( u3.fixed );
      u3.makeVariable();
      test.verifyFalse( u3.fixed );
      
      % update(angle_theta, angle_phi, angle_lambda)
      new_angle_theta = qclab.QAngle( 0.15 );
      new_angle_phi = qclab.QAngle( 0.5 );
      new_angle_lambda = qclab.QAngle( 1.5 );
      u3.update( new_angle_theta, new_angle_phi, new_angle_lambda ) ;
      test.verifyEqual( u3.theta, 0.30, 'AbsTol', eps );           
      test.verifyEqual( u3.cosTheta, cos(0.15), 'AbsTol', eps );   
      test.verifyEqual( u3.sinTheta, sin(0.15), 'AbsTol', eps ); 
      test.verifyEqual( u3.phi, 0.5, 'AbsTol', eps );
      test.verifyEqual( u3.cosPhi, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( u3.sinPhi, sin( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( u3.lambda, 1.5, 'AbsTol', eps );
      test.verifyEqual( u3.cosLambda, cos( 1.5 ), 'AbsTol', eps );
      test.verifyEqual( u3.sinLambda, sin( 1.5 ), 'AbsTol', eps );
      
      % update(theta, phi, lambda)
      u3.update( pi/12, pi/4, pi/8 );
      test.verifyEqual( u3.theta, pi/12, 'AbsTol', eps );           
      test.verifyEqual( u3.cosTheta, cos(pi/24), 'AbsTol', eps );   
      test.verifyEqual( u3.sinTheta, sin(pi/24), 'AbsTol', eps ); 
      test.verifyEqual( u3.phi, pi/4, 'AbsTol', eps );
      test.verifyEqual( u3.cosPhi, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( u3.sinPhi, sin(pi/4), 'AbsTol', eps);
      test.verifyEqual( u3.lambda, pi/8, 'AbsTol', eps );
      test.verifyEqual( u3.cosLambda, cos(pi/8), 'AbsTol', eps);
      test.verifyEqual( u3.sinLambda, sin(pi/8), 'AbsTol', eps);
      
      % matrix
      mat1 = zeros(2,2);
      mat1(1,1) = cos(pi/24);
      mat1(1,2) = -exp(1i*pi/8) * sin(pi/24);
      mat1(2,1) = exp(1i*pi/4) * sin(pi/24);
      mat1(2,2) = exp(1i*(pi/4 + pi/8)) * cos(pi/24);
      test.verifyEqual( u3.matrix, mat1, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('u3.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('u3(%.15f, %.15f, %.15f) q[3];', u3.theta, u3.phi, u3.lambda);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = u3.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = u3.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = u3.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % global phase
      test.verifyEqual( u3.globalPhase, 1, 'AbsTol', eps );  
      u3.setGlobalPhase( exp(1i * 8) );
      test.verifyEqual( u3.globalPhase, exp(1i * 8), 'AbsTol', eps );
      mat1 = mat1 * exp(1i * 8);
      test.verifyEqual( u3.matrix, mat1, 'AbsTol', eps);
      
      % update(cos_theta, sin_theta, cos_phi, sin_phi, cos_lambda, sin_lambda)
      u3.update( cos(pi/5), sin(pi/5), cos(pi/3), sin(pi/3), cos(-pi/7), sin(-pi/7) );
      test.verifyEqual( u3.theta, 2*pi/5, 'AbsTol', eps );
      test.verifyEqual( u3.cosTheta, cos(pi/5), 'AbsTol', eps );   
      test.verifyEqual( u3.sinTheta, sin(pi/5), 'AbsTol', eps ); 
      test.verifyEqual( u3.phi, pi/3, 'AbsTol', eps );
      test.verifyEqual( u3.cosPhi, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( u3.sinPhi, sin(pi/3), 'AbsTol', eps);
      test.verifyEqual( u3.lambda, -pi/7, 'AbsTol', eps );
      test.verifyEqual( u3.cosLambda, cos(-pi/7), 'AbsTol', eps);
      test.verifyEqual( u3.sinLambda, sin(-pi/7), 'AbsTol', eps);
      
      % operators == and ~=
      u32 = qclab.qgates.U3( 0, cos(pi/5), sin(pi/5), cos(pi/3), sin(pi/3), cos(-pi/7), sin(-pi/7) );
      test.verifyTrue( u3 == u32 );
      test.verifyFalse( u3 ~= u32 );
      u32.update( 1, 2, 3 );
      test.verifyTrue( u3 ~= u32 );
      test.verifyFalse( u3 == u32 );
      
      % ctranspose
      u3 = qclab.qgates.U3( 0, 1.2, -0.7, 2.83 ) ;
      u3.setGlobalPhase( exp(1i/7) );
      u3p = u3';
      test.verifyEqual(u3p.matrix, u3.matrix', 'AbsTol', 10*eps );
      
    end
    
    function test_U3_constructors( test )
      u3 = qclab.qgates.U3( 1, pi/2, pi/3, pi/4 );
      test.verifyEqual( u3.qubit, int32(1) );       % qubit      
      test.verifyEqual( u3.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( u3.fixed );                 % fixed
      test.verifyFalse( u3.controlled );            % controlled
      test.verifyEqual( u3.cosTheta, cos(pi/4) );   % cos(theta/2)
      test.verifyEqual( u3.sinTheta, sin(pi/4) );   % sin(theta/2)
      test.verifyEqual( u3.theta, pi/2 );           % theta
      test.verifyEqual( u3.cosPhi, cos(pi/3) );     % cos(phi)
      test.verifyEqual( u3.sinPhi, sin(pi/3) );     % sin(phi)
      test.verifyEqual( u3.phi, pi/3 );             % phi
      test.verifyEqual( u3.cosLambda, cos(pi/4) );  % cos(lambda)
      test.verifyEqual( u3.sinLambda, sin(pi/4) );  % sin(lambda)
      test.verifyEqual( u3.lambda, pi/4 );          % lambda
      
      
      u3 = qclab.qgates.U3( 5, pi/2, pi/3, pi/4, true );
      test.verifyEqual( u3.qubit, int32(5) );       % qubit      
      test.verifyEqual( u3.nbQubits, int32(1) );    % nbQubits
      test.verifyTrue( u3.fixed );                  % fixed
      test.verifyEqual( u3.cosTheta, cos(pi/4) );   % cos(theta/2)
      test.verifyEqual( u3.sinTheta, sin(pi/4) );   % sin(theta/2)
      test.verifyEqual( u3.theta, pi/2 );           % theta
      test.verifyEqual( u3.cosPhi, cos(pi/3) );     % cos(phi)
      test.verifyEqual( u3.sinPhi, sin(pi/3) );     % sin(phi)
      test.verifyEqual( u3.phi, pi/3 );             % phi
      test.verifyEqual( u3.cosLambda, cos(pi/4) );  % cos(lambda)
      test.verifyEqual( u3.sinLambda, sin(pi/4) );  % sin(lambda)
      test.verifyEqual( u3.lambda, pi/4 );          % lambda
      
      u3 = qclab.qgates.U3( 5, cos(pi/3), sin(pi/3), cos(pi/4), sin(pi/4), cos(pi/5), sin(pi/5) );
      test.verifyEqual( u3.qubit, int32(5) );       % qubit      
      test.verifyEqual( u3.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( u3.fixed );                 % fixed
      test.verifyFalse( u3.controlled );            % controlled
      test.verifyEqual( u3.cosTheta, cos(pi/3) );   % cos(theta/2)
      test.verifyEqual( u3.sinTheta, sin(pi/3) );   % sin(theta/2)
      test.verifyEqual( u3.theta, 2*pi/3 );           % theta
      test.verifyEqual( u3.cosPhi, cos(pi/4) );     % cos(phi)
      test.verifyEqual( u3.sinPhi, sin(pi/4) );     % sin(phi)
      test.verifyEqual( u3.phi, pi/4 );             % phi
      test.verifyEqual( u3.cosLambda, cos(pi/5) );  % cos(lambda)
      test.verifyEqual( u3.sinLambda, sin(pi/5) );  % sin(lambda)
      test.verifyEqual( u3.lambda, pi/5 );          % lambda
      
      u3 = qclab.qgates.U3( 5, cos(pi/3), sin(pi/3), cos(pi/4), sin(pi/4), cos(pi/5), sin(pi/5), true );
      test.verifyEqual( u3.qubit, int32(5) );       % qubit      
      test.verifyEqual( u3.nbQubits, int32(1) );    % nbQubits
      test.verifyTrue( u3.fixed );                  % fixed
      test.verifyFalse( u3.controlled );            % controlled
      test.verifyEqual( u3.cosTheta, cos(pi/3) );   % cos(theta/2)
      test.verifyEqual( u3.sinTheta, sin(pi/3) );   % sin(theta/2)
      test.verifyEqual( u3.theta, 2*pi/3 );           % theta
      test.verifyEqual( u3.cosPhi, cos(pi/4) );     % cos(phi)
      test.verifyEqual( u3.sinPhi, sin(pi/4) );     % sin(phi)
      test.verifyEqual( u3.phi, pi/4 );             % phi
      test.verifyEqual( u3.cosLambda, cos(pi/5) );  % cos(lambda)
      test.verifyEqual( u3.sinLambda, sin(pi/5) );  % sin(lambda)
      test.verifyEqual( u3.lambda, pi/5 );          % lambda
    end
    
    function test_U3_copy(test)
      u3 = qclab.qgates.U3(0, cos(pi/3), sin(pi/3), cos(pi/4), sin(pi/4), cos(pi/5), sin(pi/5) ) ;
      cu3 = copy(u3);
      
      test.verifyEqual(u3.qubit, cu3.qubit);
      test.verifyEqual(u3.theta, cu3.theta);
      test.verifyEqual(u3.phi, cu3.phi);
      test.verifyEqual(u3.lambda, cu3.lambda);
      
      cu3.update( 1, 2, 3 );
      test.verifyEqual(u3.qubit, cu3.qubit);
      test.verifyNotEqual(u3.theta, cu3.theta);
      test.verifyNotEqual(u3.phi, cu3.phi);
      test.verifyNotEqual(u3.lambda, cu3.lambda);
      
      u3.setQubit(10);
      test.verifyNotEqual(u3.qubit, cu3.qubit);
      test.verifyNotEqual(u3.theta, cu3.theta);
      test.verifyNotEqual(u3.phi, cu3.phi);
      test.verifyNotEqual(u3.lambda, cu3.lambda);
    end
  end
end