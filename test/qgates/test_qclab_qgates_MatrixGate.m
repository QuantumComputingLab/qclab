classdef test_qclab_qgates_MatrixGate < matlab.unittest.TestCase
  methods (Test)
    function test_MatrixGate(test)
      U = [  0,          1,          0,           0;
             1/sqrt(2),  0,          0,          -1/sqrt(2);
             0,          0,          1,           0;
             1/sqrt(2),  0,          0,           1/sqrt(2) ];

      unitarygate = qclab.qgates.MatrixGate([1,2],U,'test') ;
      test.verifyEqual( unitarygate.nbQubits, int64(2) );
      test.verifyTrue( unitarygate.fixed );
      test.verifyFalse( unitarygate.controlled ) ;
      test.verifyEqual( unitarygate.label , ' test ')

      % matrix
      test.verifyEqual(unitarygate.matrix, U );

      % qubit
      test.verifyEqual( unitarygate.qubit, int64(1) );

      % qubits
      qubits = unitarygate.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits(1), int64(1) );
      test.verifyEqual( qubits(2), int64(2) );
      qnew = [2, 3] ;
      unitarygate.setQubits( qnew );
      test.verifyEqual( table(unitarygate.qubits()).Var1(1), int64(2) );
      test.verifyEqual( table(unitarygate.qubits()).Var1(2), int64(3) );
      qnew = [1, 2];
      unitarygate.setQubits( qnew );

      % draw
      [out] = unitarygate.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = unitarygate.draw(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = unitarygate.draw(1, 'L');
      test.verifyEqual( out, 0 );
      [out] = unitarygate.draw(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );

      % TeX
      [out] = unitarygate.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = unitarygate.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      [out] = unitarygate.toTex(1, 'L');
      test.verifyEqual( out, 0 );
      [out] = unitarygate.toTex(0, 'N');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [2, 1] );

      % operators == and ~=
      X = qclab.qgates.PauliX();
      test.verifyTrue( unitarygate ~= X );
      test.verifyFalse( unitarygate == X );
      unitarygate2 = qclab.qgates.MatrixGate([1,2],U,'test') ;
      test.verifyTrue( unitarygate == unitarygate2 );
      test.verifyFalse( unitarygate ~= unitarygate2 );

      % ctranspose
      unitarygate = qclab.qgates.MatrixGate([1,2],U,'test') ;
      unitarygatep = unitarygate';
      test.verifyEqual( unitarygatep.nbQubits, int64(2) );
      test.verifyEqual( unitarygatep.matrix, unitarygate.matrix' );

      unitarygate.setLabel('newlabel');
      test.verifyEqual(unitarygate.label, ' newlabel ');
    end

    function test_MatrixGate_copy(test)
      U = [  0,          1,          0,           0;
             1/sqrt(2),  0,          0,          -1/sqrt(2);
             0,          0,          1,           0;
             1/sqrt(2),  0,          0,           1/sqrt(2) ];
      unitarygate = qclab.qgates.MatrixGate([1,2],U,'test') ;
      unitarygate2 = copy(unitarygate);

      test.verifyEqual(unitarygate.qubits, unitarygate2.qubits);
      test.verifyEqual(unitarygate.matrix, unitarygate2.matrix, 'AbsTol', ...
                        10*eps );
      test.verifyEqual(unitarygate.label, unitarygate2.label);
    end

    function test_MatrixGate_apply(test)
      % 1 qubit matrix gate
      U = [  1,  2        
             3,  4  ];
      unitarygate1 = qclab.qgates.MatrixGate(0,U,'test') ;

      v = [1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
      % apply to first qubit
      v1 = apply(unitarygate1, 'R', 'N', 4, v);
      v1_actual = kron(U,eye(8))*v;
      test.verifyEqual(v1,v1_actual)

      % apply to second qubit
      unitarygate1.setQubits(1)
      v2 = apply(unitarygate1, 'R', 'N', 4, v);
      v2_actual = kron(kron(eye(2),U),eye(4))*v;
      test.verifyEqual(v2,v2_actual)

      % apply to last qubit
      unitarygate1.setQubits(3)
      v3 = apply(unitarygate1, 'R', 'N', 4, v);
      v3_actual = kron(eye(8),U)*v;
      test.verifyEqual(v3,v3_actual)

      % 2 qubit matrix gate
      U = [  0,          1,          0,           0;
             1/sqrt(2),  0,          0,          -1/sqrt(2);
             0,          0,          1,           0;
             1/sqrt(2),  0,          0,           1/sqrt(2) ];
      unitarygate2 = qclab.qgates.MatrixGate([0,1],U,'test') ;

      v = [1;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0];
      % apply to first two qubits
      v1 = apply(unitarygate2, 'R', 'N', 4, v);
      v1_actual = kron(U,eye(4))*v;
      test.verifyEqual(v1,v1_actual)

      % apply to mid qubits
      unitarygate2.setQubits([1,2])
      v2 = apply(unitarygate2, 'R', 'N', 4, v);
      v2_actual = kron(kron(eye(2),U),eye(2))*v;
      test.verifyEqual(v2,v2_actual)

      % apply to end qubits
      unitarygate2.setQubits([2,3])
      v3 = apply(unitarygate2, 'R', 'N', 4, v);
      v3_actual = kron(eye(4),U)*v;
      test.verifyEqual(v3,v3_actual)

      % 3 qubit matrix gate
      U1 = [  1,  2        
              3,  4  ];
      U2 = [  0,          1,          0,           0;
             1/sqrt(2),  0,          0,          -1/sqrt(2);
             0,          0,          1,           0;
             1/sqrt(2),  0,          0,           1/sqrt(2) ];
      U3 = kron(U1,U2) ;
      unitarygate2 = qclab.qgates.MatrixGate([0,1,2],U3,'test') ;

      v = eye(2^5,1);
      % apply to first three qubits
      v1 = apply(unitarygate2, 'R', 'N', 5, v);
      v1_actual = kron(U3,eye(4))*v;
      test.verifyEqual(v1,v1_actual)

      % apply to mid three qubits
      unitarygate2.setQubits([1,2,3])
      v2 = apply(unitarygate2, 'R', 'N', 5, v);
      v2_actual = kron(kron(eye(2),U3),eye(2))*v;
      test.verifyEqual(v2,v2_actual)

      % apply to end three qubits
      unitarygate2.setQubits([2,3,4])
      v3 = apply(unitarygate2, 'R', 'N', 5, v);
      v3_actual = kron(eye(4),U3)*v;
      test.verifyEqual(v3,v3_actual)
      
    end
  end
end