%> @file U3.m
%> @brief Implements U3 gate class.
% ==============================================================================
%> @class U3
%> @brief 1-qubit U3 gate.
%>
%> 1-qubit U3 gate parametrized by three quantum angles: \f$\theta\f$, 
%> \f$\phi\f$ and \f$\lambda\f$ and a global phase \f$\alpha\f$ with 
%> matrix representation:
%>
%> \f[\begin{bmatrix} \cos(\theta/2)   &  -e^{i \lambda}\sin(\theta/2) \\ 
%>                    \sin(\theta/2) e^{i \phi} & e^{i (\phi + \lambda)}\cos(\theta/2) \end{bmatrix},\f]
%>
%>
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef U3 < qclab.qgates.QGate1 & qclab.QAdjustable
  
  properties (Access = protected)
    %> The quantum rotation of this U3 gate: theta/2
    rotation_(1,1)  qclab.QRotation
    %> The quantum angles of this U3 gate: phi, lambda, global phase
    angles_(3,1)  qclab.QAngle
  
  end
  
  methods
    % Class constructor  =======================================================
    %> @brief Constructor for U3 gates
    %>
    %> The U3 class constructor supports 5 ways of constructing a 1-qubit
    %> U3 gate:
    %>
    %> 1. U3() : Default Constructor. Constructs an adjustable 1-qubit U3 
    %>    gate with `qubit` set to 0 and \f$\theta = \phi = \lambda = 0\f$.
    %>
    %> 2. U3(qubit) : Constructs an adjustable 1-qubit U3 
    %>    gate with `qubit` set to `qubit` and \f$\theta = \phi = \lambda = 0\f$.
    %>
    %> 3. U3(qubit, angle_theta, angle_phi, angle_lambda, fixed) : Constructs an
    %>    adjustable 1-qubit U3 gate with `qubit` set to `qubit`, the given 
    %>    quantum angles `angle_theta`, `angle_phi` and `angle_lambda` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 4. U3(qubit, theta, phi, lambda, fixed) : Constructs an adjustable  
    %>    1-qubit U3 gate with the given quantum angles `angle_theta` = 
    %>    \f$\theta/2\f$, `angle_phi` = \f$\phi\f$, `angle_lambda` = 
    %>    \f$\lambda\f$ , and the flag `fixed`. The default of `fixed` is false.
    %>    
    %>
    %> 5. U3(qubit, cos_theta, sin_theta, cos_phi, sin_phi, cos_lambda, 
    %>    sin_lambda, fixed) : Constructs an adjustable 1-qubit U3 gate with
    %     the given values cos_theta` = \f$\cos(\theta/2)\f$, `sin_theta` = 
    %>    \f$\sin(\theta/2)\f$, `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = 
    %>    \f$\sin(\phi)\f$ and `cos_lambda` = \f$\cos(\lambda)\f$,
    %>    `sin_lambda` = \f$\sin(\lambda)\f$, and the flag `fixed`.
    %>     The default of `fixed` is false.
    %>
    %> The global phase of the U3 gate is always initialized to 0.
    % ==========================================================================
    function obj = U3(qubit, varargin)
      if nargin == 0
        qubit = 0;
      end
      obj@qclab.qgates.QGate1( qubit );
      obj@qclab.QAdjustable(false); 
      obj.angles_(3) = qclab.QAngle();      % alpha (global phase)     
      if nargin < 4
        obj.rotation_ = qclab.QRotation();  % theta
        obj.angles_(1) = qclab.QAngle();    % phi
        obj.angles_(2) = qclab.QAngle();    % lambda           
      elseif nargin < 6 % either angle or theta + possibly fixed
        obj.rotation_ = qclab.QRotation( varargin{1} ); % theta
        if isa(varargin{1},'qclab.QAngle') % all angles
          obj.angles_(1) = varargin{2};    % phi
          obj.angles_(2) = varargin{3};    % lambda
        else % all numerical values
          obj.angles_(1) = qclab.QAngle(varargin{2});
          obj.angles_(2) = qclab.QAngle(varargin{3});
        end
        if nargin == 5 && varargin{4}, obj.makeFixed; end  
      else % cosines and sines + possibly fixed
        obj.rotation_ = qclab.QRotation( varargin{1}, varargin{2} );
        obj.angles_(1) = qclab.QAngle(varargin{3}, varargin{4});
        obj.angles_(2) = qclab.QAngle(varargin{5}, varargin{6});
        if nargin == 8 && varargin{7}, obj.makeFixed; end 
      end
    end
    
    % matrix
    function [mat] = matrix(obj)
      ppl = obj.angles_(1) + obj.angles_(2) ;
      gp = obj.globalPhase ;
      mat = zeros(2,2);
      mat(1,1) =  gp * obj.cosTheta;
      mat(1,2) = -gp * (obj.cosLambda + 1i * obj.sinLambda) * obj.sinTheta;
      mat(2,1) =  gp * (obj.cosPhi + 1i * obj.sinPhi) * obj.sinTheta;
      mat(2,2) =  gp * (ppl.cos + 1i * ppl.sin) * obj.cosTheta;
    end
    
    % toQASM
    function [out] = toQASM(obj, fid, offset)
      if nargin == 2, offset = 0; end
      qclab.IO.qasmU3( fid, obj.qubit + offset, obj.theta, obj.phi, obj.lambda );
      out = 0;
    end
    
    % ctranspose
    function [objprime] = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QGate1( obj );
      objprime.setGlobalPhase( conj( obj.globalPhase ) );
      objprime.update( -obj.theta, -obj.lambda, -obj.phi );
    end
    
    % equals
    function [bool] = equals(obj, other)
      bool = false;
      if isa(other,'qclab.qgates.U3')
        bool = isequal( obj.angles_(1:2), other.angles_(1:2) ) && ...
               isequal( obj.rotation_, other.rotation_);
      end
    end
    
    %> @brief Returns a copy of the quantum rotation \f$\theta/2\f$ of this U3
    %> gate
    function rotation = rotation(obj)
      rotation = copy(obj.rotation_);
    end
    
    %> @brief Returns a copy of the quantum angles \f$\phi\f$, \f$\lambda\f$ 
    %> and the global phase of this U3 gate.
    function angles = angles(obj)
      angles = copy(obj.angles_);
    end
    
    %> @brief Returns the numerical value \f$\theta/2\f$ of this U3 gate.
    function theta = theta(obj)
      theta = obj.rotation_.theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\theta/2)\f$ of this U3 gate.
    function cos = cosTheta(obj)
      cos = obj.rotation_.cos ;
    end
    
    %> @brief Returns the sine \f$\sin(\theta/2)\f$ of this U3 gate.
    function sin = sinTheta(obj)
      sin = obj.rotation_.sin ;
    end
    
     %> @brief Returns the numerical value \f$\phi\f$ of this U3 gate.
    function phi = phi(obj)
      phi = obj.angles_(1).theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\phi)\f$ of this U3 gate.
    function cos = cosPhi(obj)
      cos = obj.angles_(1).cos ;
    end
    
    %> @brief Returns the sine \f$\sin(\phi)\f$ of this U3 gate.
    function sin = sinPhi(obj)
      sin = obj.angles_(1).sin ;
    end
    
    %> @brief Returns the numerical value \f$\lambda\f$ of this U3 gate.
    function lambda = lambda(obj)
      lambda = obj.angles_(2).theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\lambda)\f$ of this U3 gate.
    function cos = cosLambda(obj)
      cos = obj.angles_(2).cos ;
    end
    
    %> @brief Returns the sine \f$\sin(\lambda)\f$ of this U3 gate.
    function sin = sinLambda(obj)
      sin = obj.angles_(2).sin ;
    end
    
    %> @brief Returns the global phase of this U3 gate.
    function alpha = globalPhase(obj)
      alpha = obj.angles_(3).cos + 1i * obj.angles_(3).sin ;
    end
    
    %> @brief Sets the global phase of this U3 gate to the unitary value `alpha`
    function setGlobalPhase(obj, alpha)
      assert(abs(abs(alpha) - 1) < 10*eps);
      obj.angles_(3) = qclab.QAngle( real(alpha), imag(alpha) );
    end
      
    % ==========================================================================
    %> @brief Update this U3 gate
    %>
    %> If the U3 gate is not fixed, the update function is called on
    %> the quantum angles. 
    %>
    %> The update function supports 3 ways of updating a U3 gate:
    %>
    %> 1. obj.update(angle_theta, angle_phi, angle_lambda) : updates to the 
    %>    given quantum angles `angle_theta`, `angle_phi` and `angle_lambda`.
    %>
    %> 2. obj.update(theta, phi, lambda) : updates with the given quantum angles 
    %>    `angle_theta` = \f$\theta/2\f$, `angle_phi` = \f$\phi\f$,
    %>    `angle_lambda` = \f$\lambda\f$.
    %>
    %> 3. obj.update( cos_theta, sin_theta, cos_phi, sin_phi, cos_lambda, 
    %>    sin_lambda) : updates with the given values cos_theta` = 
    %>    \f$\cos(\theta/2)\f$, `sin_theta` = \f$\sin(\theta/2)\f$,
    %>    `cos_phi` = \f$\cos(\phi)\f$, `sin_phi` = \f$\sin(\phi)\f$ and
    %>    `cos_lambda` = \f$\cos(\lambda)\f$, `sin_lambda` = \f$\sin(\lambda)\f$
    %>
    %> @param obj   1-qubit U3 gate object
    %> @param varargin Variable input argument, being either:
    %>  - angle_theta angle_phi, angle_lambda : 3 QAngle objects
    %>  - theta, phi, lambda
    %>  - cos_theta, sin_theta, cos_phi, sin_phi, cos_lambda, sin_lambda
    % ==========================================================================
    function update(obj, varargin)
      assert(~obj.fixed)
      if nargin == 4 % angles or numerical values provided
        obj.rotation_.update(varargin{1});
        obj.angles_(1).update(varargin{2});
        obj.angles_(2).update(varargin{3});
      else % cosines and sines provided
        obj.rotation_.update(varargin{1}, varargin{2});
        obj.angles_(1).update(varargin{3}, varargin{4});
        obj.angles_(2).update(varargin{5}, varargin{6});
      end 
    end
    
    % label for draw and tex function
    function [label] = label(obj, parameter, tex)
      if nargin < 2, parameter = 'N'; end
      label = 'U3';        
      if strcmp(parameter, 'S') % short parameter
        label = sprintf([label, '(%.4f, %.4f, %.4f)'], ...
                          obj.theta, obj.phi, obj.lambda);
      elseif strcmp(parameter, 'L') % long parameter
        label = sprintf([label, '(%.8f, %.8f, %.8f)'], ...
                          obj.theta, obj.phi, obj.lambda);
      end
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle property.
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.rotation_ = obj.rotation() ;
      cp.angles_ = obj.angles() ;
    end
    
  end
end % U3