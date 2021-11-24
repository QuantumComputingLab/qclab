%> @file RotationZZ.m
%> @brief Implements RotationZZ class.
% ==============================================================================
%> @class RotationZZ
%> @brief 2-qubit rotation gate about the ZZ axis.
%>
%> 2-qubit Pauli rotation about ZZ axis with matrix representation:
%>
%> \f[\begin{bmatrix} c - is  &         &         &  \\ 
%>                            & c + is  &         &  \\
%>                            &         & c + is  &  \\
%>                            &         &         & c - is \end{bmatrix},\f]
%> where \f$c = \cos(\theta/2), s = \sin(\theta/2)\f$.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef RotationZZ < qclab.qgates.QRotationGate2
  
  methods
    % matrix
    function [mat] = matrix(obj)
      c = obj.cos; s = 1i*obj.sin;
      mat = [c - s, 0,     0,     0;
             0,     c + s, 0,     0;
             0,     0,     c + s, 0;
             0,     0,     0,     c - s];
    end
    
    % toQASM
    function [out] = toQASM(obj,fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmRotationZZ( fid, obj.qubits + offset, obj.theta );
      out = 0;
    end
    
    % equalType
    function [bool] = equalType(~, other)
      bool = isa(other,'qclab.qgates.RotationZZ');
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      if tex
        label = 'R_{zz}';
      else
        label = 'RZZ';
      end
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f)'], obj.theta);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f)'], obj.theta);
      end
    end
    
    %> convert ZZ rotation to XX rotation with same parameters
    function G = qclab.qgates.RotationXX( obj )
      G = qclab.qgates.RotationXX( obj.qubits, obj.angle );
    end
    
    %> convert ZZ rotation to YY rotation with same parameters
    function G = qclab.qgates.RotationYY( obj )
      G = qclab.qgates.RotationYY( obj.qubits, obj.angle );
    end
    
    
  end
end % RotationZZ
