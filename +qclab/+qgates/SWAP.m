%> @file SWAP.m
%> @brief Implements SWAP class
% ==============================================================================
%> @class SWAP
%> @brief SWAP gate
%> 
%> 2-qubit SWAP gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0 & 0 & 0\\ 
%>                    0 & 0 & 1 & 0\\ 
%>                    0 & 1 & 0 & 0\\ 
%>                    0 & 0 & 0 & 1 \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef SWAP < qclab.qgates.QGate2
  properties (Access = protected)
    %> Qubits of this SWAP gate.
    qubits_(1,2)  int32
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Contstructor for 2-qubit SWAP gates
    %>
    %> The SWAP class constructor supports 3 ways of constructing a SWAP gate:
    %>
    %> 1. SWAP() : Default constructor. SWAP gate with 
    %>    `qubits` \f$= \begin{bmatrix}0 & 1\end{bmatrix}\f$.
    %>
    %> 2. SWAP( qubits ) : SWAP qate with `qubits` = `qubits`.
    %>
    %> 3. SWAP( qubit0, qubit1 ) : SWAP gate with `qubits` = [`qubit0`,
    %>    `qubit1`].
    % ========================================================================== 
    function obj = SWAP( qubit, qubit1 )
      if nargin == 0
        qubit = [0, 1];
      elseif nargin == 2
        qubit = [qubit, qubit1];
      end
      obj.setQubits( qubit );
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.qubits_(1);
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = obj.qubits_;
    end
    
    % setQubits
    function setQubits(obj, qubits )
      assert( qclab.isNonNegIntegerArray(qubits(1:2)) ); 
      assert( qubits(1) ~= qubits(2) ) ;
      obj.qubits_ = sort(qubits(1:2)) ;
    end
    
    % apply
    function [mat] = apply(obj, side, op, qsz, mat)
      assert( qsz >= 2 );
      if strcmp(side,'L') % left
        assert( size(mat,2) == 2^qsz);
      else % right
        assert( size(mat,1) == 2^qsz);
      end
      qubits = obj.qubits; 
      assert( qubits(1) < qsz && qubits(2) < qsz ); 
      cnot01 = qclab.qgates.CNOT( qubits(1), qubits(2) );
      cnot10 = qclab.qgates.CNOT( qubits(2), qubits(1) );
      matn = qclab.qId( qsz );
      matn = cnot01.apply( side, op, qsz, matn );
      matn = cnot10.apply( side, op, qsz, matn );
      matn = cnot01.apply( side, op, qsz, matn );
      % side
      if strcmp(side, 'L') % left
        mat = mat * matn ;
      else % right
        mat = matn * mat ;
      end
    end
     
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset  = 0; end
      fprintf(fid,'swap q[%d], q[%d];\n', obj.qubits_(1) + offset, ...
          obj.qubits_(2) + offset);
       out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other, 'qclab.qgates.SWAP'), bool = true; end
    end
  end
  
  methods (Static)
    % fixed
    function [bool] = fixed
      bool = true;
    end
    
    % controlled
    function [bool] = controlled
      bool = false;
    end
    
    % matrix
    function [mat] = matrix
      mat = [1, 0, 0, 0; 
             0, 0, 1, 0;
             0, 1, 0, 0;
             0, 0, 0, 1];
    end
  end
end
