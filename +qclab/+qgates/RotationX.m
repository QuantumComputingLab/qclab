% RotationX - 1-qubit rotation gate about the X axis
% The RotationX class implements a 1-qubit rotation gate around the X axis.
% This gate performs a rotation by an angle θ around the X axis of the Bloch
% sphere. 
%
% The matrix representation of the RotationX gate is:
%   R_x(θ) = [cos(θ/2)    -i*sin(θ/2);
%             -i*sin(θ/2)  cos(θ/2)]
%
% Creation
%   Syntax
%     RX = qclab.qgates.RotationX(qubit, theta)
%
%   Input Arguments
%     qubit - qubit to which the RotationX gate is applied
%             non-negative integer, (default: 0)
%     theta - rotation angle in radians
%
%   Output:
%     RX - A quantum object of type `RotationX`, representing the 1-qubit
%          rotation gate about the X axis on qubit `qubit` with rotation
%          angle `theta`.
%
% Example:
%   Create a RotationX gate object on qubit 0 with a rotation angle of π/2:
%     RX = qclab.qgates.RotationX(0, pi/2);

%> @file RotationX.m
%> @brief Implements RotationX class.
% ==============================================================================
%> @class RotationX
%> @brief 1-qubit rotation gate about the X axis.
%>
%> 1-qubit Pauli-X rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c   &  -is\\ 
%>                    -is & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationX < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos,     -1i*obj.sin; 
              -1i*obj.sin, obj.cos ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationX( fid, obj.qubit + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationX');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_x';    
      else
        label = 'RX';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert X rotation to Y rotation with same parameters
    function G = qclab.qgates.RotationY( obj )
      G = qclab.qgates.RotationY( obj.qubits, obj.angle );
    end
    
    %> convert X rotation to Z rotation with same parameters
    function G = qclab.qgates.RotationZ( obj )
      G = qclab.qgates.RotationZ( obj.qubits, obj.angle );
    end
    
  end
end % RotationX
