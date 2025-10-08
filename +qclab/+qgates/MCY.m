% MCY - Multi-Controlled Pauli-Y gate
% The MCY class implements a multi-controlled Pauli-Y gate. It applies a
% Pauli-Y operation to the target qubit if all control qubits are in the
% specified control states.
%
% Creation
%   Syntax
%     G = qclab.qgates.MCY(controls, target)
%       - Creates an MCY gate with control qubits `controls` (array of indices)
%         and a target qubit `target`. All control states default to 1.
%
%     G = qclab.qgates.MCY(controls, target, controlStates)
%       - Creates an MCY gate with control qubits `controls`, target qubit `target`,
%         and an array `controlStates` of the same length as `controls` with values
%         0 or 1 indicating the required control state for each control qubit.
%
% Input Arguments
%     controls       - Array of non-negative integers specifying control qubits
%     target         - Non-negative integer specifying the target qubit
%     controlStates  - Binary array (0 or 1) specifying control states
%                      for each control qubit (default: all 1)
%
% Output
%     G - A quantum object of type `MCY`, representing the multi-controlled
%         Pauli-Y gate acting on the specified qubits.
%
% Examples:
%   Create a 2-control MCY gate with controls 1 and 2, target 3:
%     G = qclab.qgates.MCY([1, 2], 3);
%
%   Create an MCY gate where qubit 0 must be |0⟩ and qubit 1 must be |1⟩:
%     G = qclab.qgates.MCY([0, 1], 2, [0, 1]);

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
        bool = (sum(obj.controls < obj.targets) == ...
                sum(other.controls < other.targets)) && ...
               (sum(obj.controls > obj.targets) == ...
                sum(other.controls > other.targets)) ;
      end
    end
    
     % targets
    function [targets] = targets(obj)
      targets = obj.gate_.qubit ;
    end
    
    % setTargets
    function setTargets(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      controls = obj.controls() ;
      assert( ~(any(controls(:) == target) ) ) ;
      obj.gate_.setQubit( target );
    end

    %> Copy of 1-qubit gate of multi-controlled-PauliY gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      label = obj.gate_.label( parameter, tex );
    end
    
    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( length(qubits) == length(unique(qubits)) );
      obj.controls_ = sort(qubits(1:end-1)) ;
      obj.setTargets( qubits(end) ) ;
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