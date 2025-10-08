% PauliY - 1-qubit Pauli-Y gate for quantum circuits
% The PauliY class implements a 1-qubit Pauli-Y gate. The Pauli-Y gate
% combines a bit flip and a phase flip. It maps the |0⟩ state to -i|1⟩ and 
% the |1⟩ state to i|0⟩.
%
% The matrix representation of the Pauli-Y gate is:
%   Y = [0  -i; 
%        i  0]
%
% Creation
%   Syntax
%     Y = qclab.qgates.PauliY(qubit)
%
%   Input Arguments
%     qubit - qubit to which the Pauli-Y gate is applied
%             non-negative integer, (default: 0)
%
%   Output:
%     Y - A quantum object of type `PauliY`, representing the 1-qubit
%         Pauli-Y gate on qubit `qubit`.
%
% Example:
%   Create a Pauli-Y gate object acting on qubit 0:
%     Y = qclab.qgates.PauliY(0);

%> @file PauliY.m
%> @brief Implements Pauli-Y class.
% ==============================================================================
%> @class PauliY
%> @brief 1-qubit Pauli-Y gate.
%>
%> 1-qubit Pauli-Y gate with matrix representation:
%>
%> \f[\begin{bmatrix} 0 & -i\\ 
%>                    i & 0 \end{bmatrix}\f]
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef PauliY < qclab.qgates.QGate1
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      mat = [0 -1i; 1i 0];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'Y';
    end
    
  end
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPauliY( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.PauliY');
    end
  end
end % PauliY
