%> @file QObject.m
%> @brief Implements abstract QObject base class.
% ==============================================================================
%> @class QObject
%> @brief General base class for all quantum objects.
%
%>  This class implements functionalities that are shared between different
%>  types of Quantum Objects.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef (Abstract) QObject < handle & ...
                              matlab.mixin.Heterogeneous & ...
                              matlab.mixin.CustomDisplay & ...
                              matlab.mixin.Copyable
  % Abstract methods -----------------------------------------------------------                            
  methods (Abstract)
    %> @brief Returns the number of qubits of this quantum object. 
    [sz] = nbQubits(obj) 
    %> @brief Checks if this quantum object is fixed. 
    [bool] = fixed(obj)
    %> @brief Checks if this quantum object is controlled. 
    [bool] = controlled(obj)
    %> @brief Returns the first qubit of this quantum object. 
    [qubit] = qubit(obj)
    %> @brief Sets the qubit of 1-qubit quantum objects, otherwise void.
    setQubit(obj,qubit)
    %> @brief Returns the qubits of this quantum object. 
    [qubits] = qubits(obj)
    %> @brief Sets the qubits of this quantum object. 
    setQubits(obj,qubits)
    %> @brief Returns the unitary matrix corresponding to this quantum object. 
    [mat] = matrix(obj)
    %> @brief Applies this quantum object to the given matrix. 
    [mat] = apply(obj,side,op, nbQubits, mat, offset)
    %> @brief Writes the QASM code of this quantum object to the given file id.
    [out] = toQASM(obj, fid, offset)
    %> @brief Checks if other equals this quantum object.
    [bool] = equals(obj,other)
    %> @brief Draws the quantum circuit diagram
    [out] = draw(obj, fid, parameter, offset)
    %> @brief Saves the quantum circuit diagram as tex
    [out] = toTex(obj, fid, parameter, offset)
    %> @brief Return conjugate transpose of this quantum object.
    [outprime] = ctranspose(obj)
  end
  % --------------------------------------------------------------------------
  
  methods
    %> Simulates this quantum object by applying it to a vector.
    function [v] = simulate(obj, v)
      nbQubits = log2(size(v,1));
      assert(size(v,1) == 2^nbQubits);
      v = obj.apply('R', 'N', nbQubits, v);
    end
    
    %> Checks if other is equal to this quantum object.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    %> 	Checks if other is different from this quantum object. 
    function [bool] = ne(obj,other)
      bool = ~obj.equals(other);
    end
  end
  
  methods (Static, Sealed, Access = protected)
    %> Default object to place in arrays of quantum objects
    function defaultQObject = getDefaultScalarElement
      defaultQObject = qclab.qgates.Identity ;
    end
  end
  
  methods (Sealed, Access = protected )
    %> display Heterogeneous header
    function header = getHeader(obj)
         header = getHeader@matlab.mixin.CustomDisplay(obj);
    end
    
    %> Property groups
    function groups = getPropertyGroups(obj)
         groups = getPropertyGroups@matlab.mixin.CustomDisplay(obj);
    end
    
    %> display Heterogeneous footer
    function footer = getFooter(obj)
         footer = getFooter@matlab.mixin.CustomDisplay(obj);
    end
      
    %> display Heterogeneous Arrays
    function displayNonScalarObject(obj)
      if length( obj ) ==  numel(obj) % vector
        for i = 1:length( obj )
         displayScalarObject( obj(i) ); 
        end
      else
         displayNonScalarObject@matlab.mixin.CustomDisplay(obj);
      end
    end
  end
end % class QObject

