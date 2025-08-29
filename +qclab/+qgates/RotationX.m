% RotationX - 1-qubit rotation gate about the X axis
% The RotationX class implements a 1-qubit rotation gate that performs a
% rotation by an angle θ around the X axis of the Bloch sphere.
%
% The matrix representation of the RotationX gate is:
%   Rx(θ) = [cos(θ/2)    -i·sin(θ/2);
%            -i·sin(θ/2)  cos(θ/2)]
%
% Creation
%   Syntax:
%     RX = qclab.qgates.RotationX()
%       - Default constructor. Constructs an adjustable X-rotation gate on
%         qubit 0 with θ = 0.
%
%     RX = qclab.qgates.RotationX(qubit)
%       - Constructs an adjustable X-rotation gate on the specified `qubit`
%         with θ = 0.
%
%     RX = qclab.qgates.RotationX(qubit, theta)
%       - Constructs an adjustable X-rotation gate on `qubit` with rotation
%         angle `theta` (in radians).
%
%     RX = qclab.qgates.RotationX(qubit, theta, fixed)
%       - Constructs an X-rotation gate with the given angle `theta` and
%         optional logical flag `fixed`. Set `fixed` to true for a
%         non-adjustable gate.
%
%     RX = qclab.qgates.RotationX(qubit, angle, fixed)
%       - Constructs an X-rotation gate using a QAngle object `angle`.
%
%     RX = qclab.qgates.RotationX(qubit, cos_theta, sin_theta, fixed)
%       - Constructs an X-rotation gate from trigonometric values of θ/2:
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
%     RX - A quantum object of type `RotationX`, representing the 1-qubit
%          rotation gate about the X axis applied to the specified qubit.
%
% Examples:
%   Create a default X-rotation gate:
%     RX = qclab.qgates.RotationX();
%
%   Create a RotationX gate on qubit 0 with θ = π/2:
%     RX = qclab.qgates.RotationX(0, pi/2);
%
%   Create a non-adjustable RotationX gate using cosine and sine:
%     RX = qclab.qgates.RotationX(1, cos(pi/4), sin(pi/4), true);

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
