classdef test_qclab_qgates_Phase < matlab.unittest.TestCase
  methods (Test)
    function test_Phase(test)
      Ph = qclab.qgates.Phase() ;
      test.verifyEqual( Ph.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( Ph.fixed );             % fixed
      test.verifyFalse( Ph.controlled );        % controlled
      test.verifyEqual( Ph.cos, 1.0 );          % cos
      test.verifyEqual( Ph.sin, 0.0 );          % sin
      test.verifyEqual( Ph.theta, 0.0 );        % theta
      
      % matrix
      test.verifyEqual( Ph.matrix, eye(2) );
      
      % qubit
      test.verifyEqual( Ph.qubit, int32(0) );
      Ph.setQubit( 2 ) ;
      test.verifyEqual( Ph.qubit, int32(2) );
      
      % qubits
      qubits = Ph.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int32(2) )
      qnew = 3 ;
      Ph.setQubits( qnew );
      test.verifyEqual( Ph.qubit, int32(3) );
      
      % fixed
      Ph.makeFixed();
      test.verifyTrue( Ph.fixed );
      Ph.makeVariable();
      test.verifyFalse( Ph.fixed );
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      Ph.update( new_angle ) ;
      test.verifyEqual( Ph.theta, 0.5, 'AbsTol', eps );
      test.verifyEqual( Ph.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( Ph.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      Ph.update( pi/4 );
      test.verifyEqual( Ph.theta, pi/4, 'AbsTol', eps );
      test.verifyEqual( Ph.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( Ph.sin, sin(pi/4), 'AbsTol', eps);
      
      % matrix
      mat = [1, 0; 0, cos(pi/4)+1i*sin(pi/4)];
      test.verifyEqual( Ph.matrix, mat, 'AbsTol', eps);
      
      % toQASM
      [T,out] = evalc('Ph.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = sprintf('rz(%.15f) q[3];',Ph.theta);
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = Ph.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = Ph.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = Ph.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % update(cos, sin)
      Ph.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( Ph.theta, pi/3, 'AbsTol', eps );
      test.verifyEqual( Ph.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( Ph.sin, sin(pi/3), 'AbsTol', eps);
      
      % operators == and ~=
      Ph2 = qclab.qgates.Phase( 0, cos(pi/3), sin(pi/3) );
      test.verifyTrue( Ph == Ph2 );
      test.verifyFalse( Ph ~= Ph2 );
      Ph2.update( 1 );
      test.verifyTrue( Ph ~= Ph2 );
      test.verifyFalse( Ph == Ph2 );
      
    end
    
    function test_Phase_constructors( test )
      Ph = qclab.qgates.Phase( 1, pi/2 );
      test.verifyEqual( Ph.qubit, int32(1) );
      test.verifyEqual( Ph.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( Ph.fixed );             % fixed
      test.verifyFalse( Ph.controlled );        % controlled
      test.verifyEqual( Ph.cos, cos(pi/2), 'AbsTol', eps  );          % cos
      test.verifyEqual( Ph.sin, sin(pi/2), 'AbsTol', eps  );          % sin
      test.verifyEqual( Ph.theta, pi/2, 'AbsTol', eps  );        % theta
      
      Ph = qclab.qgates.Phase( 5, pi/2, true );
      test.verifyEqual( Ph.qubit, int32(5) );
      test.verifyEqual( Ph.nbQubits, int32(1) );    % nbQubits
      test.verifyTrue( Ph.fixed );             % fixed
      test.verifyFalse( Ph.controlled );        % controlled
      test.verifyEqual( Ph.cos, cos(pi/2), 'AbsTol', eps  );          % cos
      test.verifyEqual( Ph.sin, sin(pi/2), 'AbsTol', eps  );          % sin
      test.verifyEqual( Ph.theta, pi/2, 'AbsTol', eps  );        % theta
      
      Ph = qclab.qgates.Phase( 5, cos(pi/4), sin(pi/4) );
      test.verifyEqual( Ph.qubit, int32(5) );
      test.verifyEqual( Ph.nbQubits, int32(1) );    % nbQubits
      test.verifyFalse( Ph.fixed );             % fixed
      test.verifyFalse( Ph.controlled );        % controlled
      test.verifyEqual( Ph.cos, cos(pi/4), 'AbsTol', eps  );          % cos
      test.verifyEqual( Ph.sin, sin(pi/4), 'AbsTol', eps  );          % sin
      test.verifyEqual( Ph.theta, pi/4, 'AbsTol', eps  );        % theta
      
      Ph = qclab.qgates.Phase( 5, cos(pi/4), sin(pi/4), true );
      test.verifyEqual( Ph.qubit, int32(5) );
      test.verifyEqual( Ph.nbQubits, int32(1) );    % nbQubits
      test.verifyTrue( Ph.fixed );             % fixed
      test.verifyFalse( Ph.controlled );        % controlled
      test.verifyEqual( Ph.cos, cos(pi/4), 'AbsTol', eps  );          % cos
      test.verifyEqual( Ph.sin, sin(pi/4), 'AbsTol', eps  );          % sin
      test.verifyEqual( Ph.theta, pi/4, 'AbsTol', eps  );        % theta
    end
    
    function test_Phase_copy(test)
      phase = qclab.qgates.Phase(0, cos(pi/4), sin(pi/4) ) ;
      cphase = copy(phase);
      
      test.verifyEqual(phase.qubit, cphase.qubit);
      test.verifyEqual(phase.theta, cphase.theta);
      
      cphase.update( 1 );
      test.verifyEqual(phase.qubit, cphase.qubit);
      test.verifyNotEqual(phase.theta, cphase.theta);
      
      phase.setQubit(10);
      test.verifyNotEqual(phase.qubit, cphase.qubit);
      test.verifyNotEqual(phase.theta, cphase.theta);
    end
  end
end