%> @file IO.m
%> @brief Implements IO class.
% ==============================================================================
%> @class IO
%> @brief central storage of all QASM strings.
% ==============================================================================
classdef IO
  methods ( Static )
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % QASM I/O
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Controlled 1-qubit gates
    % --------------------------------------------------------------------------
    
    % qasmCNOT
    function qasmCNOT( fid, control, target, controlState )
      gateString = sprintf( 'cx q[%d], q[%d];\n', control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCPhase
    function qasmCPhase( fid, control, target, controlState, theta )
      gateString = sprintf( 'cp(%.15f) q[%d], q[%d];\n', theta, control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCRotationX
    function qasmCRotationX( fid, control, target, controlState, theta )
      gateString = sprintf( 'crx(%.15f) q[%d], q[%d];\n', theta, control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCRotationY
    function qasmCRotationY( fid, control, target, controlState, theta )
      gateString = sprintf( 'cry(%.15f) q[%d], q[%d];\n', theta, control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCRotationZ
    function qasmCRotationZ( fid, control, target, controlState, theta )
      gateString = sprintf( 'crz(%.15f) q[%d], q[%d];\n', theta, control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCY
    function  qasmCY( fid, control, target, controlState )
      gateString = sprintf( 'cy q[%d], q[%d];\n', control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCZ
    function  qasmCZ( fid, control, target, controlState )
      gateString = sprintf( 'cz q[%d], q[%d];\n', control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCU2
    function qasmCU2( fid, control, target, controlState, phi, lambda )
      gateString = sprintf( 'cu2(%.15f, %.15f) q[%d], q[%d];\n', phi, ...
                           lambda, control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmCU3
    function qasmCU3( fid, control, target, controlState, theta, phi, lambda )
      gateString = sprintf( 'cu3(%.15f, %.15f, %.15f) q[%d], q[%d];\n', theta, ...
                           phi, lambda, control, target );
      qclab.IO.qasmQControlledGate2( fid, control, controlState, gateString );
    end
    
    % qasmQControlledGate2
    function qasmQControlledGate2( fid, control, controlState, gateString )
      if (controlState == 0)
        fprintf(fid, 'x q[%d];\n', control );
      end
      fprintf( fid, gateString);
      if (controlState == 0)
        fprintf(fid, 'x q[%d];\n', control );
      end
    end
    
    % 1-qubit gates
    % --------------------------------------------------------------------------
    
    % qasmHadamard
    function qasmHadamard( fid, qubit )
      fprintf(fid, 'h q[%d];\n', qubit );
    end
    
    % qasmPauliX
    function qasmPauliX( fid, qubit )
      fprintf(fid, 'x q[%d];\n', qubit );
    end
    
    % qasmPauliY
    function qasmPauliY( fid, qubit )
      fprintf(fid, 'y q[%d];\n', qubit );
    end
    
    % qasmPauliZ
    function qasmPauliZ( fid, qubit )
      fprintf(fid, 'z q[%d];\n', qubit );
    end
    
    % qasmPhase
    function qasmPhase( fid, qubit, theta )
      fprintf(fid,'rz(%.15f) q[%d];\n', theta, qubit );
    end
    
    % qasmPhase45
    function qasmPhase45( fid, qubit )
      fprintf(fid, 't q[%d];\n', qubit );
    end
    
    % qasmPhase90
    function qasmPhase90( fid, qubit )
      fprintf(fid, 's q[%d];\n', qubit );
    end
    
    % qasmRotationX
    function qasmRotationX( fid, qubit, theta )
      fprintf(fid,'rx(%.15f) q[%d];\n', theta, qubit );
    end
    
    % qasmRotationY
    function qasmRotationY( fid, qubit, theta )
      fprintf(fid,'ry(%.15f) q[%d];\n', theta, qubit );
    end
    
    % qasmRotationZ
    function qasmRotationZ( fid, qubit, theta )
      fprintf(fid,'rz(%.15f) q[%d];\n', theta, qubit );
    end
    
    % qasmU2
    function qasmU2( fid, qubit, phi, lambda )
      fprintf(fid,'u2(%.15f, %.15f) q[%d];\n', phi, lambda, qubit );
    end
    
    % qasmU3
    function qasmU3( fid, qubit, theta, phi, lambda )
      fprintf(fid,'u3(%.15f, %.15f, %.15f) q[%d];\n', theta, phi, lambda, qubit);
    end
    
    
    % 2-qubit gates
    % --------------------------------------------------------------------------
    
    % qasmiSWAP
    function qasmiSWAP( fid, qubits )
      fprintf(fid,'iswap q[%d], q[%d];\n', qubits(1), qubits(2));
    end
    
    % qasmSWAP
    function qasmSWAP( fid, qubits )
      fprintf(fid,'swap q[%d], q[%d];\n', qubits(1), qubits(2));
    end
    
    % qasmRotationXX
    function qasmRotationXX( fid, qubits, theta )
      fprintf(fid,'rxx(%.15f) q[%d], q[%d];\n', theta, qubits(1), qubits(2) );
    end
    
    % qasmRotationYY
    function qasmRotationYY( fid, qubits, theta )
      fprintf(fid,'ryy(%.15f) q[%d], q[%d];\n', theta, qubits(1), qubits(2) );
    end
    
    % qasmRotationZZ
    function qasmRotationZZ( fid, qubits, theta )
      fprintf(fid,'rzz(%.15f) q[%d], q[%d];\n', theta, qubits(1), qubits(2) );
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  end
  
end