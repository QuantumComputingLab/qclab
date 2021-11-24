%> @file MCX.m
%> @brief Implements MCX class
% ==============================================================================
%> @class MCX
%> @brief Multi-Controlled Pauli-X gate (multi-controlled NOT gate).
%> 
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef MCX < qclab.qgates.QMultiControlledGate
  properties (Access = protected)
    %> Property storing the 1-qubit Pauli-X gate of this multi-qubit controlled 
    %> gate.
    gate_(1,1)  qclab.qgates.PauliX
  end
  
  methods
    
    function obj = MCX(controls, target, controlStates)
      if nargin < 3, controlStates = ones(size(controls)) ; end
      obj@qclab.qgates.QMultiControlledGate(controls, controlStates );
      obj.gate_ = qclab.qgates.PauliX( target );
      
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
      if isa(other,'qclab.qgates.MCX') && ...
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
    
    
    % ==========================================================================
    %> @brief draw a multi-qubit gate of a multi-controlled 1-qubit gate.
    %>
    %> @param obj multi-qubit gate of a multi-controlled 1-qubit gate.
    %> @param fid  file id to draw to:
    %>              - 0 : return cell array with ascii characters as `out`
    %>              - 1 : draw to command window (default)
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
      
      controls = obj.controls ;
      target = obj.target ;
      minq = min([controls(1), target]);
      maxq = max([controls(end), target]);
      target_idx = find(controls > target, 1);
      if isempty(target_idx)
        target_idx = length(controls) + 1;
      end
      
      gateCell = cell( 3 * (maxq-minq+1), 1 );
      cellRow = 1; controlIdx = 1;      
      % upper part (if any)
      if target_idx > 1
        % first control down
        gateCell{3*cellRow-2} = [space, space];
        if obj.controlStates_(controlIdx) == 0  
          gateCell{3*cellRow-1} = [ h, ctrlo ];
        else
          gateCell{3*cellRow-1} = [ h, ctrl ];
        end
        gateCell{3*cellRow} = [ space, v, ];
        cellRow = cellRow + 1 ;
        controlIdx = controlIdx + 1 ;
        % other controls up & down (if any)
        for i = controls(1)+1:controls(target_idx-1)
          gateCell{3*cellRow-2} = [ space, v, ];
          if i == controls(controlIdx) % it is a controlled node
            if obj.controlStates_(controlIdx) == 0
              gateCell{3*cellRow-1} = [ h, ctrlo ];
            else
              gateCell{3*cellRow-1} = [ h, ctrl ];
            end
            controlIdx = controlIdx + 1 ;
          else % not a controlled node
            gateCell{3*cellRow-1} = [ h, vh];
          end
          gateCell{3*cellRow} = [ space, v];
          cellRow = cellRow + 1 ;
        end
        % connect to gate
        for i = controls(target_idx-1)+1:target-1
           gateCell{3*cellRow-2} = [ space, v];
           gateCell{3*cellRow-1} = [ h, vh];
           gateCell{3*cellRow} = [ space, v];
          cellRow = cellRow + 1 ;             
        end
        % draw top part of gate
        gateCell{3*cellRow-2} = [ space, v];
      else % top part of gate
        gateCell{3*cellRow-2} = [ space, space ];
      end
      
      % middle part of gate
      gateCell{3*cellRow-1} = [ h, targ ];
      
      % lower part
      if target_idx <= length(controls)
        % bottom part of gate
        gateCell{3*cellRow} = [ space, v];
        cellRow = cellRow + 1 ;
        % connect to next control
        for i = target+1:controls(target_idx)-1
          gateCell{3*cellRow-2} =  [ space, v];
          gateCell{3*cellRow-1} =  [ h, vh];
          gateCell{3*cellRow} =  [ space, v];
          cellRow = cellRow + 1 ;         
        end
        % down-middle controls (if any)
        for i = controls(target_idx):controls(end)-1
          gateCell{3*cellRow-2} =  [ space, v];
          if i == controls(controlIdx) % it is a controlled node
            if obj.controlStates_(controlIdx) == 0
              gateCell{3*cellRow-1} =  [ h, ctrlo];            
            else
              gateCell{3*cellRow-1} =  [ h, ctrl];
            end
            controlIdx = controlIdx + 1 ;
          else % not a controlled node
            gateCell{3*cellRow-1} = [ h, vh];
          end
          gateCell{3*cellRow} = [ space, v];
          cellRow = cellRow + 1 ;
        end
        % final control up
        gateCell{3*cellRow-2} = [ space, v];
        if obj.controlStates_(controlIdx) == 0  
          gateCell{3*cellRow-1} = [ h, ctrlo];  
        else
          gateCell{3*cellRow-1} = [ h, ctrl];  
        end
        gateCell{3*cellRow} = [space,space];       
      else
        % bottom part of gate
        gateCell{3*cellRow} = [ space, space ];
      end
      if fid > 0
        qubits = (minq:maxq) + offset;
        qclab.drawCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell ;
      end
      
    end
    
        % TODO: doc
    function [out] = toTex(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      controls = obj.controls ;
      target = obj.target ;
      minq = min([controls(1), target]);
      maxq = max([controls(end), target]);
      target_idx = find(controls > target, 1);
      if isempty(target_idx)
        target_idx = length(controls) + 1;
      end
      
      gateCell = cell( maxq-minq+1, 1 );
      
      % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      cellRow = 1; controlIdx = 1;      
      % upper part (if any)
      if target_idx > 1
        for i = controls(1):controls(target_idx-1)
          if i == controls(controlIdx) % it is a controlled node
            if controlIdx < target_idx - 1
              diffq = controls(controlIdx+1) - controls(controlIdx) ;
            else
              diffq = target - controls(controlIdx) ;
            end
            
            if obj.controlStates_(controlIdx) == 0
              gateCell{cellRow} = ['&\t\\ctrlo{', num2str(diffq), '}\t'] ;
            else
              gateCell{cellRow} = ['&\t\\ctrl{', num2str(diffq), '}\t'] ;
            end
            controlIdx = controlIdx + 1 ;
          else
            gateCell{cellRow} = '&\t\\qw\t' ;
          end
          cellRow = cellRow + 1 ;        
        end
        % connect to gate
        for i = controls(target_idx-1)+1:target-1
          gateCell{cellRow} = '&\t\\qw\t' ;
          cellRow = cellRow + 1 ;             
        end
      end
      % gate
      gateCell{cellRow} = '&\t\\targ\t' ;
      cellRow = cellRow + 1 ;             
      % lower part (if any)
      if target_idx <= length(controls)
        % connect to next control
        for i = target+1:controls(target_idx)-1
          gateCell{cellRow} = '&\t\\qw\t' ;
          cellRow = cellRow + 1 ;         
        end
        % lower controls
        for i = controls(target_idx):controls(end)
           if i == controls(controlIdx) % it is a controlled node
            if controlIdx == target_idx
              diffq = target - controls(controlIdx) ;
            else
              diffq = controls(controlIdx-1) - controls(controlIdx) ; 
            end
            if obj.controlStates_(controlIdx) == 0
              gateCell{cellRow} = ['&\t\\ctrlo{', num2str(diffq), '}\t'] ;
            else
              gateCell{cellRow} = ['&\t\\ctrl{', num2str(diffq), '}\t'] ;
            end
            controlIdx = controlIdx + 1 ;
           else
             gateCell{cellRow} = '&\t\\qw\t' ;
           end
           cellRow = cellRow + 1 ; 
        end
      end
      % XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
      
      if fid > 0
        qubits = (minq:maxq) + offset;
        qclab.toTexCellArray( fid, gateCell, qubits );
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
  
end