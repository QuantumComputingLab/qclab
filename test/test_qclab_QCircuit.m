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
      
      % add 1-qubit gates
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );
      circuit.push_back( H(1) );
      test.verifyEqual( circuit.gateHandle( 1 ), X(0) );
      test.verifyEqual( circuit.gateHandle( 2 ), Y(1) );
      test.verifyEqual( circuit.gateHandle( 3 ), Z(2) );
      test.verifyEqual( circuit.gateHandle( 4 ), H(1) );
      
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
      test.verifyEqual( circuit1.nbGates, 3 );
      circuit1.clear();
      test.verifyEqual( circuit1.nbGates, 0 );
      test.verifyTrue( circuit1.isempty );
      
      % apply
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
      
      mat2 = I2 ;
      mat2 = circuit1.apply( 'L', 'N', 2, mat2 );
      test.verifyEqual( mat2, kron(mat, I1), 'AbsTol', eps );
      
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
      QASMstring = 'x q[0];\ny q[1];\nz q[2];\n';
      Tref = evalc('fprintf(1, QASMstring)');
      test.verifyEqual(T, Tref);
      
    end

    function test_QCircuit_equals(test)
      
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;
      
      circuit1 = qclab.QCircuit( 3 );
      circuit1.push_back( X(0) );
      circuit1.push_back( Y(1) );
      circuit1.push_back( Z(2) );
      
      circuit2 = qclab.QCircuit( 3 );
      circuit2.push_back( Z(2) );
      circuit2.push_back( X(0) );
      circuit2.push_back( Y(1) );
      
      % equals
      test.verifyTrue( circuit1 == circuit2 );
      test.verifyFalse( circuit1 ~= circuit2 );
      
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
      circuit.erase( 1:circuit.nbGates );
      test.verifyTrue( circuit.isempty );
      
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );
      
      % erase all before
      circuit.erase( 1:circuit.nbGates-1 );
      test.verifyEqual( circuit.nbGates, 1 );
      test.verifyEqual( circuit.gateHandle( 1 ), Z(2) );
      
      circuit.clear();
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );
      
      % erase all after
      circuit.erase( 2:circuit.nbGates );
      test.verifyEqual( circuit.nbGates, 1 );
      test.verifyEqual( circuit.gateHandle( 1 ), X(0) );
      
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
      test.verifyEqual( circuit.nbGates, 2 );
      test.verifyEqual( circuit.gateHandle( 1 ), X(0) );
      test.verifyEqual( circuit.gateHandle( 2 ), Y(1) );
      
      circuit.pop_back();
      test.verifyEqual( circuit.nbGates, 1 );
      test.verifyEqual( circuit.gateHandle( 1 ), X(0) );
      
      circuit.pop_back();
      test.verifyTrue( circuit.isempty );
      
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
    
    
  end
end
