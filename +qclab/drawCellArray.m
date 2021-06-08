%> @file drawCellArray.m
%> @brief draws a cell array containing a graphic for a quantum object.
% ==============================================================================
%
%> @param fid  file id to draw to
%> @param cellArray cell array containing the graphic for the quantum object
%> @param qubits array containing (ascending) qubit indices of quantum objects,
%>        length(qubits) should be equal to size(cellArray,1)/3
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
function drawCellArray( fid, cellArray, qubits )


[ rows, ~ ] = size( cellArray );
assert( mod(rows, 3) == 0 );
assert( rows/3 == length(qubits) );
qclab.drawCommands ; % load draw commands

% character width of qubits
qwidth = length( num2str(qubits(end)) );


for i = 1:rows
    
  % draw start of line
  if mod(i, 3) == 2 % qubit line
    cq = num2str( qubits( ceil(i/3) ) );
    fprintf(fid, ['q', cq, repmat(space, 1, qwidth - length(cq)), ': ']);
  else % non-qubit line
    fprintf(fid, repmat(space, 1, qwidth + 3));
  end
  
  % draw body of line  
  fprintf( fid, cellArray{i} );
  
    
  % draw end of line
  if mod(i, 3) == 2 % qubit line
    fprintf(fid, h);
  else
    fprintf(fid, space);
  end    
  
  % draw line break
  fprintf(fid, '\n');
    
end

end