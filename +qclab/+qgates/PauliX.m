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
    
    % label for draw function
    function [label] = label(obj, parameter)
      label = 'X';
    end
    
  end
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      fprintf(fid, 'x q[%d];\n', obj.qubit + offset);
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.PauliX');
    end
  end
end % PauliX
