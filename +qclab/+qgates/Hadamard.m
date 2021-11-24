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
