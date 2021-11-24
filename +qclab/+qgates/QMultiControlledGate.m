%> @file QMultiControlledGate.m
%> @brief Implements QMultiControlledGate class
% ==============================================================================
%> @class QMultiControlledGate
%> @brief Base class for multi-qubit gates of multi-controlled 1-qubit gates.
%
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QMultiControlledGate < qclab.QObject
  
  properties (Access = protected)
    %> Control qubits of this multi-qubit gate.
    controls_ int32
    %> Control states of this multi-qubit gate.
    controlStates_ int32
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for  multi-qubit gates of multi-controlled 1-qubit 
    %> gates.
    %>
    %> Constructs a multi-qubit gate with the given control qubit `qubit` on the 
    %> control state `controlState`. The default control state is 1.
    %>
    %> @param control control qubit index
    %> @param controlState (optional) control state for controlled gate: 0 or 1
    % ==========================================================================
    function obj = QMultiControlledGate(controls, controlStates)
      if nargin < 2, controlStates = ones(size(controls)); end
      assert( length(controls) == length(unique(controls)) );
      assert( length(controls) == length(controlStates) ) ;
      unique_States = sort(unique(controlStates)) ;
      assert(length(unique_States) == 1 || length(unique_States) == 2) ;
      if length(unique_States) == 1
        assert( unique_States == 0 || unique_States == 1 ) ;
      else
        assert( unique_States(1) == 0 && unique_States(2) == 1 ) ;
      end
      
      [obj.controls_,sortIdx] = sort(controls) ;
      obj.controlStates_ = controlStates(sortIdx) ;
      
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = min([obj.controls_, obj.target]) ;
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = [obj.controls_, obj.target];
    end
    
    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( length(qubits) == length(unique(qubits)) );
      obj.controls_ = sort(qubits(1:end-1)) ;
      obj.setTarget( qubits(end) ) ;
    end
    
    % nbQubits
    function [nbQubits] = nbQubits(obj)
      nbQubits = int32(length(obj.controls_) + 1) ;
    end
    
    % matrix
    function [mat] = matrix(obj)
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1); gate_mat = obj.gate.matrix;
      target_idx = find(obj.controls_ > obj.target, 1);
      if isempty(target_idx)
        target_idx = length(obj.controls_) + 1;
      end
      Cup = 1;
      for i = 1:target_idx-1
        if obj.controlStates_(i) == 0
          Cup = kron(Cup, E0); % TODO: double check order.
        else
          Cup = kron(Cup, E1);
        end
      end
      Cdown = 1;
      for i = target_idx:length(obj.controls_)
       if obj.controlStates_(i) == 0
          Cdown = kron(Cdown, E0);
        else
          Cdown = kron(Cdown, E1);
       end          
      end
      if size(Cup,1) > 1
        ICup = eye(size(Cup)) - Cup;
      else
        ICup = 1;
      end
      if size(Cdown,1) > 1
        ICdown = eye(size(Cdown)) - Cdown;
      else
        ICdown = 1;
      end
      if size(Cup,1) == 1 
        mat = kron(gate_mat,Cdown) + ...
              kron(I1,ICdown) ;
      elseif size(Cdown,1) == 1
        mat = kron(Cup,gate_mat) + ...
              kron(ICup,I1) ;
      else
        mat = kron(kron(Cup,gate_mat),Cdown) + ...
              kron(kron(Cup,I1),ICdown) + ...
              kron(kron(ICup,I1),Cdown) + ...
              kron(kron(ICup,I1),ICdown) ;
      end
    end
    
    % ==========================================================================
    %> @brief Apply the QMultiControlledGate to a matrix `mat`
    %>
    %> @param obj instance of QMultiControlledGate class.
    %> @param side 'L' or 'R' for respectively left or right side of application
    %>              (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of QMultiControlledGate
    %> @param nbQubits qubit size of `mat`
    %> @param mat matrix to which QMultiControlledGate is applied
    %> @param offset offset applied to qubits
    % ==========================================================================
    function [mat] = apply(obj, side, op, nbQubits, mat, offset)
      if nargin == 5, offset = 0; end
      controls = obj.controls + offset ;
      target = obj.target + offset ;
      minq = min([controls(1), target]);
      maxq = max([controls(end), target]);
      assert( nbQubits > maxq );
      if strcmp(side,'L')
        assert( size(mat,2) == 2^nbQubits );
      else
        assert( size(mat,1) == 2^nbQubits );
      end
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1);
      % operation
      if strcmp(op, 'N') % normal
        mat1 = obj.gate.matrix;
      elseif strcmp(op, 'T') % transpose
        mat1 = obj.gate.matrix.';
      else % conjugate transpose
        mat1 = obj.gate.matrix';
      end
      target_idx = find(controls > target, 1);
      if isempty(target_idx)
        target_idx = length(controls) + 1;
      end
      
      % (I)Controls up
      Cup = 1; ICup = 1; Sup = 1;
      c_idx = 1;
      if target_idx > 1
        for i = controls(1):controls(target_idx-1)
          if i == controls(c_idx)
            if obj.controlStates_(c_idx) == 0
              Cup = kron(Cup, E0);
            else
              Cup = kron(Cup, E1);
            end
            c_idx = c_idx + 1 ;
          else
            Cup = kron(Cup, I1);
          end
        end
        ICup = qclab.qId(log2(size(Cup,1))) - Cup;
        Sup = qclab.qId(target - controls(target_idx-1) - 1) ;
      end
      % (I)Controls down
      Cdown = 1; ICdown = 1; Sdown = 1;
      if target_idx <= length(controls)
        for i = controls(target_idx):controls(end)
          if i == controls(c_idx)
            if obj.controlStates_(c_idx) == 0
              Cdown = kron(Cdown, E0);
            else
              Cdown = kron(Cdown, E1);
            end
            c_idx = c_idx + 1 ;
          else
            Cdown = kron(Cdown, I1);
          end
        end
         ICdown = qclab.qId(log2(size(Cdown,1))) - Cdown;
         Sdown = qclab.qId(controls(target_idx) - target - 1);
      end
      if size(Cup,1) == 1
        mats = kron(mat1,kron(Sdown,Cdown)) + ...
               kron(I1,kron(Sdown,ICdown)) ;
      elseif size(Cdown,1) == 1
        mats = kron(Cup,kron(Sup,mat1)) + ...
               kron(ICup,kron(Sup,I1)) ;
      else
        mats = kron(Cup,kron(Sup,kron(mat1,kron(Sdown,Cdown)))) + ...
               kron(Cup,kron(Sup,kron(I1,kron(Sdown,ICdown)))) + ...
               kron(ICup,kron(Sup,kron(I1,kron(Sdown,Cdown)))) + ...
               kron(ICup,kron(Sup,kron(I1,kron(Sdown,ICdown)))) ;
      end
      s = log2(size(mats,1));

      if ( minq == 0 && maxq == nbQubits - 1)
        matn = mats ;
      elseif minq == 0
        matn = kron(mats, qclab.qId(nbQubits - s));
      elseif maxq == nbQubits - 1
        matn = kron(qclab.qId(nbQubits - s), mats);
      else
        matn = kron(qclab.qId(minq), kron(mats, ...
                    qclab.qId(nbQubits - maxq - 1))) ;
      end  
       % side
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
    
     %> @brief Returns the control qubits of this multi-qubit gate.
    function [controls] = controls(obj)
      controls = obj.controls_ ;
    end
    
    %> @brief Returns the control states of this multi-qubit gate.
    function [controlStates] = controlStates(obj)
      controlStates = obj.controlStates_ ;
    end
    
    %> @brief Sets the controls of this multi-controlled gate to the given 
    %> `controls`.
    function setControls(obj, controls )
      assert( qclab.isNonNegIntegerArray(controls) ) ; 
      assert( length(controls) == length(obj.controlStates_) ) ;
      assert( length(controls) == length(unique(controls)) );
      assert( ~(any(controls(:) == obj.target) ) ) ;
      [obj.controls_,sortIdx] = sort(controls) ;
      obj.controlStates_ = obj.controlStates_(sortIdx) ;
    end
    
    %> @brief Sets the control states of this multi-controlled gate to 
    %> `controlState`.
    function setControlStates(obj, controlStates)
      assert( length(obj.controls_) == length(controlStates) ) ;
      unique_States = sort(unique(controlStates)) ;
      assert(length(unique_States) == 1 || length(unique_States) == 2) ;
      if length(unique_States) == 1
        assert( unique_States == 0 || unique_States == 1 ) ;
      else
        assert( unique_States(1) == 0 && unique_States(2) == 1 ) ;
      end
      obj.controlStates_ = controlStates ;
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = copy( obj );
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
      label = obj.label( parameter );
      width = length( label );
      if mod(width, 2) == 0
        width = width + 1; 
        label = [label space];
      end
      hwidth = floor( width/2 );
      cellRow = 1; controlIdx = 1;      
      % upper part (if any)
      if target_idx > 1
        % first control down
        gateCell{3*cellRow-2} = repmat(space, 1, width + 3);
        if obj.controlStates_(controlIdx) == 0  
          gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrlo, ...
                              repmat(h, 1, width - hwidth) ];
        else
          gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrl, ...
                              repmat(h, 1, width - hwidth) ];
        end
        gateCell{3*cellRow} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
        cellRow = cellRow + 1 ;
        controlIdx = controlIdx + 1 ;
        % other controls up & down (if any)
        for i = controls(1)+1:controls(target_idx-1)
          gateCell{3*cellRow-2} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          if i == controls(controlIdx) % it is a controlled node
            if obj.controlStates_(controlIdx) == 0
              gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrlo, ...
                              repmat(h, 1, width - hwidth) ];              
            else
              gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrl, ...
                              repmat(h, 1, width - hwidth) ];
            end
            controlIdx = controlIdx + 1 ;
          else % not a controlled node
            gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), vh, ...
                              repmat(h, 1, width - hwidth) ];
          end
          gateCell{3*cellRow} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          cellRow = cellRow + 1 ;
        end
        % connect to gate
        for i = controls(target_idx-1)+1:target-1
           gateCell{3*cellRow-2} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
           gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), vh, ...
                              repmat(h, 1, width - hwidth) ];
           gateCell{3*cellRow} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          cellRow = cellRow + 1 ;             
        end
        % draw top part of gate
        gateCell{3*cellRow-2} = [ space, ulc, repmat(h, 1, hwidth), hu, ...
                            repmat(h, 1, width - hwidth - 1 ), urc ];
      else % top part of gate
        gateCell{3*cellRow-2} = [ space, ulc, repmat(h, 1, width), urc ];
      end
      
      % middle part of gate
      gateCell{3*cellRow-1} = [ h, vl, label, vr ];
      
      % lower part
      if target_idx <= length(controls)
        % bottom part of gate
        gateCell{3*cellRow} = [ space, blc, repmat(h, 1, hwidth), hb, ...
                            repmat(h, 1, width - hwidth - 1), brc ];
        cellRow = cellRow + 1 ;
        % connect to next control
        for i = target+1:controls(target_idx)-1
          gateCell{3*cellRow-2} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), vh, ...
                              repmat(h, 1, width - hwidth) ];
          gateCell{3*cellRow} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          cellRow = cellRow + 1 ;         
        end
        % down-middle controls (if any)
        for i = controls(target_idx):controls(end)-1
          gateCell{3*cellRow-2} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          if i == controls(controlIdx) % it is a controlled node
            if obj.controlStates_(controlIdx) == 0
              gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrlo, ...
                              repmat(h, 1, width - hwidth) ];              
            else
              gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrl, ...
                              repmat(h, 1, width - hwidth) ];
            end
            controlIdx = controlIdx + 1 ;
          else % not a controlled node
            gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), vh, ...
                              repmat(h, 1, width - hwidth) ];
          end
          gateCell{3*cellRow} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
          cellRow = cellRow + 1 ;
        end
        % final control up
        gateCell{3*cellRow-2} = [ repmat(space, 1, hwidth + 2), v, ...
                              repmat(space, 1, width - hwidth) ];
        if obj.controlStates_(controlIdx) == 0  
          gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrlo, ...
                              repmat(h, 1, width - hwidth) ];
        else
          gateCell{3*cellRow-1} = [ repmat(h, 1, hwidth + 2), ctrl, ...
                              repmat(h, 1, width - hwidth) ];
        end
        gateCell{3*cellRow} = repmat(space, 1, width + 3);       
      else
        % bottom part of gate
        gateCell{3*cellRow} = [ space, blc, repmat(h, 1, width), brc ];
      end
      
      if fid > 0
        qubits = (minq:maxq) + offset;
        qclab.drawCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell ;
      end
      
    end
    
    % ==========================================================================
    %> @brief Save a multi-qubit gate of a multi-controlled 1-qubit gate to TeX
    %> file.
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
      label = obj.label( parameter, true );
      
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
      gateCell{cellRow} = ['&\t\\gate{', label,'}\t'] ;
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
    % setQubit
    function setQubit(~, ~)
      assert( false );
    end
    
    % controlled
    function [bool] = controlled
      bool = true ;
    end
  end
  
  methods (Abstract)
    %> @brief Returns a copy of the controlled 1-qubit gate of this multi-qubit gate.
    [gate] = gate(obj)
    %> @brief Returns the target qubit of this multi-qubit gate.
    [target] = target(obj) ;
    %> @brief Sets the target of this multi-controlled gate to the given `target`.
    setTarget(obj, target) ;
  end
end