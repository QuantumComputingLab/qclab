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
    %> Property storing the 1-qubit Pauli-X gate of this 2-qubit controlled gate.
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
    
    %> Copy of 1-qubit gate of controlled-NOT gate
    function [gate] = gate(obj)
      gate = copy(obj.gate_);
    end
    
      
    % setTarget
    function setTarget(obj, target)
      assert( qclab.isNonNegInteger(target) ) ; 
      assert( target ~= obj.control() ) ;
      obj.gate_.setQubit( target );
    end
    
    % ==========================================================================
    %> @brief draw a 2-qubit CNOT gate.
    %>
    %> @param obj 2-qubit CNOT gate
    %> @param fid  file id to draw to:
    %>              - 0  : return cell array with ascii characters as `out`
    %>              - 1  : draw to command window (default)
    %>              - >1 : draw to (open) file id
    %> @param parameter 'N' don't print parameter (default), 'S' print short 
    %>                  parameter, 'L' print long parameter.
    %> @param offset qubit offset. Default is 0.
    %>
    %> @retval out if fid > 0 then out == 0 on succesfull completion, otherwise
    %>             out contains a cell array with the drawing info.
    % ==========================================================================
    function [out] = draw(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qclab.drawCommands ; % load draw commands
      
      qubits = obj.qubits ;
      gateCell = cell( 3 * (qubits(2)-qubits(1)+1), 1 );
      
      % middle part
      for i = 4:3:length(gateCell)-3
        gateCell{i} = [ space, v ];
        gateCell{i+1} = [ h, vh ];
        gateCell{i+2} = [ space, v ];
      end       
      
      if obj.control < obj.target
        % draw control qubit
        if obj.controlState == 0
          gateCell{1} = [ space, space ];
          gateCell{2} = [ h, ctrlo ];
          gateCell{3} = [ space, v ];
        else
          gateCell{1} = [ space, space ];
          gateCell{2} = [ h, ctrl ];
          gateCell{3} = [ space, v ];
        end
        % draw gate
        gateCell{end-2} = [ space, v ];
        gateCell{end-1} = [ h, targ ];
        gateCell{end} =   [ space, space ];
      else
        % draw gate
        gateCell{1} = [ space, space ];
        gateCell{2} = [ h, targ ];
        gateCell{3} = [ space, v ];        
        % draw control qubit
        if obj.controlState == 0
          gateCell{end-2} = [ space, v ];
          gateCell{end-1} = [ h, ctrlo ];
          gateCell{end} =   [ space, space ];
        else
          gateCell{end-2} = [ space, v ];
          gateCell{end-1} = [ h, ctrl ];
          gateCell{end} =   [ space, space ];
        end
      end
      if fid > 0
        qubits = (qubits(1):qubits(2)) + offset;
        qclab.drawCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell ;
      end
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
  
end % CNOT
