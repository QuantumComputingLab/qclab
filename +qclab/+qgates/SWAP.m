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
    function [mat] = apply(obj, side, op, nbQubits, mat, offset)
      if nargin == 5, offset = 0; end
      assert( nbQubits >= 2 );
      if strcmp(side,'L') % left
        assert( size(mat,2) == 2^nbQubits);
      else % right
        assert( size(mat,1) == 2^nbQubits);
      end
      qubits = obj.qubits + offset; 
      assert( qubits(1) < nbQubits && qubits(2) < nbQubits ); 
      cnot01 = qclab.qgates.CNOT( qubits(1), qubits(2) );
      cnot10 = qclab.qgates.CNOT( qubits(2), qubits(1) );
      mat = cnot01.apply( side, op, nbQubits, mat, 0 );
      mat = cnot10.apply( side, op, nbQubits, mat, 0 );
      mat = cnot01.apply( side, op, nbQubits, mat, 0 );
    end
     
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset  = 0; end
      qclab.IO.qasmSWAP( fid, obj.qubits + offset );  
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other, 'qclab.qgates.SWAP'), bool = true; end
    end
    
    % ==========================================================================
    %> @brief draw a 2-qubit SWAP gate.
    %>
    %> @param obj 2-qubit SWAP gate 
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
      
      qubits = obj.qubits ;
      gateCell = cell( 3 * (qubits(2)-qubits(1)+1), 1 );
      
      % middle part
      for i = 4:3:length(gateCell)-3
        gateCell{i} = [ space, v ];
        gateCell{i+1} = [ h, vh ];
        gateCell{i+2} = [ space, v ];
      end      
      
      gateCell{1} = [ space, space ];
      gateCell{2} = [ h, sw ];
      gateCell{3} = [ space, v ];
      
      gateCell{end-2} = [ space, v ];
      gateCell{end-1} = [ h, sw ];
      gateCell{end} = [ space, space ];
      
      if fid > 0
        qubits = (qubits(1):qubits(2)) + offset;
        qclab.drawCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell ;
      end
    end
    
    % ==========================================================================
    %> @brief Save a 2-qubit SWAP gate to TeX file.
    %>
    %> @param obj 2-qubit SWAP gate 
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
      
      qubits = obj.qubits ;
      gateCell = cell( qubits(2)-qubits(1)+1, 1 );
      
       % middle part
      for i = 2:size(gateCell,1)-1
        gateCell{i} = '&\t\\qw\t' ;
      end
      
      diffq = size(gateCell, 1) - 1 ;
      gateCell{1} = ['&\t\\qswap\\qwx[',num2str(diffq),']\t'] ;
      gateCell{end} = '&\t\\qswap\t' ;
      
      if fid > 0
        qubits = (qubits(1):qubits(2)) + offset;
        qclab.toTexCellArray( fid, gateCell, qubits );
        out = 0;
      else
        out = gateCell;
      end
    end
    
  end %methods
  
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
  end %static methods
end %SWAP
