%> @file RotationXX.m
%> @brief Implements RotationXX class.
% ==============================================================================
%> @class RotationXX
%> @brief 2-qubit rotation gate about the XX axis.
%>
%> 2-qubit Pauli rotation about XX axis with matrix representation:
%>
%> \f[\begin{bmatrix} c   & 0   & 0   & -is\\ 
%>                    0   & c   & -is & 0 \\
%>                    0   & -is & c   & 0 \\
%>                    -is & 0   & 0   & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationXX < qclab.qgates.QRotationGate2
  
  methods
    % matrix
    function [mat] = matrix(obj)
      c = obj.cos; s = -1i*obj.sin;
      mat = [c, 0, 0, s;
             0, c, s, 0;
             0, s, c, 0;
             s, 0, 0, c];
    end
    
    % toQASM
    function [out] = toQASM(obj,fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationXX( fid, obj.qubits + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationXX');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_{xx}';        
      else
        label = 'RXX';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert XX rotation to YY rotation with same parameters
    function G = qclab.qgates.RotationYY( obj )
      G = qclab.qgates.RotationYY( obj.qubits, obj.angle );
    end
    
    %> convert XX rotation to ZZ rotation with same parameters
    function G = qclab.qgates.RotationZZ( obj )
      G = qclab.qgates.RotationZZ( obj.qubits, obj.angle );
    end
  end
  
  
end % RotationXX
