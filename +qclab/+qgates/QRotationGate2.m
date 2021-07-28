%> @file QRotationGate2.m
%> @brief Implements QRotationGate2 class.
% ==============================================================================
%> @class QRotationGate2
%> @brief Base class for 2-qubit rotation gates.
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QRotationGate2 < qclab.qgates.QGate2 & ...
                          qclab.QAdjustable
                        
  properties (Access = protected)
    %> Qubits of this 2-qubit rotation gate
    qubits_(1,2)    int32
    %> Quantum rotation of this rotation gate.
    rotation_(1,1)  qclab.QRotation
  end
  
  methods
    
    % Class constructor  =======================================================
    %> @brief Constructor for 2-qubit quantum rotation gates
    %>
    %> Calls constructor from:
    %> - qclab.QRotation
    %> 
    %> The QRotationGate2 constructor supports 6 ways of constructing a 2-qubit
    %> quantum rotation gate:
    %>
    %> 1. QRotationGate2() : Rotation gate with `qubits` set to [0, 1] and 
    %>    \f$\theta = 0\f$.
    %>
    %> 2. QRotationGate2(qubits) : Rotation gate with `qubits` set to `qubits` 
    %>    and \f$\theta = 0\f$.
    %>
    %> 3. QRotationGate2(qubits, angle, fixed) : Rotation gate with `qubits` set
    %>    to `qubits` and with the given quantum angle `angle` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 4. QRotationGate2(qubits, rotation, fixed) : Rotation gate with `qubits`
    %>    set to `qubits` and with the given quantum rotation `rotation` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 5. QRotationGate2(qubits, theta, fixed) : Rotation gate with `qubits` set 
    %>    to `qubits` and with the given quantum angle `angle` = \f$\theta/2\f$
    %>    and the flag `fixed`. The default of `fixed` is false.
    %>
    %> 6. QRotationGate2(qubits, cos, sin, fixed) : Rotation gate with `qubits`
    %>    set to `qubits` and with the given values `cos` = \f$\cos(\theta/2)\f$ 
    %>    and `sin` = \f$\sin(\theta/2)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param qubits Qubits input argument.
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - rotation, fixed
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
    % ==========================================================================
    function obj = QRotationGate2(qubits, varargin)
      if nargin == 0
        qubits = [0, 1];
      end
      obj@qclab.QAdjustable(false); 
      obj.setQubits( qubits );
      if nargin < 2 % empty or default constructor
        obj.rotation_ = qclab.QRotation();
      elseif nargin == 2 % either angle, rotation, theta
        obj.rotation_ = qclab.QRotation( varargin{1} );
      elseif nargin == 3 % either angle, rotation, theta + fixed or cos, sin
        if isa( varargin{2}, 'logical' )
          obj.rotation_ = qclab.QRotation( varargin{1} );
          if varargin{3}, obj.makeFixed; end
        else
          obj.rotation_ = qclab.QRotation( varargin{1}, varargin{2} );
        end
      else % cos, sin + fixed
        obj.rotation_ = qclab.QRotation( varargin{1}, varargin{2} );
        if varargin{3}, obj.makeFixed; end
      end
      
    end
    
    % qubit
    function [qubit] = qubit(obj)
      qubit = obj.qubits_(1);
    end
    
    % qubits
    function [qubits] = qubits(obj)
      qubits = obj.qubits_ ;
    end
    
    % setQubits
    function setQubits(obj, qubits)
      assert(qclab.isNonNegIntegerArray(qubits));
      assert(qubits(1) ~= qubits(2));
      obj.qubits_ = sort(qubits(1:2)) ;
    end
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if obj.equalType(other)
        bool = (obj.rotation_ == other.rotation_) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QGate2( obj );
      objprime.update( -obj.angle );
    end
    
    %> @brief Checks if `other` is equal to this QRotationGate2.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    
    %> @brief Checks if `other` is different from this QRotationGate2.
    function [bool] = ne(obj,other)
      bool = ~obj.equals(other);
    end
    
    %> @brief Returns a copy of the quantum rotation \f$\theta/2\f$ 
    %> of this rotation gate.
    function rotation = rotation(obj)
      rotation = copy( obj.rotation_ );
    end
    
    %> @brief Returns a copy of the quantum angle \f$\theta/2\f$ 
    %> of this rotation gate.
    function angle = angle(obj)
      angle = obj.rotation_.angle;
    end
    
    %> @brief Returns the numerical value \f$\theta/2\f$ of this rotation gate.
    function theta = theta(obj)
      theta = obj.rotation_.theta ;
    end
    
    %>  @brief Returns the cosine \f$\cos(\theta/2)\f$ of this rotation gate.
    function cos = cos(obj)
      cos = obj.rotation_.cos ;
    end
    
    %> @brief Returns the sine \f$\sin(\theta/2)\f$ of this rotation gate.
    function sin = sin(obj)
      sin = obj.rotation_.sin ;
    end
    
    % ==========================================================================
    %> @brief Update this rotation gate
    %>
    %>
    %> The update function supports 4 ways of updating a rotation gate:
    %>
    %> 1. obj.update(angle) : where angle is a quantum angle, updates
    %>    cosine and sine of obj.rotation_ to values of angle.
    %>
    %> 2. obj.update(rotation) : where rotation is a quantum rotation, updates
    %>    cosine and sine of obj.rotation_ to rotation.
    %>
    %> 3. obj.update(theta) : updates cosine and sine of obj.rotation_ based on 
    %>    `theta`.
    %>
    %> 4. obj.update(cos, sin) : updates cosine and sine of obj.rotation_ 
    %>    with `cos`, `sin` values.
    %>
    %> @param obj QRotationGate2 object
    %> @param varargin Variable input argument, being either:
    %>  - QAngle object
    %>  - theta value
    %>  - cos, sin values
    % ==========================================================================
    function update(obj, varargin)
      assert( ~obj.fixed );
      obj.rotation_.update( varargin{:} );
    end
    
    %>  Turnover of pattern of three QRotationGate gates where the first and
    %>  third are QRotationGate2 objects of the same type.
    %>  
    %>  IN: -[obj]-[G2]-[G3]-     OUT: -[GA]-[GB]-[GC]-
    %> 
    %>  obj and G3 of same type (XX, YY, ZZ) on same nearest neighbor qubits
    %>  G2 of different type (X, Y, Z, XX, YY, ZZ) on overlapping qubits
    %>
    %>  GA and GC are of same type as G2 and act on same qubits
    %>  GB is of same type as obj and G3 and acts on same qubits
    function [GA, GB, GC] = turnover(obj, G2, G3)
      
      % Check qubits and type
      assert( ~obj.equalType(G2) && obj.equalType(G3) );

      % nearest neighbor
      qubits1 = obj.qubits;
      assert( qubits1(1) + 1 == qubits1(2) );
      
      qubits3 = G3.qubits;
      assert( qubits3(1) + 1 == qubits3(2) );

      assert( isequal(qubits1, qubits3) );
  
      qubits2 = G2.qubits;
      if isa( G2, 'qclab.qgates.QRotationGate2' )
        assert( qubits2(1) + 1 == qubits2(2) );
        assert( abs(qubits1(1) - qubits2(1)) == 1 );
      elseif isa( G2, 'qclab.qgates.QRotationGate1' )
        assert( max( abs(qubits1 - qubits2) ) == 1 );
      else
        error('unsupported input');
      end      

      % Create output objects of correct type
      GA = feval( class(G2) );
      GB = feval( class(obj) );
      GC = feval( class(G2) );
      
      [rGA, rGB, rGC] = ...
       qclab.turnoverSU2( obj.rotation, G2.rotation, G3.rotation );
     
      % update rotations
      GA.update( rGA );
      GB.update( rGB );
      GC.update( rGC );

      % update qubits
      GA.setQubits( qubits2 );
      GB.setQubits( qubits1 );
      GC.setQubits( qubits2 );

    end
    
    %> @brief Fuse two QRotationGate2 gates.
    %> side = 'R': -[obj]-[other]-
    %> side = 'L': -[other]-[obj]-
    %> Result is independent of side.
    function fuse(obj, other, side)
      if nargin == 2, side = 'R'; end
      assert(obj.equalType(other) && ~other.fixed && ...
             ~obj.fixed && isequal(obj.qubits,other.qubits));
      obj.update( obj.angle + other.angle ) ;
    end
    
    %> @brief Multiplication of two QRotationGate2 objects of equal type
    %> on same qubits:  -[ out ]- = -[ obj ]--[ other ]-
    function [out] = mtimes(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = copy(obj);
      out.update( obj.angle + other.angle );
    end
    
    %> @brief Right division of two QRotationGate2 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]--[ other ]'-
    function [out] = mrdivide(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = copy(obj);
      out.update( obj.angle - other.angle );
    end
    
    %> @brief Left division of two QRotationGate2 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]'--[ other ]-
    function [out] = mldivide(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = copy(obj);
      out.update( other.angle - obj.angle )
    end
    
    %> @brief Inverse of this QRotationGate2 that results in a QRotationGate2
    %> `out`: -[ out ]- = -[ obj ]'-
    function [out] = inv(obj)
      out = copy( obj );
      out.update( -obj.angle );
    end
    
  end
  
  methods ( Access = protected )
    
    %> @brief Override copyElement function to allow for correct deep copy of
    %> handle
    function cp = copyElement(obj)
      cp = copyElement@matlab.mixin.Copyable( obj );
      cp.rotation_ = obj.rotation ;
    end
    
  end
  
  methods (Static)
    
    % controlled
    function [bool] = controlled
      bool = false;
    end
    
  end
  
  methods (Abstract)
    
    %> checks if other is of the same type as this
    [bool] = equalType(obj, other)
    
  end
                        
end % QRotationGate2
