% MatrixGate – Multi-qubit gate defined by a unitary matrix
% The MatrixGate class implements a general multi-qubit quantum gate based on 
% a user-defined unitary matrix. The gate applies the specified unitary to a 
% consecutive set of qubits.
%
% The matrix must be square of size 2^n × 2^n, where n is the number of qubits.
%
% Creation
%   Syntax
%     G = qclab.qgates.MatrixGate(qubits, unitary)
%       - Creates a matrix gate acting on the given `qubits` using the specified
%         unitary matrix. A default label `'U'` is used for display.
%
%     G = qclab.qgates.MatrixGate(qubits, unitary, label)
%       - Same as above, but also sets the display label for the gate.
%
%   Input Arguments
%     qubits  - vector of consecutive non-negative integers specifying the qubits
%               on which the matrix gate acts
%     unitary - unitary matrix of size 2^n × 2^n, where n = length(qubits)
%     label   - string label used for visualization (default = 'U')
%
%   Output
%     G - A quantum object of type `MatrixGate`, representing a custom 
%         multi-qubit quantum gate.
%
% Example:
%   Apply a 2-qubit custom unitary to qubits 1 and 2:
%     U = [1 0 0 0; 0 0 1 0; 0 1 0 0; 0 0 0 1];  % example swap-like matrix
%     G = qclab.qgates.MatrixGate([1 2], U, 'myGate');

%> @file MatrixGate.m
%> @brief Implements MatrixGate class
% ==============================================================================
%> @class MatrixGate
%> @brief Class for multi-qubit gate defined by a unitary matrix.
%>
%>
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================

