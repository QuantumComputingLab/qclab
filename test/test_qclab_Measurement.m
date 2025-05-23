classdef test_qclab_Measurement < matlab.unittest.TestCase
  methods (Test)
    function test_Measurement(test)
      M = qclab.Measurement();
      
      test.verifyEqual( M.nbQubits, int64(1) );     % nbQubits
      test.verifyFalse( M.fixed );               % fixed
      test.verifyFalse( M.controlled );         % controlled
      
      % qubit
      test.verifyEqual( M.qubit, int64(0) );
      M.setQubit( 2 );
      test.verifyEqual( M.qubit, int64(2) );
      
      % qubits
      qubits = M.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(2) );
      qnew = 3 ;
      M.setQubits( qnew );
      test.verifyEqual( M.qubit, int64(3) );

      % toQASM      
      [T,out] = evalc('M.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'measure q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);

      % basisChange
      M = qclab.Measurement(2, 'x');
      test.verifyEqual(M.qubit, int64(2));
      test.verifyEqual(M.basisChange, qclab.qgates.Hadamard);
      test.verifyEqual(M.matrix, qclab.qgates.Hadamard.matrix);
      M = qclab.Measurement(2, [qclab.qgates.Hadamard, qclab.qgates.PauliX]);
      test.verifyEqual(M.matrix, ...
                       qclab.qgates.Hadamard.matrix*qclab.qgates.PauliX.matrix);
      % draw gate
      [out] = M.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = M.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
     
      % % TeX gate
      [out] = M.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = M.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] ); 

      % equals
      M1 = qclab.Measurement(2, 'x');
      M2 = qclab.Measurement(2, 'x');
      test.verifyTrue(M1.equals(M2));
      M3 = qclab.Measurement(3, 'x');
      test.verifyFalse(M1.equals(M3));
      M4 = qclab.Measurement(2, 'z');
      test.verifyFalse(M1.equals(M4));
      test.verifyFalse(M1.equals(5));

      % ctranspose
      M = qclab.Measurement(1, [qclab.qgates.Hadamard; qclab.qgates.Phase90],'test');

      M1 = ctranspose(M);
      test.verifyEqual( M1.qubit, int64(1) );
      test.verifyTrue( equals(M1.basisChange(1), [qclab.qgates.Phase(0,-pi/2)])) ;
      test.verifyTrue( equals(M1.basisChange(2), [qclab.qgates.Hadamard])) ;
      test.verifyTrue(strcmp(M1.label, 'test'));
    end

    function test_Measurement_apply_z(test)
      % apply to single statevector
      %2 qubits
      v = [sqrt(0.2); sqrt(0.2); sqrt(0.1); sqrt(0.5)];

      %measure first qubit
      M = qclab.Measurement();

      v_expected.res = {'0'; '1'};
      v_expected.prob = [0.4; 0.6];
      v_expected.states = {1/sqrt(0.2 + 0.2) * [sqrt(0.2); sqrt(0.2); 0; 0]; 
                           1/sqrt(0.1 + 0.5) * [0; 0; sqrt(0.1); sqrt(0.5)]};
      
      v_meas = M.apply('R', 'N', 2, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );
      
      %measure second qubit
      M = qclab.Measurement(1);

      v_expected.res = {'0'; '1'};
      v_expected.prob = [0.3; 0.7];
      v_expected.states = {1/sqrt(0.2 + 0.1) * [sqrt(0.2); 0; sqrt(0.1); 0]; 
                           1/sqrt(0.2 + 0.5) * [0; sqrt(0.2); 0; sqrt(0.5)]};
      
      v_meas = M.apply('R', 'N', 2, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );

      %3 qubits
      v = [sqrt(0.2); sqrt(0.2); sqrt(0.1); sqrt(0.5);0; 0; 0; 0];

      %measure second qubit
      M = qclab.Measurement(1);

      v_expected.res = {'0'; '1'};
      v_expected.prob = [0.4; 0.6];
      v_expected.states = {1/sqrt(0.2 + 0.2) * [sqrt(0.2); sqrt(0.2); 0; 0; 0; 0; 0; 0];
                           1/sqrt(0.1 + 0.5) * [0; 0; sqrt(0.1); sqrt(0.5); 0; 0; 0; 0]};
      
      v_meas = M.apply('R', 'N', 3, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );
      
      %measure third qubit
      M = qclab.Measurement(2);

      v_expected.res = {'0'; '1'};
      v_expected.prob = [0.3; 0.7];
      v_expected.states = {1/sqrt(0.2 + 0.1) * [sqrt(0.2); 0; sqrt(0.1); 0; 0; 0; 0; 0];
                           1/sqrt(0.2 + 0.5) * [0; sqrt(0.2); 0; sqrt(0.5); 0; 0; 0; 0]};
      
      v_meas = M.apply('R', 'N', 3, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );

      %measure with probability 1
      v = [1; 0; 0; 0];
      M = qclab.Measurement(0);

      v_expected.res = {'0'};
      v_expected.prob = [1];
      v_expected.states = {[1; 0; 0; 0]};
      
      v_meas = M.apply('R', 'N', 2, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );

      % apply to struct
      v = struct;
      v.res = {'0'; '1'};
      v.prob = [0.3; 0.7];
      v.states = {[sqrt(0.2); sqrt(0.2); sqrt(0.1); sqrt(0.5)];
                  [sqrt(0.1); sqrt(0.1); sqrt(0.3); sqrt(0.5)]};

      v_expected.res = {'00'; '01'; '10'; '11'};
      v_expected.prob = [0.4*0.3; 0.6*0.3; 0.2*0.7; 0.8*0.7];
      v_expected.states = {1/sqrt(0.2 + 0.2) * [sqrt(0.2); sqrt(0.2); 0; 0];
                           1/sqrt(0.1 + 0.5) * [0; 0; sqrt(0.1); sqrt(0.5)];
                           1/sqrt(0.1 + 0.1) * [sqrt(0.1); sqrt(0.1); 0; 0];
                           1/sqrt(0.3 + 0.5) * [0; 0; sqrt(0.3); sqrt(0.5)]};

      v_meas = M.apply('R', 'N', 2, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );

      % apply to struct + measure with probability 1
      v = struct;
      v.res = {'0'; '1'};
      v.prob = [0.3; 0.7];
      v.states = {[sqrt(0.2); sqrt(0.2); sqrt(0.1); sqrt(0.5)];
                  [1;0;0;0]};

      v_expected.res = {'00'; '01'; '10'};
      v_expected.prob = [0.4*0.3; 0.6*0.3; 0.7];
      v_expected.states = {1/sqrt(0.2 + 0.2) * [sqrt(0.2); sqrt(0.2); 0; 0];
                           1/sqrt(0.1 + 0.5) * [0; 0; sqrt(0.1); sqrt(0.5)];
                           [1;0;0;0]};

      v_meas = M.apply('R', 'N', 2, v);

      test.verifyEqual( v_meas, v_expected,'AbsTol', eps );
    end

    function test_Measurement_apply_basisChange_x(test)
    % 2 Qubits
    % Measure first qubit in X-basis
    v = [1/sqrt(2); 0; 1/sqrt(2); 0]; % |+0⟩ state
    M = qclab.Measurement(0, 'x');

    v_expected.res = {'0'};
    v_expected.prob = [1];
    v_expected.states = {[1/sqrt(2); 0; 1/sqrt(2); 0]};

    v_meas = M.apply('R', 'N', 2, v);

    test.verifyEqual(v_meas.res, v_expected.res);
    test.verifyEqual(v_meas.prob, v_expected.prob, 'AbsTol', eps);
    test.verifyEqual(v_meas.states{1}, v_expected.states{1}, 'AbsTol', eps);

    % Measure second qubit in X-basis
    v = [1/sqrt(2); 1/sqrt(2); 0; 0]; % |0+⟩ state
    M = qclab.Measurement(1, 'x');
    
    v_expected.res = {'0'};
    v_expected.prob = [1];
    v_expected.states = {[1/sqrt(2); 1/sqrt(2); 0; 0]};
    
    v_meas = M.apply('R', 'N', 2, v);
    
    test.verifyEqual(v_meas.res, v_expected.res);
    test.verifyEqual(v_meas.prob, v_expected.prob, 'AbsTol', eps);
    test.verifyEqual(v_meas.states{1}, v_expected.states{1}, 'AbsTol', eps);
    end

    function test_Measurement_apply_basisChange_y(test)
    % 2 Qubits
    % Measure first qubit in Y-basis
    v = [1/sqrt(2); 0; 1i*1/sqrt(2); 0]; % |R0⟩ state
    M = qclab.Measurement(0, 'y');

    v_expected.res = {'0'};
    v_expected.prob = [1];
    v_expected.states = {[1/sqrt(2); 0; 1i*1/sqrt(2); 0]};

    v_meas = M.apply('R', 'N', 2, v);

    test.verifyEqual(v_meas.res, v_expected.res);
    test.verifyEqual(v_meas.prob, v_expected.prob, 'AbsTol', eps);
    test.verifyEqual(v_meas.states{1}, v_expected.states{1}, 'AbsTol', eps);

    v = [1/sqrt(2); 1i*1/sqrt(2); 0; 0]; % |0R⟩ state

    % Measure second qubit in Y-basis
    M = qclab.Measurement(1, 'y');

    v_expected.res = {'0'};
    v_expected.prob = [1];
    v_expected.states = {[1/sqrt(2); 1i*1/sqrt(2); 0; 0]};

    v_meas = M.apply('R', 'N', 2, v);

    test.verifyEqual(v_meas.res, v_expected.res);
    test.verifyEqual(v_meas.prob, v_expected.prob, 'AbsTol', eps);
    test.verifyEqual(v_meas.states{1}, v_expected.states{1}, 'AbsTol', eps);
    end

    function test_Measurement_apply_basisChange(test)
    % 2 Qubits
    % Measure first qubit in Y-basis
    v = [1/sqrt(2); 0; 1i*1/sqrt(2); 0]; % |R0⟩ state
    M = qclab.Measurement(0, [ctranspose(qclab.qgates.Phase90) ; qclab.qgates.Hadamard]);

    v_expected.res = {'0'};
    v_expected.prob = [1];
    v_expected.states = {[1/sqrt(2); 0; 1i*1/sqrt(2); 0]};

    v_meas = M.apply('R', 'N', 2, v);

    test.verifyEqual(v_meas.res, v_expected.res);
    test.verifyEqual(v_meas.prob, v_expected.prob, 'AbsTol', eps);
    test.verifyEqual(v_meas.states{1}, v_expected.states{1}, 'AbsTol', eps);

    v = [1/sqrt(2); 1i*1/sqrt(2); 0; 0]; % |0R⟩ state

    % Measure second qubit with basisChange
    M = qclab.Measurement(1, [ctranspose(qclab.qgates.Phase90) ; qclab.qgates.Hadamard]);

    v_expected.res = {'0'};
    v_expected.prob = [1];
    v_expected.states = {[1/sqrt(2); 1i*1/sqrt(2); 0; 0]};

    v_meas = M.apply('R', 'N', 2, v);

    test.verifyEqual(v_meas.res, v_expected.res);
    test.verifyEqual(v_meas.prob, v_expected.prob, 'AbsTol', eps);
    test.verifyEqual(v_meas.states{1}, v_expected.states{1}, 'AbsTol', eps);
end
  end
end
