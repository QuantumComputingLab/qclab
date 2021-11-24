%> @file U2.m
%> @brief Implements U2 gate class.
% ==============================================================================
%> @class U2
%> @brief 1-qubit U2 gate.
%>
%> 1-qubit U2 gate parametrized by two quantum angles \f$\phi\f$ and 
%> \f$\lambda\f$ with matrix representation:
%>
%> \f[\frac{1}{\sqrt{2}} \begin{bmatrix} 1   &  -e^{i \lambda} \\ 
%>                    e^{i \phi} & e^{i (\phi + \lambda)} \end{bmatrix},\f]
%>
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef U2 < qclab.qgates.QGate1 & qclab.QAdjustable
  
  properties (Access = protected)
    %> The quantum angles of this U2 gate: phi and lambda
    angles_(2,1)  qclab.QAngle
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for U2 gates
    %>
    %> The U2 class constructor supports 5 ways of constructing a 1-qubit
    %> U2 gate:
    %>
    %> 1. U2() : Default Constructor. Constructs an adjustable 1-qubit U2 
    %>    gate with `qubit` set to 0 and \f$\phi = \lambda = 0\f$.
    %>
    %> 2. U2(qubit) : Constructs an adjustable 1-qubit U2 
    %>    gate with `qubit` set to `qubit` and \f$\phi = \lambda = 0\f$.
    %>
    %> 3. U2(qubit, angle_phi, angle_lambda, fixed) : Constructs an adjustable
    %>    1-qubit U2 gate with `qubit` set to `qubit`, the given quantum
    %>    angles `angle_phi` and `angle_lambda` and the flag `fixed`. The
    %>    default of `fixed` is false.
    %>
    %> 4. U2(qubit, phi, lambda, fixed) : Constructs an adjustable 1-qubit U2 
    %>    gate with the given quantum angles `angle_phi` = \f$\phi\f$,
    %>    `angle_lambda` = \f$\lambda\f$, and the flag `fixed`. 
    %>    The default of `fixed` is false.
    %>
    %> 5. U2(qubit, cos_phi, sin_phi, cos_lambda, sin_lambda, fixed) :
    %     Constructs an adjustable 1-qubit U2 gate with the given values
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = \f$\sin(\phi)\f$ and
    %>    `cos_lambda` = \f$\cos(\lambda)\f$, `sin_lambda` = \f$\sin(\lambda)\f$
    %>     and the flag `fixed`. The default of `fixed` is false.
    % ==========================================================================
    
    function obj = U2(qubit, varargin)
      if nargin == 0
        qubit = 0;
      end
      obj@qclab.qgates.QGate1( qubit );
      obj@qclab.QAdjustable(false); 
      if nargin < 3 % empty default constructor
        obj.angles_(1) = qclab.QAngle();
        obj.angles_(2) = qclab.QAngle();
      elseif nargin < 5 % either angle or theta + possibly fixed
        if isa(varargin{1},'qclab.QAngle') % angles
          obj.angles_(1) = varargin{1};
          obj.angles_(2) = varargin{2};
        else % numerical values
          obj.angles_(1) = qclab.QAngle(varargin{1});
          obj.angles_(2) = qclab.QAngle(varargin{2});
        end
        if nargin == 4 && varargin{3}, obj.makeFixed; end          
      else % cosines and sines + possibly fixed
        obj.angles_(1) = qclab.QAngle(varargin{1}, varargin{2});
        obj.angles_(2) = qclab.QAngle(varargin{3}, varargin{4});
        if nargin == 6 && varargin{5}, obj.makeFixed; end          
      end
    end
    
    % matrix
    function [mat] = matrix(obj)
      ppl = obj.angles_(1) + obj.angles_(2) ;
      mat = [1,                            -obj.cosLambda - 1i * obj.sinLambda;
             obj.cosPhi + 1i * obj.sinPhi, ppl.cos + 1i * ppl.sin];
      mat = mat/sqrt(2) ;     
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmU2( fid, obj.qubit + offset, obj.phi, obj.lambda );
      out = 0;
    end
    
    % ctranspose
    function [objprime] = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QGate1( obj );
      objprime.update( -obj.lambda + pi, -obj.phi + pi );
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.U2')
        bool = isequal( obj.angles_, other.angles_ ) ;
      end
    end
    
    %> @brief Returns a copy of the quantum angles \f$\phi\f$ and \f$\lambda\f$ 
    %> of this U2 gate.
    function angles = angles(obj)
      angles = copy(obj.angles_);
    end
    
    %> @brief Returns the numerical value \f$\phi\f$ of this U2 gate.
    function phi = phi(obj)
      phi = obj.angles_(1).theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\phi)\f$ of this U2 gate.
    function cos = cosPhi(obj)
      cos = obj.angles_(1).cos ;
    end
    
    %> @brief Returns the sine \f$\sin(\phi)\f$ of this U2 gate.
    function sin = sinPhi(obj)
      sin = obj.angles_(1).sin ;
    end
    
    %> @brief Returns the numerical value \f$\lambda\f$ of this U2 gate.
    function lambda = lambda(obj)
      lambda = obj.angles_(2).theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\lambda)\f$ of this U2 gate.
    function cos = cosLambda(obj)
      cos = obj.angles_(2).cos ;
    end
    
    %> @brief Returns the sine \f$\sin(\lambda)\f$ of this U2 gate.
    function sin = sinLambda(obj)
      sin = obj.angles_(2).sin ;
    end
    
    % ==========================================================================
    %> @brief Update this U2 gate
    %>
    %> If the U2 gate is not fixed, the update function is called on
    %> the quantum angles. 
    %>
    %> The update function supports 3 ways of updating a U2 gate:
    %>
    %> 1. obj.update(angle_phi, angle_lambda) : updates to the given quantum
    %>    angles `angle_phi` and `angle_lambda`.
    %>
    %> 2. obj.update(phi, lambda) : updates with the given quantum angles 
    %>    `angle_phi` = \f$\phi\f$,`angle_lambda` = \f$\lambda\f$
    %>
    %> 3. obj.update(cos_phi, sin_phi, cos_lambda, sin_lambda) : updates with 
    %>    the given values
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = \f$\sin(\phi)\f$ and
    %>    `cos_lambda` = \f$\cos(\lambda)\f$, `sin_lambda` = \f$\sin(\lambda)\f$
    %>
    %> @param obj   1-qubit U2 gate object
    %> @param varargin Variable input argument, being either:
    %>  - angle_phi, angle_lambda : 2 QAngle objects
    %>  - phi, lambda
    %>  - cos_phi, sin_phi, cos_lambda, sin_lambda
    % ==========================================================================
    function update(obj, varargin)
      assert(~obj.fixed)
      if nargin == 3 % angles or numerical values provided
        obj.angles_(1).update(varargin{1});
        obj.angles_(2).update(varargin{2});
      else % cosines and sines provided
        obj.angles_(1).update(varargin{1}, varargin{2});
        obj.angles_(2).update(varargin{3}, varargin{4});
      end 
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex )
      if nargin < 2, parameter = 'N'; end
      label = 'U2';        
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f, %.4f)'], obj.phi, obj.lambda);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f, %.8f)'], obj.phi, obj.lambda);
      end
    end
     
  end 
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property.
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.angles_ = obj.angles() ;
    end
    
  end
end % U2