classdef MatrixGate < qclab.QObject

  properties (Access = protected)
    %> qubits of this multi-qubit gate.
    qubits_ int64
    %> unitary representing this multi-qubit gate.
    unitary_ double
    %> label of this multi-qubit gate
    label_ char
  end

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for MatrixGate objects
    % ==========================================================================
    function obj = MatrixGate(qubits, unitary, label)
      if nargin < 3, label = 'U'; end
      % qubits must be consecutive non negative integers
      assert( all( diff(qubits) == 1 ), 'Qubits must be consecutive.' ) ;
      assert( qclab.isNonNegIntegerArray(qubits) )
      % matrix must be square
      [rows, cols] = size(unitary);
      assert(rows == cols, 'Unitary matrix must be square.');
      % dimension of matrix must fit number of qubits
      nbQubits = length(qubits);
      assert(rows == 2^nbQubits, sprintf( ...
        'Size of unitary matrix must be 2^n × 2^n for n = %d qubits.', ...
        nbQubits));
      obj.qubits_ = qubits ;
      obj.unitary_ = unitary ;
      obj.label_ = label ;
    end

    % qubit
    function [qubit] = qubit(obj)
      qubit = min([obj.qubits_]) ;
    end

    % qubits
    function [qubits] = qubits(obj)
      qubits = [obj.qubits_];
    end

    % setQubits
    function setQubits(obj, qubits)
      assert( qclab.isNonNegIntegerArray(qubits) ) ;
      assert( all( diff(qubits) == 1 ), 'Qubits must be consecutive.' ) ;
      assert( length(qubits) == length(obj.qubits_)) ;
      obj.qubits_ = qubits ;
    end

    % nbQubits
    function [nbQubits] = nbQubits(obj)
      nbQubits = int64(length(obj.qubits_)) ;
    end

    % matrix
    function [mat] = matrix(obj)
      mat = obj.unitary_ ;
    end

    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      % if mod(strlength(s), 2) == 0
      %   label = [' ',obj.label_];
      % else
        label = [' ',obj.label_,' '];
      %end
    end

    function setLabel(obj, label)
      assert(ischar(label));
      obj.label_ = label ;
    end


    % ==========================================================================
    %> @brief Apply the MatrixGate to a matrix or a struct of
    %> state vectors
    %>
    %> @param obj instance of MatrixGate class.
    %> @param side 'L' or 'R' for respectively left or right side of application
    %>              (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of MatrixGate
    %> @param nbQubits qubit size of `current`
    %> @param current matrix or struct of state vectors to which
    %> MatrixGate is applied
    %> @param offset offset applied to qubits
    % ==========================================================================
    function [current] = apply(obj, side, op, nbQubits, current, offset)
      if nargin == 5, offset = 0; end
      isSparse = qclab.isSparse(nbQubits) ;
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
      assert( all(qubits < nbQubits));
      % operation
      if strcmp(op, 'N') % normal
        matu = obj.matrix;
      elseif strcmp(op, 'T') % transpose
        matu = obj.matrix.';
      else % conjugate transpose
        matu = obj.matrix';
      end
      % kron( Ileft, mat2, Iright)
      if (nbQubits == obj.nbQubits)
        matn = matu ;
      elseif ( qubits(1) == 0 )
        matn = kron(matu, qclab.qId(nbQubits-obj.nbQubits, isSparse)) ;
      elseif ( qubits(obj.nbQubits) == nbQubits-1)
        matn = kron(qclab.qId(nbQubits-obj.nbQubits, isSparse), matu);
      else
        matn = kron(kron(qclab.qId(qubits(1),isSparse), matu), ...
          qclab.qId(nbQubits-qubits(obj.nbQubits)-1, isSparse)) ;
      end
      current = qclab.applyGateTo( current, matn, side ) ;
    end

    % ctranspose
    function objprime = ctranspose( obj )
      unitary = obj.matrix ;
      objprime = qclab.qgates.MatrixGate( obj.qubits, unitary', obj.label_ );
    end

    % equals
    function [bool] = equals(obj, other)
      if isa(other, 'qclab.qgates.MatrixGate')
        bool = (all(obj.qubits == other.qubits)) && norm(obj.matrix - ...
          other.matrix, 'fro') < 10*eps;
      else
        bool = false;
      end
    end

    % ==========================================================================
    %> @brief draw a MatrixGate
    %>
    %> @param obj MatrixGate
    %> @param fid  file id to draw to:
    %>              - 0  : return cell array with ascii characters as `out`
    %>              - 1  : draw to command window (default)
    %>              - >1 : draw to (open) file id
    %> @param parameter 'N': don't print parameter (default), 'S': print short
    %>                  parameter, 'L': print long parameter.
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
      nbQubits = obj.nbQubits;
      gateCell =  cell(3*nbQubits,1);
      label = obj.label;
      width = length( label );
      if nbQubits == 1
        gateCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
        gateCell{2} = [ h, vl, repmat(space, 1, width), vr ];
        gateCell{3} =  [ space, blc, repmat(h, 1, width), brc ];
      end
      if nbQubits >= 2
        gateCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
        gateCell{2} = [ h, vl, repmat(space, 1, width), vr ];
        gateCell{3} = [ space, v, repmat(space, 1, width), v ];
        if nbQubits > 2
          for k = 2:nbQubits
            gateCell{3*k-2} = [ space, v, repmat(space, 1, width), v ];
            gateCell{3*k-1} = [ h, vl, repmat(space, 1, width), vr ];
            gateCell{3*k} = [ space, v, repmat(space, 1, width), v ];
          end
        end
        gateCell{end-2} = [ space, v, repmat(space, 1, width), v ];
        gateCell{end-1} = [ h, vl, repmat(space, 1, width), vr];
        gateCell{end} = [ space, blc, repmat(h, 1, width), brc ];
      end
      if mod(obj.nbQubits,2) == 0
        gateCell{3*nbQubits/2} = [ space, v, label, v ];
      else
        gateCell{ceil(3*nbQubits/2)} = [ h, vl, label, vr ];
      end

      if fid > 0
        qclab.drawCellArray( fid, gateCell, obj.qubits + offset );
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
    %> @brief Save a MatrixGate to TeX file
    %>
    %> @param obj MatrixGate
    %> @param fid  file id to draw to:
    %>              - 0  : return cell array with ascii characters as `out`
    %>              - 1  : draw to command window (default)
    %>              - >1 : draw to (open) file id
    %> @param parameter 'N': don't print parameter (default), 'S': print short
    %>                  parameter, 'L': print long parameter.
    %> @param offset qubit offset. Default is 0.
    %>
    %> @retval out if fid > 0 then out == 0 on succesfull completion, otherwise
    %>             out contains a cell array with the drawing info.
    % ==========================================================================
    function [out] = toTex(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      gateCell = cell(obj.nbQubits,1); % cell array to store all strings
      gateCell(:) = {''};
      label = obj.label;
      if obj.nbQubits == 1
        gateCell = cell(1,1) ;
        gateCell{1} = ['&\t\\gate{\\mathrm{', label,'}}\t'] ;
      else
        gateCell{1} = ['&\t\\multigate{' int2str(obj.nbQubits-1) '}' ...
          '{\\mathrm{', label,'}}\t'] ;
        for i = 2:obj.nbQubits
          gateCell{i} = ['&\t\\ghost{\\mathrm{', label,'}}\t'] ;
        end
      end

      if fid > 0
        qclab.toTexCellArray( fid, gateCell, obj.qubits + offset );
        out = 0;
      else
        out = gateCell ;
      end
    end
  end


  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end

    % setQubit
    function setQubit(~, ~)
      assert( false );
    end

    % toQASM
    function toQASM(~, ~, ~)
      assert( false );
    end

    % controlled
    function [bool] = controlled
      bool = false ;
    end
  end

   methods ( Access = protected )
     %> Property groups
    function groups = getPropertyGroups(obj)
     import matlab.mixin.util.PropertyGroup
     props = struct();
     props.nbQubits = obj.nbQubits;  
     props.Qubits = obj.qubits;
     props.Unitary = obj.matrix;
     groups = PropertyGroup(props);
    end
   end 

end