%> @file CZ.m
%> @brief Implements CZ class
% ==============================================================================
%> @class CZ
%> @brief Controlled Pauli-Z gate (CZ).
%> 
%> 2-qubit CZ gate with `default `matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0 & 0 & 0\\ 
%>                    0 & 1 & 0 & 0\\ 
%>                    0 & 0 & 1 & 0\\ 
%>                    0 & 0 & 0 & -1 \end{bmatrix}, \f]
%> if `control` < `target` and `controlState` = 1.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CZ < qclab.qgates.QControlledGate2
  
  properties (Access = protected)
    %> Property storing the 1-qubit Pauli-Z gate of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.PauliZ
  end
  
  methods
    
   % Class constructor  =======================================================
    %> @brief Constructor for  CZ gates.
    %>
    %> Constructs a CZ gate with given control qubit `control`,
    %> target qubit `target`, and control state `controlState`.
    %> The default control state is 1.
    %>
    %> @param control (optional) control qubit index, default = 0
    %> @param target (optional) target qubit index, default = 1
    %> @param controlState (optional) control state for controlled gate: 0 or 1,
    %>        default = 1
    % ==========================================================================
    function obj = CZ(control, target, controlState)
      % set defaults
      if nargin < 1, control = 0; end
      if nargin < 2, target = 1; end
      if nargin < 3, controlState = 1; end
      obj@qclab.qgates.QControlledGate2(control, controlState );
      obj.gate_ = qclab.qgates.PauliZ( target );
      
      assert( qclab.isNonNegInteger(target) ); 
      assert(control ~= obj.target) ;
      
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmCZ( fid, obj.control + offset, obj.target + offset, ...
                       obj.controlState );
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CZ') && ...
          (obj.controlState == other.controlState)
        bool = ((obj.control < obj.target) && (other.control < other.target))...
          || ((obj.control > obj.target) && (other.control > other.target)) ;
      end
    end
    
    % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    %> Copy of 1-qubit gate of controlled-Z gate
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
  
end % CZ
