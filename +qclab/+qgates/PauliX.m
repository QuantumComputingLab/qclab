% PauliX - 1-qubit Pauli-X gate for quantum circuits
% The PauliX class implements a 1-qubit Pauli-X gate. The Pauli-X gate 
% performs a bit flip, swapping the |0⟩ and |1⟩ states. It is the quantum 
% analog of the classical NOT gate.
%
% The matrix representation of the Pauli-X gate is:
%   X = [0  1; 
%        1  0]
%
% Creation
%   Syntax
%     X = qclab.qgates.PauliX(qubit)
%
%   Input Arguments
%     qubit - qubit to which the Pauli-X gate is applied
%             non-negative integer, (default: 0)
%
%   Output:
%     X - A quantum object of type `PauliX`, representing the 1-qubit
%         Pauli-X gate on qubit `qubit`.
%
% Example:
%   Create a Pauli-X gate object acting on qubit 0:
%     X = qclab.qgates.PauliX(0);

%> @file PauliX.m
%> @brief Implements Pauli-X class.
% ==============================================================================
%> @class PauliX
%> @brief 1-qubit Pauli-X gate.
%>
%> 1-qubit Pauli-X gate with matrix representation:
%>
%> \f[\begin{bmatrix} 0 & 1\\ 
%>                    1 & 0 \end{bmatrix}\f]
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef PauliX < qclab.qgates.QGate1
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      mat = [0 1; 1 0];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'X';
    end
    
  end
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPauliX( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.PauliX');
    end
  end
end % PauliX
