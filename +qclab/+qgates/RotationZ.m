%> @file RotationZ.m
%> @brief Implements RotationZ class.
% ==============================================================================
%> @class RotationZ
%> @brief 1-qubit rotation gate about the Z axis.
%>
%> 1-qubit Pauli-Z rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c - is   &  0\\ 
%>                    0 & c + is \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationZ < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos - 1i*obj.sin, 0; 
              0, obj.cos + 1i*obj.sin ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationZ( fid, obj.qubit + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationZ');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_z';
      else
        label = 'RZ';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert Z rotation to X rotation with same parameters
    function G = qclab.qgates.RotationX( obj )
      G = qclab.qgates.RotationX( obj.qubits, obj.angle );
    end
    
    %> convert Z rotation to Y rotation with same parameters
    function G = qclab.qgates.RotationY( obj )
      G = qclab.qgates.RotationY( obj.qubits, obj.angle );
    end
    
  end
end % RotationZ
