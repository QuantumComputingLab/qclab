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
    %> @param obj instance of QGate1 class.
    %> @param side 'L' or 'R' for respectively left or right side of application 
    %>             (in quantum circuit ordering)
    %> @param op 'N', 'T' or 'C' for respectively normal, transpose or conjugate
    %>           transpose application of QGate1
    %> @param qsz qubit size of `mat`
    %> @param mat matrix to which QGate1 is applied
    % ==========================================================================
    function [mat] = apply(obj, side, op, qsz, mat)
      assert( qsz >= 2);
      if strcmp(side,'L') % left
        assert( size(mat,2) == 2^qsz);
      else % right
        assert( size(mat,1) == 2^qsz);
      end
      qubits = obj.qubits;
       % operation
      if strcmp(op, 'N') % normal
        mat2 = obj.matrix;
      elseif strcmp(op, 'T') % transpose
        mat2 = obj.matrix.';
      else % conjugate transpose
        mat2 = obj.matrix';
      end
      % kron( Ileft, mat2, Iright)
      if (qsz == 2)
        matn = mat2 ;
      elseif ( qubits(1) == 0 )
        matn = kron(mat2, qclab.qId(qsz-2)) ;
      elseif ( qubits(2) == qsz-1)
        matn = kron(qclab.qId(qsz-2), mat2);
      else
        matn = kron(kron(qclab.qId(qubits(1)), mat2), ...
          qclab.qId(qsz-qubits(2)-1)) ;
      end
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
  end
  methods (Static)
    % nbQubits
    function [nQ] = nbQubits(~)
      nQ = int32(2);
    end
    
    % setQubit
    function setQubit(~, ~)
      assert( false );
    end
  end
end % class QGate2
