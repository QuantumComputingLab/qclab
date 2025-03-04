classdef test_qclab_QCircuit < matlab.unittest.TestCase
  methods (Test)
    function test_QCircuit(test)

      H = @qclab.qgates.Hadamard ;
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;

      % 1 qubit circuit
      circuit = qclab.QCircuit( 1 );
      test.verifyEqual( circuit.nbQubits, int32(1) );     % nbQubits
      test.verifyFalse( circuit.fixed );                  % fixed
      test.verifyFalse( circuit.controlled );             % controlled

      % qubits
      test.verifyEqual( circuit.qubit(), int32(0) );
      qubits = circuit.qubits();
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits, int32(0) );

      % 3 qubit circuit
      circuit = qclab.QCircuit( 3 );
      test.verifyEqual( circuit.nbQubits, int32(3) );     % nbQubits
      test.verifyFalse( circuit.fixed );                  % fixed
      test.verifyFalse( circuit.controlled );             % controlled

      % qubits
      test.verifyEqual( circuit.qubit(), int32(0) );
      qubits = circuit.qubits();
      test.verifyEqual( length(qubits), 3 );
      test.verifyEqual( qubits, int32([0, 1, 2]) );

      % 3 qubits circuit with offset 5
      circuit = qclab.QCircuit( 3, 5 );
      test.verifyEqual( circuit.nbQubits, int32(3) );     % nbQubits
      test.verifyFalse( circuit.fixed );                  % fixed
      test.verifyFalse( circuit.controlled );             % controlled

      % qubits
      test.verifyEqual( circuit.qubit(), int32(5) );
      qubits = circuit.qubits();
      test.verifyEqual( length(qubits), 3 );
      test.verifyEqual( qubits, int32([5, 6, 7]) );

      % offset
      test.verifyEqual( circuit.offset, int32(5) );
      circuit.setOffset( 2 );
      test.verifyEqual( circuit.offset, int32(2) );
      qubits = circuit.qubits();
      test.verifyEqual( length(qubits), 3 );
      test.verifyEqual( qubits, int32([2, 3, 4]) );

      % 3 qubit circuit with 1 qubit gates
      circuit = qclab.QCircuit( 3 );
      test.verifyEqual( circuit.nbQubits, int32(3) );     % nbQubits
      test.verifyFalse( circuit.fixed );                  % fixed
      test.verifyFalse( circuit.controlled );             % controlled
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );
      circuit.push_back( H(1) );
      test.verifyEqual( circuit.objectHandles( 1 ), X(0) );
      test.verifyEqual( circuit.objectHandles( 2 ), Y(1) );
      test.verifyEqual( circuit.objectHandles( 3 ), Z(2) );
      test.verifyEqual( circuit.objectHandles( 4 ), H(1) );

      % draw the circuit
      fprintf(1, '\n');
      circuit.draw(1, 'N');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      circuit.toTex(1, 'N');
      fprintf(1, '\n');

      % ctranspose
      circuitp = circuit';
      test.verifyEqual(circuitp.matrix, circuit.matrix', 'AbsTol', 10*eps );
    end

    function test_QCircuit_matrix_offset(test)
      c1 = qclab.QCircuit(3, 1) ;
      c2 = qclab.QCircuit(4, 2) ;
      C = qclab.QCircuit(6) ;
      Cref = qclab.QCircuit(6) ;

      SWAP = @qclab.qgates.SWAP ;
      CNOT = @qclab.qgates.CNOT ;
      MCX = @qclab.qgates.MCX ;
      U3 = @qclab.qgates.U3 ;

      c1.push_back( SWAP(0,2) );
      c1.push_back( U3(2, 0.1, 0.2, 0.3) );

      Cref.push_back( SWAP(1,3) );
      Cref.push_back( U3(3, 0.1, 0.2, 0.3) );

      C.push_back( c1 );
      test.verifyEqual( C.matrix, Cref.matrix, 'AbsTol', 10*eps );

      c2.push_back(CNOT(2,3));
      Cref.push_back(CNOT(4,5));
      c2.push_back(MCX([0,3],1,[0,1]));
      Cref.push_back(MCX([2,5],3,[0,1]));

      C.push_back( c2 );
      test.verifyEqual( C.matrix, Cref.matrix, 'AbsTol', 10*eps );
    end

    function test_QCircuit_apply_matrix(test)

      H = @qclab.qgates.Hadamard ;
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;

      circuit1 = qclab.QCircuit( 1 );
      circuit3 = qclab.QCircuit( 3 );

      I1 = qclab.qId( 1 );
      I2 = qclab.qId( 2 );

      % matrix
      X0 = X(0); Y0 = Y(0); Z0 = Z(0);
      circuit1.push_back( X(0) );
      test.verifyEqual( circuit1.matrix, X0.matrix );
      circuit1.push_back( Y(0) );
      test.verifyEqual( circuit1.matrix, Y0.matrix * X0.matrix );
      circuit1.push_back( Z(0) );
      test.verifyEqual( circuit1.matrix, Z0.matrix * Y0.matrix * X0.matrix );

      circuit3.push_back( H(0) );
      circuit3.push_back( H(1) );
      circuit3.push_back( H(2) );
      H0 = H();
      mat1 = H0.matrix ;
      mat3 = kron(kron(mat1, mat1), mat1) ;
      test.verifyEqual( circuit3.matrix, mat3, 'AbsTol', eps );
      circuit3.push_back( Z(0) );
      mat3 = kron( Z0.matrix, I2 ) * mat3;
      circuit3.push_back( Y(1) );
      mat3 = kron( kron( I1, Y0.matrix), I1) * mat3;
      circuit3.push_back( X(2) );
      mat3 = kron(I2, X0.matrix()) * mat3;
      test.verifyEqual( circuit3.matrix, mat3, 'AbsTol', eps );

      % clear
      test.verifyEqual( circuit1.nbObjects, 3 );
      circuit1.clear();
      test.verifyEqual( circuit1.nbObjects, 0 );
      test.verifyTrue( circuit1.isempty );

      % apply (nbQubits = 1)
      circuit1.push_back( H(0) );
      circuit1.push_back( Y(0) );
      circuit1.push_back( Z(0) );
      mat = I1;
      mat = H0.matrix * mat ;
      mat = Y0.matrix * mat ;
      mat = Z0.matrix * mat ;

      mat1 = I1;
      mat1 = circuit1.apply( 'L', 'N', 1, mat1 );
      test.verifyEqual( mat1, mat, 'AbsTol', eps );

      % apply (nbQubits = 2)
      mat2 = I2 ;
      mat2 = circuit1.apply( 'L', 'N', 2, mat2 );
      test.verifyEqual( mat2, kron(mat, I1), 'AbsTol', eps );

      % apply ConjTrans (nbQubits = 1)
      mat1 = I1;
      mat1 = circuit1.apply( 'L', 'C', 1, mat1 ) ;
      test.verifyEqual( mat1, mat', 'AbsTol', eps );

      % apply ConjTrans (nbQubits = 2)
      mat2 = I2 ;
      mat2 = circuit1.apply( 'L', 'C', 2, mat2 );
      test.verifyEqual( mat2, kron(mat', I1), 'AbsTol', eps );

      % apply with measurements
      circuit2 = qclab.QCircuit(2);
      circuit2.push_back(H(0));
      circuit2.push_back(H(1));
      circuit2.push_back(qclab.Measurement(0));

      mat = [1;0;0;0];
      mat = circuit2.apply('R','N',2,mat);
      v.states = {[1/sqrt(2);1/sqrt(2);0;0];[0;0;1/sqrt(2);1/sqrt(2)]};
      v.prob = [0.5;0.5];
      v.res = {'0';'1'};
      test.verifyEqual(mat, v, 'AbsTol', eps);
    end

    function test_QCircuit_simulate(test)
      % simulate without measurement
      H = @qclab.qgates.Hadamard ;
      X = @qclab.qgates.PauliX ;
      I1 = qclab.qId( 1 );
      H0 = H(0);
      X0 = X(0);

      circuit2 = qclab.QCircuit( 2 );
      v = [1; 0; 0; 0];

      circuit2.push_back( H(0) );
      circ2.states = {kron(H0.matrix,I1)*v};
      circ2.res = dec2bin(0:3);
      circ2.res = circ2.res(circ2.states{1} ~= 0,:);
      circ2.res = cellstr(circ2.res);
      circ2.prob = (kron(H0.matrix,I1)*v).^2;
      circ2.prob = circ2.prob(circ2.states{1} ~= 0);
      circ2.meas = {[qclab.Measurement(0),qclab.Measurement(1)], [], [qclab.Measurement(0),qclab.Measurement(1)]};

      w = circuit2.simulate(v);

      test.verifyEqual(w,qclab.QSimulate(circ2.states, circ2.res, circ2.prob, circ2.meas,1))

      circuit2.push_back( H(1) );
      circ2.states = {kron(H0.matrix,H0.matrix)*v};
      circ2.res = dec2bin(0:3);
      circ2.res = cellstr(circ2.res);
      circ2.prob = (kron(H0.matrix,H0.matrix)*v).^2;
      circ2.meas = {[qclab.Measurement(0),qclab.Measurement(1)], [], [qclab.Measurement(0),qclab.Measurement(1)]};

      w = circuit2.simulate(v);
      test.verifyEqual(w,qclab.QSimulate(circ2.states, circ2.res, circ2.prob, circ2.meas,1))

      circuit2.push_back( X(0) );
      circ2.states = {kron(X0.matrix * H0.matrix,H0.matrix)*v};
      circ2.res = dec2bin(0:3);
      circ2.res = cellstr(circ2.res);
      circ2.prob = (kron(X0.matrix * H0.matrix,H0.matrix)*v).^2;
      circ2.meas = {[qclab.Measurement(0),qclab.Measurement(1)], [], [qclab.Measurement(0),qclab.Measurement(1)]};

      w = circuit2.simulate(v);
      test.verifyEqual(w,qclab.QSimulate(circ2.states, circ2.res, circ2.prob, circ2.meas,1))


      %simulate with measurement
      M = @qclab.Measurement;

      %Circuit with mid and end measurements, not all qubits measured in
      %the end
      circuit3 = qclab.QCircuit(2);
      circuit3.push_back(H(0))
      circuit3.push_back(M(0))
      circuit3.push_back(H(0))
      circuit3.push_back(X(1))
      circuit3.push_back(M(1))

      rng(1)

      circ3.states = {[0; 1/sqrt(2); 0; 1/sqrt(2)];[0; 1/sqrt(2); 0; -1/sqrt(2)]};
      circ3.res = {'01';'11'};
      circ3.prob = [0.5; 0.5];
      circ3.meas = {[M(0),M(1)], M(0), M(1)};
      w = circuit3.simulate('00');

      test.verifyTrue(equals(w,qclab.QSimulate(circ3.states, circ3.res, circ3.prob, circ3.meas,1)))

      %Circuit with end measurements only, not all qubits measured in
      %the end, input given as vector

      circuit3 = qclab.QCircuit(2);
      circuit3.push_back(H(0))
      circuit3.push_back(X(1))
      circuit3.push_back(M(1))

      circ3.states = {[0; 1/sqrt(2); 0; 1/sqrt(2)]};
      circ3.res = {'1'};
      circ3.prob = [1];
      circ3.meas = {M(1), [], M(1)};
      w = circuit3.simulate([1;0;0;0]);

      test.verifyTrue(equals(w,qclab.QSimulate(circ3.states, circ3.res, circ3.prob, circ3.meas,1)))

      %Circuit with mid measurements only
      circuit3 = qclab.QCircuit(2);
      circuit3.push_back(H(0))
      circuit3.push_back(M(0))
      circuit3.push_back(H(0))
      circuit3.push_back(X(1))

      circ3.states = {[0; 1/sqrt(2); 0; 1/sqrt(2)];[0; 1/sqrt(2); 0; -1/sqrt(2)]};
      circ3.res = {'0';'1'};
      circ3.prob = [0.5; 0.5];
      circ3.meas = {M(0), M(0), []};
      w = circuit3.simulate([1;0;0;0]);
      test.verifyTrue(equals(w,qclab.QSimulate(circ3.states, circ3.res, circ3.prob, circ3.meas,1)))

      %Circuit where all qubits are measured the end without mid circuit
      %measurements
      circuit3 = qclab.QCircuit(2);
      circuit3.push_back(H(0))
      circuit3.push_back(X(1))
      circuit3.push_back(M(0))
      circuit3.push_back(M(1))

      circ3.states = {[0; 1; 0; 0];[0; 0; 0; 1]};
      circ3.res = {'01';'11'};
      circ3.prob = [0.5; 0.5];
      circ3.meas = {[M(0),M(1)], [], [M(0),M(1)]};
      w = circuit3.simulate([1;0;0;0]);
      test.verifyTrue(equals(w,qclab.QSimulate(circ3.states, circ3.res, circ3.prob, circ3.meas,1)))

      %Circuit where all qubits are measured the end with mid circuit
      %measurements

      circuit3 = qclab.QCircuit(2);
      circuit3.push_back(H(0))
      circuit3.push_back(M(0))
      circuit3.push_back(H(0))
      circuit3.push_back(X(1))
      circuit3.push_back(M(0))
      circuit3.push_back(M(1))

      circ3.states = {[0; 1; 0; 0];[0; 0; 0; 1];[0; 1; 0; 0];[0; 0; 0; -1]};
      circ3.res = {'001';'011';'101';'111'};
      circ3.prob = [0.25; 0.25; 0.25; 0.25];
      circ3.meas = {[M(0),M(0),M(1)], M(0), [M(0),M(1)]};
      w = circuit3.simulate([1;0;0;0]);
      test.verifyTrue(equals(w,qclab.QSimulate(circ3.states, circ3.res, circ3.prob, circ3.meas,1)))

      % 2 Qubits
      % Measure first qubit in Y-basis
      v = [1/sqrt(2); 0; 1i*1/sqrt(2); 0]; % |R0⟩ state
      M = qclab.Measurement(0, 'y');

      circuit4 = qclab.QCircuit(2);
      circuit4.push_back(M)

      circ4.states = {[1/sqrt(2); 0; 1i*1/sqrt(2); 0]};
      circ4.res = {'0'};
      circ4.prob = [1];
      circ4.meas = {M, [], M};
      w = circuit4.simulate(v);
      test.verifyTrue(equals(w,qclab.QSimulate(circ4.states, circ4.res, circ4.prob, circ4.meas,1)))

    end

    function test_QCircuit_Measurements(test)
      M = @qclab.Measurement;
      qc = qclab.QCircuit(2);
      qc.push_back(M(0,'x'))
      qc.push_back(qclab.qgates.Hadamard(0))
      qc.push_back(qclab.qgates.Hadamard(1))
      qc.push_back(M(1))

      meas_exp = [M(0,'x'), M(1)];
      meas_mid_exp = [M(0,'x')];
      meas_end_exp = [M(1)];

      [meas, meas_mid, meas_end] = qc.measurements;

      test.verifyEqual(meas, meas_exp, 'AbsTol', eps);
      test.verifyEqual(meas_mid, meas_mid_exp, 'AbsTol', eps);
      test.verifyEqual(meas_end, meas_end_exp, 'AbsTol', eps);
      % no measurements
      qc = qclab.QCircuit(2);
      qc.push_back(qclab.qgates.Hadamard(0))
      qc.push_back(qclab.qgates.Hadamard(1))

      meas_exp = [];
      meas_mid_exp = [];
      meas_end_exp = [];

      [meas, meas_mid, meas_end] = qc.measurements;

      test.verifyEqual(meas, meas_exp, 'AbsTol', eps);
      test.verifyEqual(meas_mid, meas_mid_exp, 'AbsTol', eps);
      test.verifyEqual(meas_end, meas_end_exp, 'AbsTol', eps);
      % just mid circuit measurements
      qc.push_back(M(0,'x'))
      qc.push_back(qclab.qgates.Hadamard(0))
      qc.push_back(qclab.qgates.Hadamard(1))


      meas_exp = [M(0,'x')];
      meas_mid_exp = [M(0,'x')];
      meas_end_exp = [];

      [meas, meas_mid, meas_end] = qc.measurements;

      test.verifyEqual(meas, meas_exp, 'AbsTol', eps);
      test.verifyEqual(meas_mid, meas_mid_exp, 'AbsTol', eps);
      test.verifyEqual(meas_end, meas_end_exp, 'AbsTol', eps);

      % just end circuit measurements
      qc = qclab.QCircuit(2);

      qc.push_back(qclab.qgates.Hadamard(0))
      qc.push_back(qclab.qgates.Hadamard(1))
      qc.push_back(M(1))

      meas_exp = [M(1)];
      meas_mid_exp = [];
      meas_end_exp = [M(1)];

      [meas, meas_mid, meas_end] = qc.measurements;

      test.verifyEqual(meas, meas_exp, 'AbsTol', eps);
      test.verifyEqual(meas_mid, meas_mid_exp, 'AbsTol', eps);
      test.verifyEqual(meas_end, meas_end_exp, 'AbsTol', eps);
    end

    function test_QCircuit_QASM(test)
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );

      % toQASM
      [T,out] = evalc('circuit.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = '\n\nQASM output:\n\nOPENQASM 2.0;\ninclude "qelib1.inc";\n\nqreg q[3];\nx q[0];\ny q[1];\nz q[2];\n';
      Tref = evalc('fprintf(1, QASMstring)');
      test.verifyEqual(T, Tref);

    end

    function test_QCircuit_equals(test)

      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;

      circuit1m = qclab.QCircuit( 3 );
      circuit1m.push_back( X(0) );
      circuit1m.push_back( Y(1) );
      circuit1m.push_back( Z(2) );

      circuit2 = qclab.QCircuit( 3 );
      circuit2.push_back( Z(2) );
      circuit2.push_back( X(0) );
      circuit2.push_back( Y(1) );

      % equals
      test.verifyTrue( circuit1m == circuit2 );
      test.verifyFalse( circuit1m ~= circuit2 );

      %with measurements
      M = @qclab.Measurement;
      H = @qclab.qgates.Hadamard;
      circuit1m = qclab.QCircuit(3);
      circuit1m.push_back(M(0))
      circuit1m.push_back(M(1))
      circuit1m.push_back(X(0))
      circuit1m.push_back(qclab.qgates.MCX([0,1],2,[0,0]))
      circuit1m.push_back(M(0))
      circuit1m.push_back(H(0))
      circuit1m.push_back(H(1))
      circuit1m.push_back(M(2,'x'))

      circuit2m = qclab.QCircuit(3);
      circuit2m.push_back(M(0))
      circuit2m.push_back(H(1))
      circuit2m.push_back(H(1))
      circuit2m.push_back(M(1))
      circuit2m.push_back(X(0))
      circuit2m.push_back(qclab.qgates.MCX([0,1],2,[0,0]))
      circuit2m.push_back(M(0))
      circuit2m.push_back(H(0))
      circuit2m.push_back(H(1))
      circuit2m.push_back(M(2,'x'))

      % equals
      test.verifyTrue( circuit2m == circuit1m );
      test.verifyFalse( circuit2m ~= circuit1m );

      circuit1m = qclab.QCircuit(3);
      circuit1m.push_back(M(0))
      circuit1m.push_back(M(1))
      circuit1m.push_back(X(0))
      circuit1m.push_back(qclab.qgates.MCX([0,1],2,[0,0]))
      circuit1m.push_back(M(0))
      circuit1m.push_back(H(0))
      circuit1m.push_back(H(1))
      circuit1m.push_back(M(2,'x'))

      circuit2m = qclab.QCircuit(3);
      circuit2m.push_back(M(0))
      circuit2m.push_back(H(1))
      circuit2m.push_back(M(1))
      circuit2m.push_back(X(0))
      circuit2m.push_back(qclab.qgates.MCX([0,1],2,[0,0]))
      circuit2m.push_back(M(0))
      circuit2m.push_back(H(0))
      circuit2m.push_back(H(1))
      circuit2m.push_back(M(2,'x'))

      % equals
      test.verifyFalse( circuit2m == circuit1m );
      test.verifyTrue( circuit2m ~= circuit1m );

    end

    function test_QCircuit_block(test)
      X = @qclab.qgates.PauliX ;
      Z = @qclab.qgates.PauliZ ;
      H = @qclab.qgates.Hadamard ;

      circuit = qclab.QCircuit(3) ;
      circuit.push_back(X(0));
      circuit.push_back(H(1));
      circuit.push_back(Z(2));

      subcircuit = qclab.QCircuit(2,1);
      subcircuit.push_back(H(1));
      subcircuit.push_back(Z(0));
      subcircuit.asBlock('subcircuit')
      test.verifyTrue( subcircuit.block == true );
      circuit.push_back(subcircuit);

      circuit.draw;

      fprintf(1, '\n');
      circuit.toTex(1, 'S');
      fprintf(1, '\n');

      subcircuit.unBlock
      test.verifyTrue( subcircuit.block == false);

      circuit.draw;

      fprintf(1, '\n');
      circuit.toTex(1, 'S');
      fprintf(1, '\n');

    end
    
    function test_QCircuit_barrier(test)
      X = @qclab.qgates.PauliX ;
      Z = @qclab.qgates.PauliZ ;
      H = @qclab.qgates.Hadamard ;

      circuit = qclab.QCircuit(3) ;
      circuit.push_back(X(0));
      circuit.push_back(H(1));
      circuit.push_back(Z(2));
      circuit.barrier
  
      test.verifyTrue( all(circuit.objects(4) == qclab.Barrier([0,1,2])));
    end


    function test_QCircuit_element_access(test)
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;
      H = @qclab.qgates.Hadamard ;
      M = @qclab.Measurement ;

      X0 = X(0);
      Y1 = Y(1);
      Z2 = Z(2);
      H1 = H(1);
      M0 = M(0);

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( X0 );
      circuit.push_back( Y1 );
      circuit.push_back( Z2 );
      circuit.push_back( H1 );

      test.verifyTrue( circuit.objects(1) == X(0) );
      test.verifyTrue( circuit.objects(1) ~= Y(1) );
      test.verifyTrue( circuit.objects(1) ~= Z(2) );
      test.verifyTrue( circuit.objects(2) == Y(1) );
      test.verifyTrue( circuit.objects(3) == Z(2) );
      test.verifyTrue( circuit.objects(4) == H(1) );

      test.verifyTrue( circuit.objectHandles(1) == X(0) );
      test.verifyTrue( circuit.objectHandles(1) ~= Y(1) );
      test.verifyTrue( circuit.objectHandles(1) ~= Z(2) );
      test.verifyTrue( circuit.objectHandles(2) == Y(1) );
      test.verifyTrue( circuit.objectHandles(3) == Z(2) );
      test.verifyTrue( circuit.objectHandles(4) == H(1) );

      test.verifyTrue( circuit.objectsFlattend(1) == X(0) );
      test.verifyTrue( circuit.objectsFlattend(1) ~= Y(1) );
      test.verifyTrue( circuit.objectsFlattend(1) ~= Z(2) );
      test.verifyTrue( circuit.objectsFlattend(2) == Y(1) );
      test.verifyTrue( circuit.objectsFlattend(3) == Z(2) );
      test.verifyTrue( circuit.objectsFlattend(4) == H(1) );

      test.verifySameHandle(  circuit.objectHandles(1), X0 );
      test.verifySameHandle(  circuit.objectHandles(2), Y1 );
      test.verifySameHandle(  circuit.objectHandles(3), Z2 );
      test.verifySameHandle(  circuit.objectHandles(4), H1 );

      if ~verLessThan('matlab', '9.8')
        test.verifyNotSameHandle(  circuit.objects(1), X0 );
        test.verifyNotSameHandle(  circuit.objects(2), Y1 );
        test.verifyNotSameHandle(  circuit.objects(3), Z2 );
        test.verifyNotSameHandle(  circuit.objects(4), H1 );
      end

      subCircuit = qclab.QCircuit(1,2);
      subCircuit.push_back(M0)

      circuit.push_back(subCircuit);

      test.verifyTrue( circuit.objectsFlattend(1) == X(0) );
      test.verifyTrue( circuit.objectsFlattend(2) == Y(1) );
      test.verifyTrue( circuit.objectsFlattend(3) == Z(2) );
      test.verifyTrue( circuit.objectsFlattend(4) == H(1) );
      test.verifyTrue( circuit.objectsFlattend(5) == M(2) );

      circuit.insert(1,subCircuit);
      circuit.pop_back

      test.verifyTrue( circuit.objectsFlattend(1) == M(2) );
      test.verifyTrue( circuit.objectsFlattend(2) == X(0) );
      test.verifyTrue( circuit.objectsFlattend(3) == Y(1) );
      test.verifyTrue( circuit.objectsFlattend(4) == Z(2) );
      test.verifyTrue( circuit.objectsFlattend(5) == H(1) );

      circuit.erase(1)
      circuit.insert(2,subCircuit);

      test.verifyTrue( circuit.objectsFlattend(1) == X(0) );
      test.verifyTrue( circuit.objectsFlattend(2) == M(2) );
      test.verifyTrue( circuit.objectsFlattend(3) == Y(1) );
      test.verifyTrue( circuit.objectsFlattend(4) == Z(2) );
      test.verifyTrue( circuit.objectsFlattend(5) == H(1) );

      circuit.erase(2)

      %subcircuits with subcircuits
      subCircuit2 = qclab.QCircuit(2,1);
      subCircuit2.push_back(H(0));
      subCircuit2.push_back(H1);
      subCircuit.setOffset(1)
      subCircuit2.push_back(subCircuit)

      circuit.insert(2,subCircuit2)

      test.verifyTrue( circuit.objectsFlattend(1) == X(0) );
      test.verifyTrue( circuit.objectsFlattend(2) == H(1) );
      test.verifyTrue( circuit.objectsFlattend(3) == H(2) );
      test.verifyTrue( circuit.objectsFlattend(4) == M(2) );
      test.verifyTrue( circuit.objectsFlattend(5) == Y(1) );
      test.verifyTrue( circuit.objectsFlattend(6) == Z(2) );
      test.verifyTrue( circuit.objectsFlattend(7) == H(1) );

    end

    function test_QCircuit_erase(test)

      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );

      % erase all
      circuit.erase( 1:circuit.nbObjects );
      test.verifyTrue( circuit.isempty );

      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );

      % erase all before
      circuit.erase( 1:circuit.nbObjects-1 );
      test.verifyEqual( circuit.nbObjects, 1 );
      test.verifyEqual( circuit.objectHandles( 1 ), Z(2) );

      circuit.clear();
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );

      % erase all after
      circuit.erase( 2:circuit.nbObjects );
      test.verifyEqual( circuit.nbObjects, 1 );
      test.verifyEqual( circuit.objectHandles( 1 ), X(0) );

    end

    function test_QCircuit_pop_back(test)

      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );

      circuit.pop_back();
      test.verifyEqual( circuit.nbObjects, 2 );
      test.verifyEqual( circuit.objectHandles( 1 ), X(0) );
      test.verifyEqual( circuit.objectHandles( 2 ), Y(1) );

      circuit.pop_back();
      test.verifyEqual( circuit.nbObjects, 1 );
      test.verifyEqual( circuit.objectHandles( 1 ), X(0) );

      circuit.pop_back();
      test.verifyTrue( circuit.isempty );

    end

    function test_QCircuit_insert(test)

      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;
      H = @qclab.qgates.Hadamard ;

      circuit = qclab.QCircuit( 3 );

      circuit.insert( 1, X(0) );
      test.verifyEqual( circuit.nbObjects, 1 );
      test.verifyEqual( circuit.objects( 1 ), X(0) );

      circuit.insert( 1, Y(1) );
      test.verifyEqual( circuit.nbObjects, 2 );
      test.verifyEqual( circuit.objects( 1 ), Y(1) );
      test.verifyEqual( circuit.objects( 2 ), X(0) );

      circuit.insert( 3, Z(2) );
      test.verifyEqual( circuit.nbObjects, 3 );
      test.verifyEqual( circuit.objects( 1 ), Y(1) );
      test.verifyEqual( circuit.objects( 2 ), X(0) );
      test.verifyEqual( circuit.objects( 3 ), Z(2) );

      circuit.insert( [1, 5], [H(0), H(1)] );
      test.verifyEqual( circuit.nbObjects, 5 );
      test.verifyEqual( circuit.objects( 1 ), H(0) );
      test.verifyEqual( circuit.objects( 2 ), Y(1) );
      test.verifyEqual( circuit.objects( 3 ), X(0) );
      test.verifyEqual( circuit.objects( 4 ), Z(2) );
      test.verifyEqual( circuit.objects( 5 ), H(1) );

    end

    function test_QCircuit_QGate2(test)

      H = @qclab.qgates.Hadamard ;
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;
      CNOT = @qclab.qgates.CNOT ;
      SWAP = @qclab.qgates.SWAP ;

      circuit = qclab.QCircuit( 4 );
      circuit.push_back( X(0) );
      circuit.push_back( CNOT(1,2) );
      circuit.push_back( H(3) );

      CNOT12 = CNOT(1,2);
      CNOT21 = CNOT(2,1);
      X0 = X(0); H0 = H(0);

      mat4 = kron(kron(X0.matrix, CNOT12.matrix()), H0.matrix()) ;
      test.verifyEqual( circuit.matrix, mat4, 'AbsTol', eps );

      circuit = qclab.QCircuit( 4 );
      circuit.push_back( X(0) );
      circuit.push_back( CNOT(2,1) );
      circuit.push_back( H(3) );

      mat4 = kron(kron(X0.matrix, CNOT21.matrix()), H0.matrix()) ;
      test.verifyEqual( circuit.matrix, mat4, 'AbsTol', eps );

      circuit = qclab.QCircuit( 4 );
      circuit.push_back( CNOT(0,1) );
      circuit.push_back( CNOT(2,3) );

      CNOT01 = CNOT(0,1);
      CNOT23 = CNOT(2,3);

      mat4 = kron(CNOT01.matrix(), CNOT23.matrix()) ;
      test.verifyEqual( circuit.matrix, mat4, 'AbsTol', eps );

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( SWAP(0, 2) );
      E0 = [1 0; 0 0];
      E1 = [0 0; 0 1];
      I1 = qclab.qId(1);
      cnot02 = kron(kron(E0,I1),I1) + kron(kron(E1,I1), X0.matrix());
      cnot20 = kron(kron(I1,I1),E0) + kron(kron(X0.matrix(),I1), E1);
      test.verifyEqual( circuit.matrix, cnot02*cnot20*cnot02, 'AbsTol', eps );

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( CNOT(0, 2) );
      test.verifyEqual( circuit.matrix, cnot02, 'AbsTol', eps );

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( CNOT(2, 0) );
      test.verifyEqual( circuit.matrix, cnot20, 'AbsTol', eps );

    end

    function test_QCircuit_HandleGate1( test )
      X = @qclab.qgates.PauliX ;
      HG1 = @qclab.qgates.HandleGate1 ;

      circuit = qclab.QCircuit( 2 );
      circuit.push_back( HG1( X() ) );

      X0 = X( 0 );
      I1 = qclab.qId( 1 );
      mat2 = kron(X0.matrix, I1);
      test.verifyEqual( circuit.matrix, mat2, 'AbsTol', eps );

      circuit.push_back( HG1( X(), 1 ) )

      mat2 = kron(X0.matrix, X0.matrix);
      test.verifyEqual( circuit.matrix, mat2, 'AbsTol', eps );
    end

    function test_QCircuit_HandleGate2( test )

      CNOT = @qclab.qgates.CNOT ;
      HG2 = @qclab.qgates.HandleGate2 ;

      CNOT01 = CNOT(0, 1);
      I1 = qclab.qId( 1 );

      circuit = qclab.QCircuit( 3 );
      circuit.push_back( HG2( CNOT01 ) );

      mat3 = kron(CNOT01.matrix, I1);
      test.verifyEqual( circuit.matrix, mat3, 'AbsTol', eps );

      circuit.push_back( HG2( CNOT01, 1) );

      mat3 = kron(I1,CNOT01.matrix)*kron(CNOT01.matrix, I1);
      test.verifyEqual( circuit.matrix, mat3, 'AbsTol', eps );

    end

    function test_QCircuit_Draw( test )
      H = @qclab.qgates.Hadamard ;
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;
      CNOT = @qclab.qgates.CNOT ;
      SWAP = @qclab.qgates.SWAP ;
      CRX = @qclab.qgates.CRotationX ;
      RXX = @qclab.qgates.RotationXX ;

      circuit = qclab.QCircuit( 5 );
      circuit.push_back( X(0) );
      circuit.push_back( CNOT(1,3) );
      circuit.push_back( H(4) );
      circuit.push_back( SWAP(0, 4) );
      circuit.push_back( RXX([0,1], pi/3) );
      circuit.push_back( RXX([2,3], pi/4) );
      circuit.push_back( RXX([1,2], pi/5) );
      circuit.push_back( RXX([3,4], pi/6) );

      % draw the circuit
      fprintf(1, '\n');
      circuit.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      circuit.toTex(1, 'S');
      fprintf(1, '\n');

      % ctranspose
      circuitp = circuit';
      test.verifyEqual(circuitp.matrix, circuit.matrix', 'AbsTol', 10*eps );
    end

    function test_QCircuit_In_QCircuit( test )
      CNOT = @qclab.qgates.CNOT ;
      RZ = @qclab.qgates.RotationZ ;
      c = qclab.QCircuit( 3 ); % small circuit
      C = qclab.QCircuit( 6 ); % large circuit

      % fill large circuit
      c.push_back( CNOT(0, 1) );
      c.push_back( CNOT(1, 2) );
      c.push_back( RZ(2, pi/3) );
      c.push_back( CNOT(1, 2) );
      c.push_back( CNOT(0, 1) );

      cmat = c.matrix ;
      C.push_back( c ) ;
      mat6 = kron(cmat, qclab.qId(3));
      test.verifyEqual( C.matrix, mat6, 'AbsTol', eps );

      cc = copy(c);
      cc.setOffset( 3 );
      C.push_back( cc );
      mat6 = kron(cmat, cmat);
      test.verifyEqual( C.matrix, mat6, 'AbsTol', eps );

      ccc = copy(cc);
      ccc.setOffset( 2 );
      C.push_back( ccc );
      mat6 = kron(kron(qclab.qId(2), cmat), qclab.qId(1)) * mat6;
      test.verifyEqual( C.matrix, mat6, 'AbsTol', eps );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      % ctranspose
      Cp = C';
      test.verifyEqual(Cp.matrix, C.matrix', 'AbsTol', 10*eps );
    end

    function test_QCircuit_MCGate( test )
      C = qclab.QCircuit( 8 );
      MCX = @qclab.qgates.MCX;
      target = 3 ;
      ctrl = [1,5,6] ;

      C.push_back( MCX(ctrl, target, [0,0,0]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [0,0,1]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [0,1,0]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [0,1,1]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [1,0,0]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [1,0,1]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [1,1,0]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.push_back( MCX(ctrl, target, [1,1,1]) );

      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      Cref = qclab.QCircuit( 8 );
      Cref.push_back( qclab.qgates.PauliX( target ) );

      test.verifyEqual(C.matrix, Cref.matrix, 'AbsTol', 10*eps );

      C.push_back( qclab.qgates.Hadamard( 0 ) );

      C.push_back( qclab.qgates.RotationY( 2, pi/3 ) );

      C.push_back( qclab.qgates.MCRotationZ([4,7], 3, [0,0], pi/5 ) );


      % draw the circuit
      fprintf(1, '\n');
      C.draw(1, 'S');
      fprintf(1, '\n');

      % TeX the circuit
      fprintf(1, '\n');
      C.toTex(1, 'S');
      fprintf(1, '\n');

      C.matrix ;

      C.clear ;
      C.push_back( MCX([2,3,4], 1, [0,0,0]) );
      C.draw() ;
    end

  end
end
