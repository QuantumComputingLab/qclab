% PauliZ - 1-qubit Pauli-Z gate for quantum circuits
% The PauliZ class implements a 1-qubit Pauli-Z gate. The Pauli-Z gate
% flips the phase of the |1⟩ state while leaving the |0⟩ state unchanged.
%
% The matrix representation of the Pauli-Z gate is:
%   Z = [1  0; 
%        0 -1]
%
% Creation
%   Syntax
%     Z = qclab.qgates.PauliZ(qubit)
%
%   Input Arguments
%     qubit - qubit to which the Pauli-Z gate is applied
%             non-negative integer, (default: 0)
%
%   Output:
%     Z - A quantum object of type `PauliZ`, representing the 1-qubit
%         Pauli-Z gate on qubit `qubit`.
%
%
% Example:
%   Create a Pauli-Z gate object acting on qubit 0:
%     Z = qclab.qgates.PauliZ(0);

%> @file PauliZ.m
%> @brief Implements Pauli-Z class.
% ==============================================================================
%> @class PauliZ
%> @brief 1-qubit Pauli-Z gate.
%>
%> 1-qubit Pauli-Z gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0\\ 
%>                    0 & -1 \end{bmatrix}\f]
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef PauliZ < qclab.qgates.QGate1
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      mat = [1 0; 0 -1];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'Z';
    end
    
  end
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPauliZ( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.PauliZ');
    end
  end
end % PauliX
