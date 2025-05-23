classdef test_qclab_qgates_HandleGate1 < matlab.unittest.TestCase
  methods (Test)
    function test_HandleGate1(test)
      X = qclab.qgates.PauliX ;
      H = qclab.qgates.HandleGate1( X ) ;
      
      test.verifyEqual( H.nbQubits, int64(1) );     % nbQubits
      test.verifyTrue( H.fixed );                   % fixed
      test.verifyFalse( H.controlled );             % controlled
      test.verifyEqual( H.qubit, int64(0) );        % qubit
      test.verifyEqual( H.offset, int64(0) );       % offset
      test.verifySameHandle( H.gateHandle, X );     % gateHandle
      if ~verLessThan('matlab', '9.8')
          test.verifyNotSameHandle( H.gate, X );        % gate
      end
      
      % qubits
      qubits = H.qubits;
      test.verifyEqual( length(qubits), 1 );
      test.verifyEqual( qubits(1), int64(0) );
      
      % matrix
      test.verifyEqual( H.matrix, X.matrix );
      
      % toQASM
      [T,out] = evalc('H.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'x q[0];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = H.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX
      [out] = H.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % offset
      H.setOffset( 3 );
      test.verifyEqual( H.qubit, int64(3) );
      test.verifyEqual( H.offset, int64(3) );
      qubits = H.qubits;
      test.verifyEqual( qubits(1), int64(3) );
      [T,~] = evalc('H.toQASM(1)'); % capture output to std::out in T
      QASMstring = 'x q[3];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate with offset
      [out] = H.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [3, 1] );
      
      % TeX with offset
      [out] = H.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [1, 1] );
      
      % handle
      HX = H.gateHandle ;
      HX.setQubit( 3 );
      test.verifyEqual( H.qubit, int64(6) );
      CX = H.gate ;
      CX.setQubit( 1 );
      test.verifyEqual( H.qubit, int64(6) );
      H.setGate(CX);
      test.verifyEqual( H.qubit, int64(4) );
      
      % operators == and ~=
      test.verifyTrue( H == X );
      test.verifyFalse( H ~= X );
      Z = qclab.qgates.PauliZ ;
      test.verifyTrue( H ~= Z );
      test.verifyFalse( H == Z );
      X2 = qclab.qgates.PauliX ;
      HX = qclab.qgates.HandleGate1( X2 ) ;
      HZ = qclab.qgates.HandleGate1( Z ) ;
      test.verifyTrue( H == HX );
      test.verifyFalse( H ~= HX );
      test.verifyTrue( H ~= HZ );
      test.verifyFalse( H == HZ );
      
      % ctranspose
      Hp = H';
      Xp = X';
      test.verifyEqual(Hp.matrix, Xp.matrix );
    end
    
    function test_HandleGate1_QRotationGate1( test )
      R = qclab.qgates.RotationX ;
      H = qclab.qgates.HandleGate1( R ) ;
      
      test.verifyEqual( H.nbQubits, int64(1) );   % nbQubits
      test.verifyFalse( H.fixed );                % fixed
      test.verifyFalse( H.controlled );           % controlled
      test.verifyEqual( H.qubit, int64(0) );      % qubit
      test.verifyEqual( H.offset, int64(0) );     % offset
      test.verifySameHandle( H.gateHandle, R );   % gateHandle
      if ~verLessThan('matlab', '9.8')
          test.verifyNotSameHandle( H.gate, R );      % gate
      end
      
      
      CR = H.gate ;
      HR = H.gateHandle ;
      
      test.verifyEqual( CR.theta, R.theta );
      test.verifyEqual( HR.theta, R.theta );
      
      R.update( 0.1 ); 
      
      test.verifyNotEqual( CR.theta, R.theta );
      test.verifyEqual( HR.theta, R.theta );
      
      % ctranspose
      Hp = H';
      Rp = R';
      test.verifyEqual(Hp.matrix, Rp.matrix );
      
    end
    
    
    function test_HandleGate1_Copy( test )
      R = qclab.qgates.RotationX ;
      H = qclab.qgates.HandleGate1( R ) ;
      
      CH = copy(H);
      
      test.verifyEqual( H.gate.theta, CH.gate.theta );
      
      R.update( 0.1 );
      
      test.verifyNotEqual( H.gate.theta, CH.gate.theta );
      
    end
  end
end