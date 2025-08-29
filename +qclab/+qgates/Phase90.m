% Phase90 - 1-qubit S gate (π/2 phase gate) for quantum circuits
% The Phase90 class implements a 1-qubit phase gate with a phase angle
% of π/2, also known as the S gate.
%
% The matrix representation of the Phase90 gate is:
%   S = [1  0;
%        0  i]
%
% Creation
%   Syntax
%     S = qclab.qgates.Phase90()
%       - Creates a S gate (Phase90) on qubit 0.
%
%     S = qclab.qgates.Phase90(qubit)
%       - Creates a S gate (Phase90) on the specified `qubit`.
%
%   Input Arguments
%     qubit - Qubit to which the Phase90 gate is applied.
%             Non-negative integer, default is 0.
%
%   Output
%     S - A quantum object of type `Phase90`, representing the 1-qubit S gate
%         on qubit `qubit`.
%
% Examples:
%   Create an S gate on qubit 1:
%     S = qclab.qgates.Phase90(1);

%> @file Phase90.m
%> @brief Implements Phase90 gate (S gate) class.
% ==============================================================================
%> @class Phase90
%> @brief 1-qubit Phase90 gate (S gate).
%>
%> 1-qubit Phase90 gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1   &  0\\ 
%>                    0   & i \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef Phase90 < qclab.qgates.QGate1
  
  methods
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmPhase90( fid, obj.qubit + offset );
      out = 0;
    end
    
    % equals
    function [bool] = equals(~,other)
      bool = isa(other, 'qclab.qgates.Phase90');
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = qclab.qgates.Phase( obj.qubit, -pi/2 );
    end
  end
  
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % matrix
    function [mat] = matrix
      mat = [1, 0; 
             0, 1i];
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      label = 'S';
    end
    
   end
end