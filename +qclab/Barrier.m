%> @file Barrier.m
%> @brief Implements Barrier class.
% ==============================================================================
%> @brief Class for representing a Barrier.
%
% (C) Copyright Sophia Keip, Daan Camps and Roel Van Beeumen 2025.
% ==============================================================================
classdef Barrier < qclab.QObject

  properties (Access = protected)
    %> qubits of this barrier
    qubits_
    %> Visibility information of this barrier
    visibility_
  end

  methods
    % Class constructor  =======================================================
    %> @brief
    %>
    %> @param 
    % ==========================================================================
    function obj = Barrier(qubits, visibility)
      if nargin == 1, visibility = false; end
      % make sure qubits are in a row
      assert(all(diff(sort(qubits)) == 1))
      obj.qubits_ = qubits;
      obj.visibility_ = visibility;
    end

    % qubit
    function [qubit] = qubit(obj)
      qubit = int64(min(obj.qubits_)) ;
    end

    % qubits
    function [qubits] = qubits(obj)
      qubits = int64([obj.qubits_]);
    end

    % nbQubits
    function [nbQubits] = nbQubits(obj)
      nbQubits = int64(length(obj.qubits_) ) ;
    end

    % visibility
    function [visibility] = visibility(obj)
      visibility = obj.visibility_ ;
    end

    % matrix
    function [mat] = matrix(obj)
      isSparse = qclab.isSparse(obj.nbQubits);
      mat = qclab.qId(obj.nbQubits,isSparse);
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
    %> @param nbQubits qubit size of `mat`
    %> @param current matrix or struct of state vectors to which
    %> QMultiControlledGate is applied
    %> @param offset offset applied to qubits
    % ==========================================================================
    function [current] = apply(obj, side, op, nbQubits, current, offset)
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
      matn = qclab.qId(nbQubits, isSparse);
      % apply
      current = qclab.applyGateTo( current, matn, side ) ;
    end

    % ctranspose
    function objprime = ctranspose( obj )
      objprime = copy( obj );
    end

     % toQASM
    function [out] = toQASM(obj, fid, offset)
      out = -1;
    end

    % equals
    function [bool] = equals(obj, other)
      bool = isa(other,'qclab.Barrier') & all(other.qubits == obj.qubits);
    end

    % ==========================================================================
    %> @brief draw a barrier.
    %>
    %> @param obj barrier.
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

      
      nbQubits = obj.nbQubits;
      visibility = obj.visibility_;

      gateCell = cell( 3 * nbQubits, 1 );

      if visibility == false
        for k = 1:nbQubits
          gateCell{3*k-2} = [ space ];
          gateCell{3*k-1} = [ h ];
          gateCell{3*k} = [ space ];
        end
      else
        for k = 1:nbQubits
          gateCell{3*k-2} = [ v ];
          gateCell{3*k-1} = [ v ];
          gateCell{3*k} = [ v ];
        end
      end

      if fid > 0
        qubits = obj.qubits + offset;
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
     

      gateCell = cell( obj.nbQubits, 1 );
      lengthBarrier = int2str(obj.nbQubits-1);
      
      for i = 1:obj.nbQubits
     gateCell{i} = ['&\t\\qw\t'] ;
      end
      if obj.visibility_ == true
        gateCell{1} = ['&\t\\qw\\barrier[-1.35em]{' lengthBarrier '}\t'] ;
      end

      if fid > 0
        qubits = obj.qubits + offset;
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

    % setQubit
    function setQubits(~, ~)
      assert( false );
    end

    % controlled
    function [bool] = controlled
      bool = false ;
    end
    % fixed
     function [bool] = fixed
      bool = true;
    end
  end

end % class Barrier
