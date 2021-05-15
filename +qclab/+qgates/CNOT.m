%> @file CNOT.m
%> @brief Implements CNOT class
% ==============================================================================
%> @class CNOT
%> @brief Controlled NOT gate (CNOT).
%> 
%> 2-qubit CNOT gate with `default `matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0 & 0 & 0\\ 
%>                    0 & 1 & 0 & 0\\ 
%>                    0 & 0 & 0 & 1\\ 
%>                    0 & 0 & 1 & 0 \end{bmatrix}, \f]
%> if `control` < `target` and `controlState` = 1.
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef CNOT < qclab.qgates.QControlledGate2
  
  properties (Access = protected)
    %> Property storing the 1-qubit phase gate of this 2-qubit controlled gate.
    gate_(1,1)  qclab.qgates.PauliX
  end
  
  methods
    
   % Class constructor  =======================================================
    %> @brief Constructor for  CNOT gates.
    %>
    %> Constructs a CNOT gate with given control qubit `control`,
    %> target qubit `target`, and control state `controlState`.
    %> The default control state is 1.
    %>
    %> @param control (optional) control qubit index, default = 0
    %> @param target (optional) target qubit index, default = 1
    %> @param controlState (optional) control state for controlled gate: 0 or 1,
    %>        default = 1
    % ==========================================================================
    function obj = CNOT(control, target, controlState)
      % set defaults
      if nargin < 1, control = 0; end
      if nargin < 2, target = 1; end
      if nargin < 3, controlState = 1; end
      obj@qclab.qgates.QControlledGate2(control, controlState );
      obj.gate_ = qclab.qgates.PauliX( target );
      
      assert( qclab.isNonNegInteger(target) ); 
      assert(control ~= obj.target) ;
      
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      if (obj.controlState == 0)
        fprintf(fid, 'x q[%d];\n', obj.control + offset);
      end
      fprintf(fid,'cx q[%d], q[%d];\n', obj.control + offset, ...
          obj.target + offset);
      if (obj.controlState == 0)
        fprintf(fid, 'x q[%d];\n', obj.control + offset);
      end
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.CNOT') && ...
          (obj.controlState == other.controlState)
        bool = ((obj.control < obj.target) && (other.control < other.target))...
          || ((obj.control > obj.target) && (other.control > other.target)) ;
      end
    end
    
    % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    % gateCopy
    function [gate] = gateCopy(obj)
      gate = copy(obj.gate_);
    end
    
      
    % setTarget
    function setTarget(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( target ~= obj.control() ) ;
      obj.gate_.setQubit( target );
    end
  end
  
  methods (Static)
    function [bool] = fixed
      bool = true;
    end
  end
end % CNOT