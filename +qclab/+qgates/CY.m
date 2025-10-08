% CY - Controlled Pauli-Y gate
% The CY class implements a 2-qubit controlled-Y gate with a control qubit,
% target qubit, and optional control state (0 or 1).
%
% The matrix representation (in standard basis order) is:
%   If control < target and controlState = 1:
%     [ 1   0    0    0;
%       0   1    0    0;
%       0   0    0  -1i;
%       0   0  +1i    0 ]
%
% Creation
%   Syntax
%     G = qclab.qgates.CY()
%       - Creates a CY gate with control = 0, target = 1, and controlState = 1.
%
%     G = qclab.qgates.CY(control, target)
%       - Creates a CY gate with given control and target qubits,
%         using controlState = 1 by default.
%
%     G = qclab.qgates.CY(control, target, controlState)
%       - Creates a CY gate with given control and target qubits,
%         and the specified control state (0 or 1).
%
% Input Arguments
%     control        - Integer index of control qubit.
%     target         - Integer index of target qubit.
%     controlState   - (optional) Control state (0 or 1). Default: 1.
%
% Output
%     G - A quantum object of type `CY`, representing the controlled Pauli-Y gate.
%
% Examples:
%   CY gate with default parameters:
%     G = qclab.qgates.CY();
%
%   CY gate with control=1, target=3:
%     G = qclab.qgates.CY(1, 3);
%
%   CY gate triggered on controlState = 0:
%     G = qclab.qgates.CY(0, 2, 0);

%> @file CY.m
%> @brief Implements CY class
% ==============================================================================
%> @class CY
%> @brief Controlled Pauli-Y gate (CY).
%> 
%> 2-qubit CY gate with `default `matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0 & 0 & 0\\ 
%>                    0 & 1 & 0 & 0\\ 
%>                    0 & 0 & 0 & -i\\ 
%>                    0 & 0 & i & 0 \end{bmatrix}, \f]
%> if `control` < `target` and `controlState` = 1.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CY < qclab.qgates.QControlledGate2
  
  properties (Access = protected)
    %> Property storing the 1-qubit Pauli-Y gate of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.PauliY
  end
  
  methods
    
   % Class constructor  =======================================================
    %> @brief Constructor for  CY gates.
    %>
    %> Constructs a CY gate with given control qubit `control`,
    %> target qubit `target`, and control state `controlState`.
    %> The default control state is 1.
    %>
    %> @param control (optional) control qubit index, default = 0
    %> @param target (optional) target qubit index, default = 1
    %> @param controlState (optional) control state for controlled gate: 0 or 1,
    %>        default = 1
    % ==========================================================================
    function obj = CY(control, target, controlState)
      % set defaults
      if nargin < 1, control = 0; end
      if nargin < 2, target = 1; end
      if nargin < 3, controlState = 1; end
      obj@qclab.qgates.QControlledGate2(control, controlState );
      obj.gate_ = qclab.qgates.PauliY( target );
      
      assert( qclab.isNonNegInteger(target) ); 
      assert(control ~= obj.target) ;
      
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmCY( fid, obj.control + offset, obj.target + offset, ...
                       obj.controlState );
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CY') && ...
          (obj.controlState == other.controlState)
        bool = ((obj.control < obj.target) && (other.control < other.target))...
          || ((obj.control > obj.target) && (other.control > other.target)) ;
      end
    end
    
    % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    %> Copy of 1-qubit gate of controlled-Y gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
      
    % setTarget
    function setTarget(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( target ~= obj.control() ) ;
      obj.gate_.setQubit( target );
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      label = obj.gate_.label( parameter, tex );
    end
    
  end
  
  methods (Static)
    
    function [bool] = fixed
      bool = true;
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.gate_ = obj.gate() ;
    end
    
  end
  
end % CY
