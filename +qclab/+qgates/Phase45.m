% Phase45 - 1-qubit T gate (π/4 phase gate) for quantum circuits
% The Phase45 class implements a 1-qubit phase gate with a phase angle
% of π/4, also known as the T gate.
%
% The matrix representation of the Phase45 gate is:
%   T = [1        0;
%        0  exp(i·π/4)]
%
% Creation
%   Syntax
%     T = qclab.qgates.Phase45()
%       - Creates a T gate (Phase45) on qubit 0.
%
%     T = qclab.qgates.Phase45(qubit)
%       - Creates a T gate (Phase45) on the specified `qubit`.
%
%   Input Arguments
%     qubit - Qubit to which the Phase45 gate is applied.
%             Non-negative integer, default is 0.
%
%   Output
%     T - A quantum object of type `Phase45`, representing a 1-qubit T gate
%         on qubit `qubit`.
%
% Examples:
%   Create a T gate on qubit 1:
%     T = qclab.qgates.Phase45(1);

%> @file Phase45.m
%> @brief Implements Phase45 gate (T gate) class.
% ==============================================================================
%> @class Phase45
%> @brief 1-qubit Phase45 gate (T gate).
%>
%> 1-qubit Phase45 gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1   &  0\\ 
%>                    0   & \exp(i \pi/4) \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Phase45 < qclab.qgates.QGate1
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPhase45( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.Phase45');
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = qclab.qgates.Phase( obj.qubit, -pi/4 );
    end
  end
  
  
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      sqrt2 = 1 / sqrt(2);
      mat = [1, 0; 
             0, sqrt2 + 1i*sqrt2];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'T';
    end  
  end
end