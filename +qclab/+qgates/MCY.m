%> @file MCY.m
%> @brief Implements MCY class
% ==============================================================================
%> @class MCY
%> @brief Multi-Controlled Pauli-Y gate.
%> 
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef MCY < qclab.qgates.QMultiControlledGate
  properties (Access = protected)
    %> Property storing the 1-qubit Pauli-Y gate of this multi-qubit controlled 
    %> gate.
    gate_(1,1)  qclab.qgates.PauliY
  end
  
  methods
    
    function obj = MCY(controls, target, controlStates)
      if nargin < 3, controlStates = ones(size(controls)) ; end
      obj@qclab.qgates.QMultiControlledGate(controls, controlStates );
      obj.gate_ = qclab.qgates.PauliY( target );
      
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( ~(any(controls(:) == target) ) ) ;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      out = -1;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false ;
      if isa(other,'qclab.qgates.MCY') && ...
         sum(obj.controlStates == other.controlStates) == ...
            length(obj.controlStates)
        bool = (sum(obj.controls < obj.target) == ...
                sum(other.controls < other.target)) && ...
               (sum(obj.controls > obj.target) == ...
                sum(other.controls > other.target)) ;
      end
    end
    
     % target
    function [target] = target(obj)
      target = obj.gate_.qubit ;
    end
    
    %> Copy of 1-qubit gate of multi-controlled-NOT gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
    % setTarget
    function setTarget(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      controls = obj.controls() ;
      assert( ~(any(controls(:) == target) ) ) ;
      obj.gate_.setQubit( target );
    end
    
     % label for draw function
    function [label] = label(obj, parameter)
      if nargin < 2, parameter = 'N'; end
      label = obj.gate_.label( parameter );
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
  
end