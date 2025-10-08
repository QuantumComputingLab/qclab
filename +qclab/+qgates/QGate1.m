%> @file QGate1.m
%> @brief Implements QGate1 class
% ==============================================================================
%> @class QGate1
%> @brief Base class for 1-qubit gates.
%
%>  This class implements functionalities that are shared between different
%>  types of 1-qubit gates.
%> 
%>  Abstract base class for 1-qubit gates.
%>  Concrete subclasses have to implement:
%>  - equals      % defined in qclab.QObject
%>  - toQASM      % defined in qclab.QObject
%>  - matrix      % defined in qclab.QObject
%>  - fixed       % defined in qclab.QObject
%> 
% (C) Copyright Daan Camps, Sophia Keip and Roel Van Beeumen 2025.
% ==============================================================================
classdef QGate1 < qclab.QObject
  properties (Access = protected)
    %> Qubit of this 1-qubit gate.
    qubit_(1,1)  int64
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for 1-qubit quantum gate objects
    %>
    %> The QGate1 constructor can be used in two ways:
    %> 
    %> 1. `QGate1()` : default constructor, sets to qubit_ to 0.
    %> 2. `QGate1(qubit)` : sets the qubit_ to qubit.
    % ==========================================================================
    function obj = QGate1(qubit)
      if nargin == 0, qubit = 0; end
      assert( qclab.isNonNegInteger( qubit ) ) ;
      obj.qubit_ = qubit ;
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.qubit_;
    end
    
    % setQubit
    function setQubit(obj,qubit)
      assert( qclab.isNonNegInteger( qubit ) );      
      obj.qubit_ = qubit ;
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = [obj.qubit_];
    end
    
    % setQubits
    function setQubits(obj,qubits)
      assert(qclab.isNonNegInteger( qubits(1) ) );
      obj.qubit_ = qubits(1) ;
    end
    
    % ==========================================================================
    %> @brief Apply the QGate1 to a matrix or a struct of state vectors
    %> `current`
    %> @param obj instance of QGate1 class.
    %> @param side 'L' or 'R' side application in quantum circuit
    %> @param op 'N', 'T' or 'C' for normal, transpose or conjugate transpose
    %>           application of QGate1
    %> @param nbQubits qubit size of `current`
    %> @param current matrix or struct of state vectors to which QGate1 is 
    %> applied
    %> @param offset offset applied to qubit
    % ==========================================================================
    function [current] = apply(obj, side, op, nbQubits, current, offset)
      if nargin == 5, offset = 0; end
      assert( nbQubits >= 1);
      qubit = obj.qubit + offset ;
      assert( qubit < nbQubits ) ;
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
      % operation
      if strcmp(op, 'N') % normal
        mat1 = obj.matrix;
      elseif strcmp(op, 'T') % transpose
        mat1 = obj.matrix.';
      else % conjugate transpose
        mat1 = obj.matrix';
      end
      % kron(Ileft, mat1, Iright)  
      if (nbQubits == 1)
        matn = mat1 ;
      elseif ( qubit == 0 )
        matn = kron(mat1, qclab.qId(nbQubits-1, isSparse)) ;
      elseif ( qubit == nbQubits-1)
        matn = kron(qclab.qId(nbQubits-1, isSparse), mat1);
      else
        matn = kron(kron(qclab.qId(qubit,isSparse), mat1), qclab.qId(...
                    nbQubits-qubit-1,isSparse)) ;
      end
      % side
      current = qclab.applyGateTo(current, matn, side ) ;
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = copy( obj );
    end
    
    % ==========================================================================
    %> @brief draw a 1-qubit gate
    %>
    %> @param obj 1-qubit gate
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
      gateCell = cell(3, 1);
      label = obj.label( parameter );
      width = length( label );
      gateCell{1} = [ space, ulc, repmat(h, 1, width), urc ];
      gateCell{2} = [ h, vl, label, vr ];
      gateCell{3} = [ space, blc, repmat(h, 1, width), brc ];
      if fid > 0
        qubit = obj.qubit + offset ;
        qclab.drawCellArray( fid, gateCell, qubit );
        out = 0;
      else
        out = gateCell;
      end

      if nargout > 0
        varargout = {out};
      else
        varargout = {};
      end
    end
    
    % ==========================================================================
    %> @brief Save a 1-qubit gate to TeX file
    %>
    %> @param obj 1-qubit gate
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
      gateCell = cell(1,1) ;
      label = obj.label( parameter, true );
      gateCell{1} = ['&\t\\gate{', label,'}\t'] ;
      if fid > 0
        qubit = obj.qubit + offset ;
        qclab.toTexCellArray( fid, gateCell, qubit );
        out = 0;
      else
        out = gateCell;
      end
    end
    
  end
  
  methods (Static)
    % nbQubits
    function [nbQubits] = nbQubits
      nbQubits = int64(1);
    end
    
     % controlled
    function [bool] = controlled
      bool = false;
    end
  end
   
end % class QGate1
