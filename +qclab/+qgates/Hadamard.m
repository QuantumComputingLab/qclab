% Hadamard - 1-qubit Hadamard gate for quantum circuits
% The Hadamard class implements a 1-qubit Hadamard gate. This gate transforms 
% the quantum state |0⟩ into the superposition (|0⟩ + |1⟩) / sqrt(2) and |1⟩ 
% into (|0⟩ - |1⟩) / sqrt(2).
%
% The matrix representation of the Hadamard gate is:
%   H = (1 / sqrt(2)) * [1  1; 
%                        1  -1]
%
% Creation
%   Syntax
%     H = qclab.qgates.Hadamard(qubit)  Hadamard gate on qubit `qubit`
%
%   Input Arguments
%     qubit - qubit to which the Hadamard gate is applied
%             non-negative integer, (default: 0)
%
%   Output:
%     H - A quantum object of type `Hadamard`, representing the 1-qubit
%         Hadamard gate on qubit `qubit`.
%
% Example:
%   Create a Hadamard gate object acting on qubit 0:
%     H = qclab.qgates.Hadamard(0);

%> @file Hadamard.m
%> @brief Implements Hadamard class.
% ==============================================================================
%> @class Hadamard
%> @brief 1-qubit Hadamard gate.
%>
%> 1-qubit Hadamard gate with matrix representation:
%>
%> \f[\frac{1}{\sqrt{2}}\begin{bmatrix} 1   &  1\\ 
%>                    1 & -1 \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Hadamard < qclab.qgates.QGate1
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      sqrt2 = 1/sqrt(2);
      mat = [sqrt2, sqrt2; 
             sqrt2, -sqrt2];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'H';
    end
    
  end
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmHadamard( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.Hadamard');
    end
  end
end % Hadamard
