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
