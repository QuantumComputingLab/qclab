classdef test_qclab_qgates_HandleGate2 < matlab.unittest.TestCase
  methods (Test)
    function test_HandleGate2(test)
      swap = qclab.qgates.SWAP ;
      H = qclab.qgates.HandleGate2( swap ) ;
      
      test.verifyEqual( H.nbQubits, int64(2) );     % nbQubits
      test.verifyTrue( H.fixed );               % fixed
      test.verifyFalse( H.controlled );         % controlled
      test.verifyEqual( H.qubit, int64(0) );    % qubit
      test.verifyEqual( H.offset, int64(0) );   % offset
      test.verifySameHandle( H.gateHandle, swap )       % handle
      
      % qubits
      qubits = H.qubits;
      test.verifyEqual( length(qubits), 2 );
      test.verifyEqual( qubits, int64([0, 1]) );
      
      % matrix
      test.verifyEqual( H.matrix, swap.matrix );
      
      % toQASM
      [T,out] = evalc('H.toQASM(1)'); % capture output to std::out in T
      test.verifyEqual( out, 0 );
      QASMstring = 'swap q[0], q[1];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = H.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % TeX
      [out] = H.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [2, 1] );
      
      % offset
      H.setOffset( 3 );
      qubits = H.qubits;
      test.verifyEqual( H.qubit, int64(3) );
      test.verifyEqual( qubits, int64([3, 4]) );
      test.verifyEqual( H.offset, int64(3) );
      [T,~] = evalc('H.toQASM(1)'); % capture output to std::out in T
      QASMstring = 'swap q[3], q[4];';
      test.verifyEqual(T(1:length(QASMstring)), QASMstring);
      
      % draw gate
      [out] = H.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % TeX
      [out] = H.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [2, 1] );
      
      % handle
      Hswap = H.gateHandle ;
      Hswap.setQubits( [7, 3] );
      qubits = H.qubits;
      test.verifyEqual( qubits, int64([6, 10]) );
      CX = H.gate ;
      CX.setQubits( [17, 13] );
      qubits = H.qubits;
      test.verifyEqual( qubits, int64([6, 10]) );
      H.setGate(CX);
      qubits = H.qubits;
      test.verifyEqual( qubits, int64([16, 20]) );
      
      % operators == and ~=
      test.verifyTrue( H == swap );
      test.verifyFalse( H ~= swap );
      cnot = qclab.qgates.CNOT ;
      test.verifyTrue( H ~= cnot );
      test.verifyFalse( H == cnot );
      swap2 = qclab.qgates.SWAP ;
      Hswap = qclab.qgates.HandleGate2( swap2 ) ;
      Hcnot = qclab.qgates.HandleGate2( cnot ) ;
      test.verifyTrue( H == Hswap );
      test.verifyFalse( H ~= Hswap );
      test.verifyTrue( H ~= Hcnot );
      test.verifyFalse( H == Hcnot );
      
      % draw Hcnot and Hcphase
      Hcnot.setOffset( 2 );
      [out] = Hcnot.draw(1, 'N');
      test.verifyEqual( out, 0 );
      
      cphase = qclab.qgates.CPhase( 0, 2, pi/3 );
      Hcphase = qclab.qgates.HandleGate2 ( cphase, 1 );
      [out] = Hcphase.draw(1, 'S');
      test.verifyEqual( out, 0 );
      
      % TeX Hcnot and Hcphase
      Hcnot.setOffset( 2 );
      [out] = Hcnot.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      
      cphase = qclab.qgates.CPhase( 0, 2, pi/3 );
      Hcphase = qclab.qgates.HandleGate2 ( cphase, 1 );
      [out] = Hcphase.toTex(1, 'S');
      test.verifyEqual( out, 0 );
      
      % ctranspose
      Hp = Hcphase';
      cphasep = cphase';
      test.verifyEqual(Hp.matrix, cphasep.matrix );
    end
    
    function test_HandleGate2_QRotationGate2( test )
      R = qclab.qgates.RotationXX ;
      H = qclab.qgates.HandleGate2( R ) ;
      
      test.verifyEqual( H.nbQubits, int64(2) );     % nbQubits
      test.verifyFalse( H.fixed );               % fixed
      test.verifyFalse( H.controlled );         % controlled
      test.verifyEqual( H.qubit, int64(0) );    % qubit
      test.verifyEqual( H.offset, int64(0) );   % offset
      test.verifySameHandle( H.gateHandle, R );  % gateHandle
      if ~verLessThan('matlab', '9.8')
          test.verifyNotSameHandle( H.gate, R ); % gate
      end
      
      CR = H.gate ;
      HR = H.gateHandle ;
      
      test.verifyEqual( CR.theta, R.theta );
      test.verifyEqual( HR.theta, R.theta );
      
      R.update( 0.1 ); 
      
      test.verifyNotEqual( CR.theta, R.theta );
      test.verifyEqual( HR.theta, R.theta );
      
      % draw gate
      fprintf('\n') % because of Matlab dot
      H.setOffset( 3 );
      [out] = H.draw(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.draw(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [6, 1] );
      
      % TeX
      fprintf('\n') % because of Matlab dot
      H.setOffset( 3 );
      [out] = H.toTex(1, 'N');
      test.verifyEqual( out, 0 );
      [out] = H.toTex(0, 'L');
      test.verifyTrue( isa(out, 'cell') );
      test.verifySize( out, [2, 1] );
      
      % ctranspose
      Hp = H';
      Rp = R';
      test.verifyEqual(Hp.matrix, Rp.matrix );
      
    end
    
    function test_HandleGate2_Copy( test )
      R = qclab.qgates.RotationXX ;
      H = qclab.qgates.HandleGate2( R ) ;
      
      CH = copy(H);
      
      test.verifyEqual( H.gate.theta, CH.gate.theta );
      
      R.update( 0.1 );
      
      test.verifyNotEqual( H.gate.theta, CH.gate.theta );
      
    end
    
  end
end