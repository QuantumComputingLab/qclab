% MCMatrixGate - Multi-controlled matrix gate for quantum circuits
% The MCMatrixGate class implements a general multi-controlled quantum gate 
% with an arbitrary unitary matrix applied to a set of target qubits. The gate 
% is controlled by one or more qubits, and each control can be conditioned on 
% state |0⟩ or |1⟩.
%
% Creation
%   Syntax
%     G = qclab.qgates.MCMatrixGate(controls, targets, unitary)
%       - Creates a multi-controlled matrix gate with the given `controls` and 
%         `targets`, applying the specified unitary matrix. 
%          Control states default to 1.
%
%     G = qclab.qgates.MCMatrixGate(controls, targets, unitary, controlStates)
%       - Additionally specifies the control states (0 or 1) for each control 
%         qubit.
%
%     G = qclab.qgates.MCMatrixGate(controls, targets, unitary, label)
%       - Additionally specifies a label for the matrix gate. 
%         Control states default to 1.
%
%     G = qclab.qgates.MCMatrixGate(controls, targets, unitary, ...
%                                                      ... controlStates, label)
%       - Fully specifies control qubits and their states, the target qubits, 
%         the unitary matrix, and a label for display.
%
%   Input Arguments
%     controls       - vector of control qubit indices (non-negative integers)
%     targets        - vector of target qubit indices (non-negative integers)
%     unitary        - unitary matrix of size 2^n x 2^n, where n = length(targets)
%     controlStates  - vector of 0s and 1s, same length as `controls` 
%                      (default: all ones)
%     label          - string label used for visualization 
%                      (default: 'U')
%
%   Output
%     G - A quantum object of type `MCMatrixGate`, representing the multi-qubit 
%         gate acting on the specified target qubits, conditioned on the control 
%         qubits.
%
% Examples:
%   Create a 2-controlled gate applying a 2-qubit unitary to qubits 2 and 3:
%     U = eye(4);  % identity for example
%     G = qclab.qgates.MCMatrixGate([0 1], [2 3], U);
%
%   Create the same gate with custom control states and label:
%     G = qclab.qgates.MCMatrixGate([0 1], [2 3], U, [1 0], 'myGate');

%> @file MCMatrixGate.m
%> @brief Implements MCMatrixGate class
% ==============================================================================
%> @class MCMatrixGate
%> @brief Base class for multi-qubit gates of multi-controlled matrix gates.
%
%>
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================
classdef MCMatrixGate < qclab.qgates.QMultiControlledGate

  properties (Access = protected)
    %> Property storing the MatrixGate of this multi-qubit controlled
    %> gate.
    gate_(1,1)
  end

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for  multi-qubit gates of multi-controlled matrix
    %> gates.
    %>
    %> Constructs a multi-qubit gate with the given controls `controls` on the
    %> control state `controlStates`. The default control state is 1.
    %>
    %> @param control control qubit index
    %> @param controlState (optional) control state for controlled gate: 0 or 1
    % ==========================================================================
    function obj = MCMatrixGate(controls, targets, unitary, varargin)
      label = 'U' ;
      controlStates = ones(size(controls)) ;
      for k = 1:length(varargin)
        arg = varargin{k};
        if isnumeric(arg)
          controlStates = arg;
        elseif ischar(arg) 
          label = char(arg);
        end
      end
      obj@qclab.qgates.QMultiControlledGate(controls, controlStates );
      obj.gate_ = qclab.qgates.MatrixGate( targets, unitary, label );

      assert( qclab.isNonNegIntegerArray(targets) ) ;
      assert( isempty( intersect(controls, targets) )) ;
    end

    % equals
    function [bool] = equals(obj, other)
      bool = false ;
      if isa(other,'qclab.qgates.MCMatrixGate') && ...
         sum(obj.controlStates == other.controlStates) == ...
            length(obj.controlStates)
        bool = (sum(obj.controls < min(obj.targets)) == ...
                sum(other.controls < min(other.targets))) && ...
               (sum(obj.controls > max(obj.targets)) == ...
                sum(other.controls > max(other.targets))) ;
      end
    end

    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( length(qubits) == length(unique(qubits)) );
      nbControls = length(obj.controls_) ;
      obj.controls_ = sort(qubits(1:nbControls)) ;
      obj.setTargets( qubits(nbControls+1:end) ) ;
    end

    %> @brief Returns the target qubits of this multi-qubit gate.
    function [targets] = targets(obj)
      targets = obj.gate_.qubits ;
    end

    %> @brief Sets the target of this multi-controlled gate to the given `target`.
    function setTargets(obj, targets)
      assert( qclab.isNonNegIntegerArray(targets) ) ;
      controls = obj.controls() ;
      assert(isempty(intersect(controls, targets)), ...
        'Control and target qubits must be disjoint.') ;
      obj.gate_.setQubits( targets );
    end

    %> Copy of MatrixGate of multi controlled MatrixGate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      if nargin < 3, tex = false; end
      label = obj.gate_.label( parameter, tex );
    end

    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QMultiControlledGate( obj );
      objprime.gate_ = obj.gate_';
    end

    % fixed
    function [bool] = fixed(obj)
      bool = obj.gate_.fixed ;
    end

     % fixed
     function [mat] = unitary(obj)
      mat = obj.gate_.matrix ;
    end

  end


  methods (Static)
    % controlled
    function [bool] = controlled
      bool = true ;
    end

    % toQASM
    function toQASM(~, ~, ~)
      assert( false );
    end
  end

  methods ( Access = protected )
     %> Property groups
    function groups = getPropertyGroups(obj)
     import matlab.mixin.util.PropertyGroup
     props = struct();
     props.nbQubits = obj.nbQubits;  
     props.Controls = obj.controls;
     props.Targets = obj.targets;
     props.Unitary = obj.unitary;
     groups = PropertyGroup(props);
    end
  end 
end