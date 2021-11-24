%> @file QGate2.m
%> @brief Implements QGate2 class
% ==============================================================================
%> @class QGate2
%> @brief Base class for 2-qubit gates.
%
%>  This class implements functionalities that are shared between different
%>  types of 2-qubit gates.
%> 
%>  Abstract base class for 2-qubit gates.
%>  Concrete subclasses have to implement following methods:
%>  - equals      % defined in qclab.QObject
%>  - toQASM      % defined in qclab.QObject
%>  - matrix      % defined in qclab.QObject
%>  - fixed       % defined in qclab.QObject
%> 
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QGate2 < qclab.QObject
  
  methods 
    % ==========================================================================
    %> @brief Apply the QGate2 to a matrix `mat`
    %>
    %> @param obj instance of QGate2 class.
    %> @param side 'L' or 'R' for respectively left or right side of application 
    %>             (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of QGate1
    %> @param nbQubits qubit size of `mat`
    %> @param mat matrix to which QGate2 is applied
    %> @param offset offset applied to qubits
    % ==========================================================================
    function [mat] = apply(obj, side, op, nbQubits, mat, offset)
      if nargin == 5, offset = 0; end
      assert( nbQubits >= 2);
      if strcmp(side,'L') % left
        assert( size(mat,2) == 2^nbQubits);
      else % right
        assert( size(mat,1) == 2^nbQubits);
      end
      qubits = obj.qubits + offset;
      assert( qubits(1) < nbQubits ); assert( qubits(2) < nbQubits );
      assert( qubits(1) + 1 == qubits(2) ); % nearest neighbor qubits
       % operation
      if strcmp(op, 'N') % normal
        mat2 = obj.matrix;
      elseif strcmp(op, 'T') % transpose
        mat2 = obj.matrix.';
      else % conjugate transpose
        mat2 = obj.matrix';
      end
      % kron( Ileft, mat2, Iright)
      if (nbQubits == 2)
        matn = mat2 ;
      elseif ( qubits(1) == 0 )
        matn = kron(mat2, qclab.qId(nbQubits-2)) ;
      elseif ( qubits(2) == nbQubits-1)
        matn = kron(qclab.qId(nbQubits-2), mat2);
      else
        matn = kron(kron(qclab.qId(qubits(1)), mat2), ...
          qclab.qId(nbQubits-qubits(2)-1)) ;
      end
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = copy( obj );
    end
    
    % ==========================================================================
    %> @brief draw a 2-qubit gate acting on nearest neighbor qubits
    %>
    %> @param obj 2-qubit gate
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
      qubits = obj.qubits + offset;
      assert(qubits(1) + 1 == qubits(2)); % nearest neighbor qubits
      qclab.drawCommands ; % load draw commands
      gateCell = cell(6, 1);
      label = obj.label( parameter );
      width = length( label );
      gateCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
      gateCell{2} = [ h, vl, repmat(space, 1, width), vr ];
      gateCell{3} = [ space, v, label, v];
      gateCell{4} = [ space, v, repmat(space, 1, width), v]; 
      gateCell{5} = [ h, vl, repmat(space, 1, width), vr ];
      gateCell{6} = [ space, blc, repmat(h, 1, width), brc ];
      if fid > 0
        qclab.drawCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell ;
      end
    end
    
    % ==========================================================================
    %> @brief Save a 2-qubit gate acting on nearest neighbor qubits to Tex file
    %>
    %> @param obj 2-qubit gate
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
    function [out] = toTex(obj, fid, parameter, offset)
      if nargin < 2, fid = 1; end
      if nargin < 3, parameter = 'N'; end
      if nargin < 4, offset = 0; end
      qubits = obj.qubits + offset;
      assert(qubits(1) + 1 == qubits(2)); % nearest neighbor qubits
      gateCell = cell(2,1) ;
      label = obj.label( parameter, true );
      gateCell{1} = ['&\t\\multigate{1}{', label,'}\t'] ;
      gateCell{2} = ['&\t\\ghost{', label,'}\t'] ;
      if fid > 0
        qclab.toTexCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell;
      end
    end
    
  end
  methods (Static)
    % nbQubits
    function [nbQubits] = nbQubits(~)
      nbQubits = int32(2);
    end
    
    % setQubit
    function setQubit(~, ~)
      assert( false );
    end
  end
end % class QGate2
