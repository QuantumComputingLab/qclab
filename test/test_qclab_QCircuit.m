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
      test.verifyEqual( circuit.gateHandles( 1 ), X(0) );
      test.verifyEqual( circuit.gateHandles( 2 ), Y(1) );
      test.verifyEqual( circuit.gateHandles( 3 ), Z(2) );
      test.verifyEqual( circuit.gateHandles( 4 ), H(1) );
      
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
      test.verifyEqual( circuit1.nbGates, 3 );
      circuit1.clear();
      test.verifyEqual( circuit1.nbGates, 0 );
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
    end
    
    function test_QCircuit_simulate(test)
      
      H = @qclab.qgates.Hadamard ;
      X = @qclab.qgates.PauliX ;
      I1 = qclab.qId( 1 );
      H0 = H(0);
      X0 = X(0);
      
      circuit2 = qclab.QCircuit( 2 );
      v = [1; 0; 0; 0];
      
      circuit2.push_back( H(0) );
      w = circuit2.simulate(v);
      
      test.verifyEqual( w, kron(H0.matrix,I1)*v, 'AbsTol', eps)
      
      circuit2.push_back( H(1) );
      w = circuit2.simulate(v);
      
      test.verifyEqual( w, kron(H0.matrix,H0.matrix)*v, 'AbsTol', eps)
      
      circuit2.push_back( X(0) );
      
      w = circuit2.simulate(v);
      
      test.verifyEqual( w, kron(X0.matrix * H0.matrix,H0.matrix)*v, ...
         'AbsTol', eps)
      
      
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
    
    function test_QCircuit_element_access(test)
      X = @qclab.qgates.PauliX ;
      Y = @qclab.qgates.PauliY ;
      Z = @qclab.qgates.PauliZ ;
      H = @qclab.qgates.Hadamard ;
      
      X0 = X(0);
      Y1 = Y(1);
      Z2 = Z(2);
      H1 = H(1);
      
      circuit = qclab.QCircuit( 3 );
      circuit.push_back( X0 );
      circuit.push_back( Y1 );
      circuit.push_back( Z2 );
      circuit.push_back( H1 );
      
      test.verifyTrue( circuit.gates(1) == X(0) );
      test.verifyTrue( circuit.gates(1) ~= Y(1) );
      test.verifyTrue( circuit.gates(1) ~= Z(2) );
      test.verifyTrue( circuit.gates(2) == Y(1) );
      test.verifyTrue( circuit.gates(3) == Z(2) );
      test.verifyTrue( circuit.gates(4) == H(1) );
      
      test.verifyTrue( circuit.gateHandles(1) == X(0) );
      test.verifyTrue( circuit.gateHandles(1) ~= Y(1) );
      test.verifyTrue( circuit.gateHandles(1) ~= Z(2) );
      test.verifyTrue( circuit.gateHandles(2) == Y(1) );
      test.verifyTrue( circuit.gateHandles(3) == Z(2) );
      test.verifyTrue( circuit.gateHandles(4) == H(1) );
      
      test.verifySameHandle(  circuit.gateHandles(1), X0 );
      test.verifySameHandle(  circuit.gateHandles(2), Y1 );
      test.verifySameHandle(  circuit.gateHandles(3), Z2 );
      test.verifySameHandle(  circuit.gateHandles(4), H1 );
      
      if ~verLessThan('matlab', '9.8')
          test.verifyNotSameHandle(  circuit.gates(1), X0 );
          test.verifyNotSameHandle(  circuit.gates(2), Y1 );
          test.verifyNotSameHandle(  circuit.gates(3), Z2 );
          test.verifyNotSameHandle(  circuit.gates(4), H1 );
      end
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
      test.verifyEqual( circuit.gateHandles( 1 ), Z(2) );
      
      circuit.clear();
      circuit.push_back( X(0) );
      circuit.push_back( Y(1) );
      circuit.push_back( Z(2) );
      
      % erase all after
      circuit.erase( 2:circuit.nbGates );
      test.verifyEqual( circuit.nbGates, 1 );
      test.verifyEqual( circuit.gateHandles( 1 ), X(0) );
      
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
      test.verifyEqual( circuit.gateHandles( 1 ), X(0) );
      test.verifyEqual( circuit.gateHandles( 2 ), Y(1) );
      
      circuit.pop_back();
      test.verifyEqual( circuit.nbGates, 1 );
      test.verifyEqual( circuit.gateHandles( 1 ), X(0) );
      
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
      test.verifyEqual( circuit.nbGates, 1 );
      test.verifyEqual( circuit.gates( 1 ), X(0) );
      
      circuit.insert( 1, Y(1) );
      test.verifyEqual( circuit.nbGates, 2 );
      test.verifyEqual( circuit.gates( 1 ), Y(1) );
      test.verifyEqual( circuit.gates( 2 ), X(0) );
      
      circuit.insert( 3, Z(2) );
      test.verifyEqual( circuit.nbGates, 3 );
      test.verifyEqual( circuit.gates( 1 ), Y(1) );
      test.verifyEqual( circuit.gates( 2 ), X(0) );
      test.verifyEqual( circuit.gates( 3 ), Z(2) );
      
      circuit.insert( [1, 5], [H(0), H(1)] );
      test.verifyEqual( circuit.nbGates, 5 );
      test.verifyEqual( circuit.gates( 1 ), H(0) );
      test.verifyEqual( circuit.gates( 2 ), Y(1) );
      test.verifyEqual( circuit.gates( 3 ), X(0) );
      test.verifyEqual( circuit.gates( 4 ), Z(2) );
      test.verifyEqual( circuit.gates( 5 ), H(1) );
      
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
