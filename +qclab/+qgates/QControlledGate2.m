%> @file QControlledGate2.m
%> @brief Implements QControlledGate2 class
% ==============================================================================
%> @class QControlledGate2
%> @brief Base class for 2-qubit gates of controlled 1-qubit gates.
%
%>
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================
classdef QControlledGate2 < qclab.qgates.QGate2
  properties (Access = protected)
    %> Control qubit of this 2-qubit gate.
    control_(1,1) int64
    %> Control state of this 2-qubit gate.
    controlState_(1,1) int64
  end

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for  2-qubit gates of controlled 1-qubit gates.
    %>
    %> Constructs a 2-qubit gate with the given control qubit `control` on the
    %> control state `controlState`. The default control state is 1.
    %>
    %> @param control control qubit index
    %> @param controlState (optional) control state for controlled gate: 0 or 1
    % ==========================================================================
    function obj = QControlledGate2(control, controlState)
      if nargin < 2, controlState = 1; end

      obj.control_ = control ;
      obj.controlState_ = controlState;

      assert( qclab.isNonNegInteger(control) );
      assert((controlState == 0) || (controlState == 1)) ;
    end

    % qubit
    function [qubit] = qubit(obj)
      qubit = min(obj.control_, obj.target) ;
    end

    % qubits
    function [qubits] = qubits(obj)
      qubits = sort([obj.control_, obj.target]);
    end

    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( qubits(1) ~= qubits(2) ) ;
      obj.control_ = qubits(1) ;
      obj.setTarget( qubits(2) ) ;
    end

    % matrix
    function [mat] = matrix(obj)
      E0 = [1 0; 0 0]; E1 = [0 0; 0 1];
      I1 = qclab.qId(1);
      CG = obj.gate.matrix;
      if ( obj.controlState_ == 0 )
        if (obj.control_ < obj.target)
          mat = kron(E0, CG) + kron(E1, I1);
        else
          mat = kron(CG, E0) + kron(I1, E1);
        end
      else
        if (obj.control_ < obj.target)
          mat = kron(E0, I1) + kron(E1, CG);
        else
          mat = kron(I1, E0) + kron(CG, E1);
        end
      end
    end

    % ==========================================================================
    %> @brief Apply the QControlledGate2 to a matrix or a struct of state
    %> vectors
    %> @param obj instance of QControlledGate2 class.
    %> @param side 'L' or 'R' for respectively left or right side of application
    %>              (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of QControlledGate2
    %> @param nbQubits qubit size of `current`
    %> @param current matrix or struct of state vectors to which
    %> QControlledGate2 is applied
    %> @param offset offset applied to qubits
    % ==========================================================================
    function [current] = apply(obj, side, op, nbQubits, current, offset)
      if nargin == 5, offset = 0; end
      isSparse = qclab.isSparse(nbQubits) ;
      assert( nbQubits >= 2 );
      if isa(current, 'double')
        if strcmp(side,'L') % left
          assert( size(current,2) == 2^nbQubits);
        else % right
          assert( size(current,1) == 2^nbQubits);
        end
      else
        assert( length(current.states{1}) == 2^nbQubits )
      end
      qubits = obj.qubits + offset;
      assert( qubits(1) < nbQubits ); assert( qubits(2) < nbQubits );
      % nearest neighbor qubits
      if qubits(1) + 1 == qubits(2)
        current = apply@qclab.qgates.QGate2( obj, side, op, nbQubits, ...
          current, offset );
        return
      end
      E0 = qclab.E0(isSparse); E1 = qclab.E1(isSparse);
      I1 = qclab.qId(1,isSparse);
      % operation
      if strcmp(op, 'N') % normal
        mat1 = obj.gate.matrix;
      elseif strcmp(op, 'T') % transpose
        mat1 = obj.gate.matrix.';
      else % conjugate transpose
        mat1 = obj.gate.matrix';
      end
      % linear combination of Kronecker products
      s = qubits(2) - qubits(1) + 1;
      Imid =  qclab.qId(s-2, isSparse);
      if obj.controlState_ == 0
        if (obj.control_ < obj.target)
          mats = kron(kron(E0, Imid), mat1) + kron(kron(E1, Imid), I1) ;
        else
          mats = kron(kron(mat1, Imid), E0) + kron(kron(I1, Imid), E1) ;
        end
      else
        if (obj.control_ < obj.target)
          mats = kron(kron(E0, Imid), I1) + kron(kron(E1, Imid), mat1) ;
        else
          mats = kron(kron(I1, Imid), E0) + kron(kron(mat1, Imid), E1) ;
        end
      end
      % kron(Ileft, mats, Iright)
      if ( qubits(1) == 0 && qubits(2) == nbQubits - 1)
        matn = mats;
      elseif ( qubits(1) == 0 )
        matn = kron(mats, qclab.qId(nbQubits - s, isSparse));
      elseif ( qubits(2) == nbQubits - 1 )
        matn = kron(qclab.qId(nbQubits - s, isSparse), mats);
      else
        matn = kron(kron(qclab.qId(qubits(1), isSparse),mats),...
          qclab.qId(nbQubits - qubits(2) - 1, isSparse));
      end
      % apply
      current = qclab.applyGateTo(current, matn, side ) ;
    end

    %> @brief Returns the control qubit of this 2-qubit gate.
    function [control] = control(obj)
      control = obj.control_ ;
    end

    %> @brief Returns the control state of this 2-qubit gate.
    function [controlState] = controlState(obj)
      controlState = obj.controlState_ ;
    end

    %> @brief Sets the control of this controlled gate to the given `control`.
    function setControl(obj, control )
      assert( qclab.isNonNegInteger(control) ) ;
      assert( control ~= obj.target() ) ;
      obj.control_ = control ;
    end

    %> @brief Sets the control state of this controlled gate to `controlState`.
    function setControlState(obj, controlState)
      assert( (controlState == 0) || (controlState == 1)) ;
      obj.controlState_ = controlState ;
    end

    % ==========================================================================
    %> @brief draw a 2-qubit gate of a controlled 1-qubit gate.
    %>
    %> @param obj 2-qubit gate of a controlled 1-qubit gate.
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

      qubits = obj.qubits ;
      gateCell = cell( 3 * (qubits(2)-qubits(1)+1), 1 );
      label = obj.label( parameter );
      width = length( label );
      if mod(width, 2) == 0
        width = width + 1;
        label = [label space];
      end
      hwidth = floor( width/2 );

      % middle part
      for i = 4:3:length(gateCell)-3
        gateCell{i} = [ repmat(space, 1, hwidth + 2), v, ...
          repmat(space, 1, width - hwidth) ];
        gateCell{i+1} = [ repmat(h, 1, hwidth + 2), vh, ...
          repmat(h, 1, width - hwidth) ];
        gateCell{i+2} = [ repmat(space, 1, hwidth + 2), v, ...
          repmat(space, 1, width - hwidth) ];
      end

      if obj.control < obj.target
        % draw control qubit
        if obj.controlState == 0
          gateCell{1} = repmat(space, 1, width + 3);
          gateCell{2} = [ repmat(h, 1, hwidth + 2), ctrlo, ...
            repmat(h, 1, width - hwidth) ];
          gateCell{3} = [ repmat(space, 1, hwidth + 2), v, ...
            repmat(space, 1, width - hwidth) ];
        else
          gateCell{1} = repmat(space, 1, width + 3);
          gateCell{2} = [ repmat(h, 1, hwidth + 2), ctrl, ...
            repmat(h, 1, width - hwidth) ];
          gateCell{3} = [ repmat(space, 1, hwidth + 2), v, ...
            repmat(space, 1, width - hwidth) ];
        end
        % draw gate
        gateCell{end-2} = [ space, ulc, repmat(h, 1, hwidth), hu, ...
          repmat(h, 1, width - hwidth - 1 ), urc ];
        gateCell{end-1} = [ h, vl, label, vr ];
        gateCell{end} = [ space, blc, repmat(h, 1, width), brc ];
      else
        % draw gate
        gateCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
        gateCell{2} = [ h, vl, label, vr ];
        gateCell{3} = [ space, blc, repmat(h, 1, hwidth), hb, ...
          repmat(h, 1, width - hwidth - 1), brc ];
        % draw control qubit
        if obj.controlState == 0
          gateCell{end-2} = [ repmat(space, 1, hwidth + 2), v, ...
            repmat(space, 1, width - hwidth) ];
          gateCell{end-1} = [ repmat(h, 1, hwidth + 2), ctrlo, ...
            repmat(h, 1, width - hwidth) ];
          gateCell{end} =  repmat(space, 1, width + 3);
        else
          gateCell{end-2} = [ repmat(space, 1, hwidth + 2), v, ...
            repmat(space, 1, width - hwidth) ];
          gateCell{end-1} = [ repmat(h, 1, hwidth + 2), ctrl, ...
            repmat(h, 1, width - hwidth) ];
          gateCell{end} =  repmat(space, 1, width + 3);
        end
      end
      if fid > 0
        qubits = (qubits(1):qubits(2)) + offset;
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
    %> @brief Save a 2-qubit gate of a controlled 1-qubit gate to TeX file.
    %>
    %> @param obj 2-qubit gate of a controlled 1-qubit gate.
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
    function [out] =  toTex(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qubits = obj.qubits ;
      gateCell = cell( qubits(2)-qubits(1)+1, 1 );
      label = obj.label( parameter, true );

      % middle part
      for i = 2:size(gateCell, 1) - 1
        gateCell{i} = '&\t\\qw\t' ;
      end

      % control and gate
      diffq = size(gateCell, 1) - 1 ;
      if obj.control < obj.target
        if obj.controlState == 0
          gateCell{1} = ['&\t\\ctrlo{', num2str(diffq), '}\t'];
        else
          gateCell{1} = ['&\t\\ctrl{', num2str(diffq), '}\t'];
        end
        gateCell{end} = ['&\t\\gate{', label,'}\t'] ;
      else
        if obj.controlState == 0
          gateCell{end} = ['&\t\\ctrlo{', num2str(-diffq), '}\t'];
        else
          gateCell{end} = ['&\t\\ctrl{', num2str(-diffq), '}\t'];
        end
        gateCell{1} = ['&\t\\gate{', label,'}\t'] ;
      end

      if fid > 0
        qubits = (qubits(1):qubits(2)) + offset;
        qclab.toTexCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell;
      end

    end


  end

  methods (Static)
    % controlled
    function [bool] = controlled
      bool = true;
    end
  end

  methods (Abstract)
    %> @brief Returns a copy of the controlled 1-qubit gate of this 2-qubit gate.
    [gate] = gate(obj)
    %> @brief Returns the target qubit of this 2-qubit gate.
    [target] = target(obj) ;
    %> @brief Sets the target of this controlled gate to the given `target`.
    setTarget(obj, target) ;
  end

  methods (Access = protected)
    %> Property groups
    function groups = getPropertyGroups(obj)
      import matlab.mixin.util.PropertyGroup
      props = struct();
      props.nbQubits = obj.nbQubits;
      props.Control = obj.control;
      props.Target = obj.target;
      groups = PropertyGroup(props);
    end
  end
end
