%> @file iSWAP.m
%> @brief Implements iSWAP class
% ==============================================================================
%> @class iSWAP
%> @brief iSWAP gate
%> 
%> 2-qubit iSWAP gate with matrix representation:
%>
%> \f[\begin{bmatrix} 1 & 0 & 0 & 0\\ 
%>                    0 & 0 & i & 0\\ 
%>                    0 & i & 0 & 0\\ 
%>                    0 & 0 & 0 & 1 \end{bmatrix}\f]
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef iSWAP < qclab.qgates.QGate2
  properties (Access = protected)
    %> Qubits of this iSWAP gate.
    qubits_(1,2)  int32
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Contstructor for 2-qubit iSWAP gates
    %>
    %> The iSWAP class constructor supports 3 ways of constructing a iSWAP gate:
    %>
    %> 1. iSWAP() : Default constructor. iSWAP gate with 
    %>    `qubits` \f$= \begin{bmatrix}0 & 1\end{bmatrix}\f$.
    %>
    %> 2. iSWAP( qubits ) : iSWAP qate with `qubits` = `qubits`.
    %>
    %> 3. iSWAP( qubit0, qubit1 ) : iSWAP gate with `qubits` = [`qubit0`,
    %>    `qubit1`].
    % ========================================================================== 
    function obj = iSWAP( qubit, qubit1 )
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
      S = qclab.qgates.Phase90( qubits(1) );
      H = qclab.qgates.Hadamard( qubits(1) );
      CNOT = qclab.qgates.CNOT( qubits(1), qubits(2) );
      
      % layer 1
      mat = S.apply( side, op, nbQubits, mat );
      S.setQubit( qubits(2) );
      mat = S.apply( side, op, nbQubits, mat );
      % layer 2
      mat = H.apply( side, op, nbQubits, mat );
      % layer 3
      mat = CNOT.apply( side, op, nbQubits, mat );
      % layer 4
      CNOT.setQubits( [qubits(2), qubits(1)] );
      mat = CNOT.apply( side, op, nbQubits, mat );
      % layer 5
      H.setQubit( qubits(2) );
      mat = H.apply( side, op, nbQubits, mat );
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset  = 0; end
      qclab.IO.qasmiSWAP( fid, obj.qubits + offset );  
      out = 0;
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other, 'qclab.qgates.iSWAP'), bool = true; end
    end
    
    % ctranspose
    function [objprime] = ctranspose( obj )
      qubits = obj.qubits ;
      objprime = qclab.QCircuit( qubits(2) + 1 );
      objprime.push_back( qclab.qgates.Hadamard( qubits(2) ) );
      objprime.push_back( qclab.qgates.CNOT( qubits(2), qubits(1) ) );
      objprime.push_back( qclab.qgates.CNOT( qubits(1), qubits(2) ) );
      objprime.push_back( qclab.qgates.Hadamard( qubits(1) ) );
      objprime.push_back( ctranspose( qclab.qgates.Phase90( qubits(1) ) ) );
      objprime.push_back( ctranspose( qclab.qgates.Phase90( qubits(2) ) ) );
    end
    
    % ==========================================================================
    %> @brief draw a 2-qubit iSWAP gate.
    %>
    %> @param obj 2-qubit iSWAP gate 
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
      gateCell{2} = [ h, isw ];
      gateCell{3} = [ space, v ];
      
      gateCell{end-2} = [ space, v ];
      gateCell{end-1} = [ h, isw ];
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
    %> @brief Save a 2-qubit iSWAP gate to TeX file.
    %>
    %> @param obj 2-qubit iSWAP gate 
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
      gateCell{1} = ['&\t\\targ\\qwx[',num2str(diffq),']\t'] ;
      gateCell{end} = '&\t\\targ\t' ;
      
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
      mat = [1, 0,  0, 0; 
             0, 0, 1i, 0;
             0, 1i, 0, 0;
             0, 0,  0, 1];
    end
  end %static methods
  
end %iSWAP