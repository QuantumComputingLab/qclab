% RotationY - 1-qubit rotation gate about the Y axis
% The RotationY class implements a 1-qubit rotation gate that performs a
% rotation by an angle θ around the Y axis of the Bloch sphere.
%
% The matrix representation of the RotationY gate is:
%   Ry(θ) = [cos(θ/2)   -sin(θ/2);
%            sin(θ/2)    cos(θ/2)]
%
% Creation
%   Syntax:
%     RY = qclab.qgates.RotationY()
%       - Default constructor. Constructs an adjustable Y-rotation gate on
%         qubit 0 with θ = 0.
%
%     RY = qclab.qgates.RotationY(qubit)
%       - Constructs an adjustable Y-rotation gate on the specified `qubit`
%         with θ = 0.
%
%     RY = qclab.qgates.RotationY(qubit, theta)
%       - Constructs an adjustable Y-rotation gate on `qubit` with rotation
%         angle `theta` (in radians).
%
%     RY = qclab.qgates.RotationY(qubit, theta, fixed)
%       - Constructs a Y-rotation gate with the given angle `theta` and
%         optional logical flag `fixed`. Set `fixed` to true for a
%         non-adjustable gate.
%
%     RY = qclab.qgates.RotationY(qubit, angle, fixed)
%       - Constructs a Y-rotation gate using a QAngle object `angle`.
%
%     RY = qclab.qgates.RotationY(qubit, cos_theta, sin_theta, fixed)
%       - Constructs a Y-rotation gate from trigonometric values of θ/2:
%         `cos_theta = cos(θ/2)`, `sin_theta = sin(θ/2)`
%
% Input Arguments:
%     qubit      - Target qubit (non-negative integer, default: 0)
%     theta      - Rotation angle in radians
%     angle      - QAngle object
%     cos_theta  - Cosine of θ/2
%     sin_theta  - Sine of θ/2
%     fixed      - Logical flag indicating whether the gate is adjustable 
%                  (default: false)
%
% Output:
%     RY - A quantum object of type `RotationY`, representing the 1-qubit
%          rotation gate about the Y axis applied to the specified qubit.
%
% Examples:
%   Create a default Y-rotation gate:
%     RY = qclab.qgates.RotationY();
%
%   Create a RotationY gate on qubit 0 with θ = π/2:
%     RY = qclab.qgates.RotationY(0, pi/2);
%
%   Create a non-adjustable RotationY gate using cosine and sine:
%     RY = qclab.qgates.RotationY(1, cos(pi/4), sin(pi/4), true);


%> @file RotationY.m
%> @brief Implements RotationY class.
% ==============================================================================
%> @class RotationY
%> @brief 1-qubit rotation gate about the Y axis.
%>
%> 1-qubit Pauli-Y rotation gate with matrix representation:
%>
%> \f[\begin{bmatrix} c   &  -s\\ 
%>                    s & c \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationY < qclab.qgates.QRotationGate1
  
  methods
    
    % matrix
    function [mat] = matrix(obj)
      mat = [ obj.cos, -obj.sin; 
              obj.sin,  obj.cos ]; 
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationY( fid, obj.qubit + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationY');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_y';
      else
        label = 'RY';        
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert Y rotation to X rotation with same parameters
    function G = qclab.qgates.RotationX( obj )
      G = qclab.qgates.RotationX( obj.qubits, obj.angle );
    end
    
    %> convert Y rotation to Z rotation with same parameters
    function G = qclab.qgates.RotationZ( obj )
      G = qclab.qgates.RotationZ( obj.qubits, obj.angle );
    end
    
  end
end % RotationY
