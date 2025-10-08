%> @file QMultiControlledGate.m
%> @brief Implements QMultiControlledGate class
% ==============================================================================
%> @class QMultiControlledGate
%> @brief Base class for multi-qubit gates of multi-controlled gates, which
%> are defined on consecutive qubits
%
%>
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================
classdef QMultiControlledGate < qclab.QObject

  properties (Access = protected)
    %> Control qubits of this multi-qubit gate.
    controls_ int64
    %> Control states of this multi-qubit gate.
    controlStates_ int64
  end

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for  multi-qubit gates of multi-controlled
    %> gates.
    %>
    %> Constructs a multi-qubit gate with the given controls `controls` on the
    %> control state `controlStates`. The default control state is 1.
    %>
    %> @param controls control qubit index
    %> @param controlStates (optional) control states for multi controlled
    %> gate: 0 or 1
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
      qubit = min([obj.controls_, obj.targets]) ;
    end

    % qubits
    function [qubits] = qubits(obj)
      qubits = [obj.controls_, obj.targets];
    end

    % nbQubits
    function [nbQubits] = nbQubits(obj)
      nbQubits = int64(length(obj.controls_) + length(obj.targets)) ;
    end

    % matrix
    function [mat] = matrix(obj)
      isSparse = qclab.isSparse(obj.nbQubits) ;
      E0 = qclab.E0(isSparse); E1 = qclab.E1(isSparse);
      Itarget = qclab.qId(obj.gate.nbQubits, isSparse); gate_mat = obj.gate.matrix;
      target_idx = find(obj.controls_ > max(obj.targets), 1);
      if isempty(target_idx)
        target_idx = length(obj.controls_) + 1;
      end
      Cup = 1;
      for i = 1:target_idx-1
        if obj.controlStates_(i) == 0
          Cup = kron(Cup, E0);
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
          kron(Itarget,ICdown) ;
      elseif size(Cdown,1) == 1
        mat = kron(Cup,gate_mat) + ...
          kron(ICup,Itarget) ;
      else
        mat = kron(kron(Cup,gate_mat),Cdown) + ...
          kron(kron(Cup,Itarget),ICdown) + ...
          kron(kron(ICup,Itarget),Cdown) + ...
          kron(kron(ICup,Itarget),ICdown) ;
      end
    end

    % ==========================================================================
    %> @brief Apply the QMultiControlledGate to a matrix or a struct of
    %> state vectors
    %>
    %> @param obj instance of QMultiControlledGate class.
    %> @param side 'L' or 'R' for respectively left or right side of application
    %>              (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of QMultiControlledGate
    %> @param nbQubits qubit size of `current`
    %> @param current matrix or struct of state vectors to which
    %> QMultiControlledGate is applied
    %> @param offset offset applied to qubits
    % ==========================================================================
    function [current] = apply(obj, side, op, nbQubits, current, offset)
      if nargin == 5, offset = 0; end
      isSparse = qclab.isSparse(nbQubits) ;
      controls = obj.controls + offset ;
      targets = obj.targets + offset ;
      minq = min([controls(1), targets]);
      maxq = max([controls(end), targets]);
      targetStart = min(targets);
      targetEnd   = max(targets);
      assert( nbQubits > maxq );
      if isa(current, 'double')
        if strcmp(side,'L') % left
          assert( size(current,2) == 2^nbQubits);
        else % right
          assert( size(current,1) == 2^nbQubits);
        end
      else
        assert( length(current.states{1}) == 2^nbQubits )
      end
      E0 = qclab.E0(isSparse); E1 = qclab.E1(isSparse);
      I1 = qclab.qId(1,isSparse);
      Itarget = qclab.qId(obj.gate.nbQubits,isSparse);
      % operation
      if strcmp(op, 'N') % normal
        mat = obj.gate.matrix;
      elseif strcmp(op, 'T') % transpose
        mat = obj.gate.matrix.';
      else % conjugate transpose
        mat = obj.gate.matrix';
      end
      target_idx = find(controls > targetEnd, 1);
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
        ICup = qclab.qId(log2(size(Cup,1)),isSparse) - Cup;
        Sup = qclab.qId(targetStart - controls(target_idx-1) - 1,isSparse) ;
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
        ICdown = qclab.qId(log2(size(Cdown,1)),isSparse) - Cdown;
        Sdown = qclab.qId(controls(target_idx) - targetEnd - 1,isSparse);
      end
      if size(Cup,1) == 1
        mats = kron(mat,kron(Sdown,Cdown)) + ...
          kron(Itarget,kron(Sdown,ICdown)) ;
      elseif size(Cdown,1) == 1
        mats = kron(Cup,kron(Sup,mat)) + ...
          kron(ICup,kron(Sup,Itarget)) ;
      else
        mats = kron(Cup,kron(Sup,kron(mat,kron(Sdown,Cdown)))) + ...
          kron(Cup,kron(Sup,kron(Itarget,kron(Sdown,ICdown)))) + ...
          kron(ICup,kron(Sup,kron(Itarget,kron(Sdown,Cdown)))) + ...
          kron(ICup,kron(Sup,kron(Itarget,kron(Sdown,ICdown)))) ;
      end
      s = log2(size(mats,1));

      if ( minq == 0 && maxq == nbQubits - 1)
        matn = mats ;
      elseif minq == 0
        matn = kron(mats, qclab.qId(nbQubits - s,isSparse));
      elseif maxq == nbQubits - 1
        matn = kron(qclab.qId(nbQubits - s,isSparse), mats);
      else
        matn = kron(qclab.qId(minq, isSparse), kron(mats, ...
          qclab.qId(nbQubits - maxq - 1,isSparse))) ;
      end
      % apply
      current = qclab.applyGateTo( current, matn, side ) ;
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
      assert( ~(any(controls(:) == obj.targets) ) ) ;
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
    %> @brief draw a multi-qubit gate of a multi-controlled gate.
    %>
    %> @param obj multi-qubit gate of a multi-controlled gate.
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
    function [varargout] = draw(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qclab.drawCommands ; % load draw commands

      controls = obj.controls ;
      targets = obj.targets ;
      minq = min([controls(1), targets]);
      maxq = max([controls(end), targets]);
      targetStart = min(targets);
      targetEnd   = max(targets);
      target_idx = find(controls > targetEnd, 1);
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
        for i = controls(target_idx-1)+1:targetStart-1
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
        if obj.gate.nbQubits == 1
          gateCell{3*cellRow-1} = [ h, vl, label, vr ];
        end
        if obj.gate.nbQubits >= 2
          gateCell{3*cellRow-1} = [ h, vl, repmat(space, 1, width), vr ];
          gateCell{3*cellRow} = [ space, v, repmat(space, 1, width), v ];
          cellRow = cellRow + 1 ;
          if obj.gate.nbQubits > 2
            for k = 2:obj.gate.nbQubits-1
              gateCell{3*cellRow-2} = [ space, v, repmat(space, 1, width), v ];
              gateCell{3*cellRow-1} = [ h, vl, repmat(space, 1, width), vr ];
              gateCell{3*cellRow} = [ space, v, repmat(space, 1, width), v ];
              cellRow = cellRow + 1 ;
            end
          end
          gateCell{3*cellRow-2} = [ space, v, repmat(space, 1, width), v ];
          gateCell{3*cellRow-1} = [ h, vl, repmat(space, 1, width), vr];
          if mod(obj.gate.nbQubits,2) == 0
            gateCell{3*(cellRow) - 3*obj.gate.nbQubits/2} = [ space, v, label, v ];
          else
            gateCell{3*(cellRow)+1 - floor(3*obj.gate.nbQubits/2)} = [ h, vl, label, vr ];
          end
        end
        % lower part
        % bottom part of gate
        if target_idx <= length(controls)
          gateCell{3*cellRow} = [ space, blc, repmat(h, 1, hwidth), hb, ...
            repmat(h, 1, width - hwidth - 1), brc ];
          cellRow = cellRow + 1 ;
          % connect to next control
          for i = targetEnd+1:controls(target_idx)-1
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

        if nargout > 0
        varargout = {out};
        else
          varargout = {};
        end
    end

    % ==========================================================================
    %> @brief Save a multi-qubit gate of a multi-controlled gate to TeX
    %> file.
    %>
    %> @param obj multi-qubit gate of a multi-controlled gate.
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
      targets = obj.targets ;
      targetStart = min(targets);
      targetEnd   = max(targets);
      minq = min([controls(1), targets]);
      maxq = max([controls(end), targets]);
      target_idx = find(controls > targetEnd, 1);
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
              diffq = targetStart - controls(controlIdx) ;
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
        for i = controls(target_idx-1)+1:targetStart-1
          gateCell{cellRow} = '&\t\\qw\t' ;
          cellRow = cellRow + 1 ;
        end
      end
      % gate
      if obj.gate.nbQubits == 1
        gateCell{cellRow} = ['&\t\\gate{\\mathrm{', label,'}}\t'] ;
        cellRow = cellRow + 1 ;
      else
        gateCell{cellRow} = ['&\t\\multigate{' int2str(obj.gate.nbQubits-1) '}' ...
        '{\\mathrm{', label,'}}\t'] ;
      cellRow = cellRow + 1 ;
      for i = 2:obj.gate.nbQubits
        gateCell{cellRow} = ['&\t\\ghost{\\mathrm{', label,'}}\t'] ;
        cellRow = cellRow + 1 ;
      end
      end
      % lower part (if any)
      if target_idx <= length(controls)
        % connect to next control
        for i = targetEnd+1:controls(target_idx)-1
          gateCell{cellRow} = '&\t\\qw\t' ;
          cellRow = cellRow + 1 ;
        end
        % lower controls
        for i = controls(target_idx):controls(end)
          if i == controls(controlIdx) % it is a controlled node
            if controlIdx == target_idx
              diffq = targetEnd - controls(controlIdx) ;
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

    % setQubits
    function setQubits(~, ~)
      assert( false );
    end

    % controlled
    function [bool] = controlled
      bool = true ;
    end
  end

  methods (Abstract)
    %> @brief Returns a copy of the controlled gate of this multi-qubit gate.
    [gate] = gate(obj)
    %> @brief Returns the target qubits of this multi-qubit gate.
    [targets] = targets(obj) ;
    %> @brief Sets the targets of this multi-controlled gate to the given `targets`.
    setTargets(obj, targets) ;
  end

  methods (Access = protected)
    %> Property groups
    function groups = getPropertyGroups(obj)
      import matlab.mixin.util.PropertyGroup
      props = struct();
      props.nbQubits = obj.nbQubits;
      if length(obj.controls) == 1
      props.Control = obj.controls;
      else
      props.Controls = obj.controls;
      end
      if length(obj.targets) == 1
        props.Target = obj.targets;
      else
        props.Targets = obj.targets;
      end
     
      groups = PropertyGroup(props);
    end
  end
end