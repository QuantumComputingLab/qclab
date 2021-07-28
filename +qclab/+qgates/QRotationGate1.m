%> @file QRotationGate1.m
%> @brief Implements QRotationGate1 class.
% ==============================================================================
%> @class QRotationGate1
%> @brief Base class for 1-qubit rotation gates.
%>
%> Abstract base class for 1-qubit rotation gates.
%> Concrete subclasses have to implement:
%> - equals       % defined in qclab.QObject
%> - toQASM       % defined in qclab.QObject
%> - matrix       % defined in qclab.QObject
%
% (C) Copyright Daan Camps and Roel Van Beeumen 2021.  
% ==============================================================================
classdef QRotationGate1 < qclab.qgates.QGate1 & ...
                          qclab.QAdjustable
                        
  properties (Access = protected)
    %> Quantum rotation of this rotation gate.
    rotation_(1,1)   qclab.QRotation
  end

  methods
    % Class constructor  =======================================================
    %> @brief Constructor for 1-qubit quantum rotation gates
    %>
    %> Calls constructors from:
    %> - qclab.qgates.QGate1
    %> - qclab.QAdjustable
    %> 
    %> The QRotationGate1 constructor supports 6 ways of constructing a 1-qubit
    %> quantum rotation gate:
    %>
    %> 1. QRotationGate1() : Rotation gate with `qubit` set to 0 and 
    %>    \f$\theta = 0\f$.
    %>
    %> 2. QRotationGate1(qubit) : Rotation gate with `qubit` set to `qubit` and 
    %>    \f$\theta = 0\f$.
    %>
    %> 3. QRotationGate1(qubit, angle, fixed) : Rotation gate with `qubit` set
    %>    to `qubit` and with the given quantum angle `angle` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 4. QRotationGate1(qubit, rotation, fixed) : Rotation gate with `qubit` set
    %>    to `qubit` and with the given quantum rotation `rotation` and the 
    %>    flag `fixed`. The default of `fixed` is false.
    %>
    %> 5. QRotationGate1(qubit, theta, fixed) : Rotation gate with `qubit` set 
    %>    to `qubit` and with the given quantum angle `angle` = \f$\theta/2\f$
    %>    and the flag `fixed`. The default of `fixed` is false.
    %>
    %> 6. QRotationGate1(qubit, cos, sin, fixed) : Rotation gate with `qubit`
    %>    set to `qubit` and with the given values `cos` = \f$\cos(\theta/2)\f$ 
    %>    and `sin` = \f$\sin(\theta/2)\f$ and the flag `fixed`. The default of 
    %>     `fixed` is false.
    %>
    %> If `fixed` is provided, it must be of `logical` type.
    %>
    %> @param qubit Qubit input argument.
    %> @param varargin Variable input argument, being either:
    %>  - empty
    %>  - angle, (fixed)
    %>  - rotation, fixed
    %>  - theta, (fixed)
    %>  - cos, sin, (fixed)
    % ==========================================================================
    function obj = QRotationGate1(qubit, varargin)
      if nargin == 0
        qubit = 0;
      end
      obj@qclab.qgates.QGate1( qubit );
      obj@qclab.QAdjustable(false); 
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
    
    % equals
    function [bool] = equals(obj,other)
      bool = false;
      if obj.equalType(other)
        bool = (obj.rotation_ == other.rotation_) ;
      end
    end
    
    % ctranspose
    function objprime = ctranspose( obj )
      objprime = ctranspose@qclab.qgates.QGate1( obj );
      objprime.update( -obj.angle );
    end
    
    %> @brief Checks if `other` is equal to this QRotationGate1.
    function [bool] = eq(obj,other)
      bool = obj.equals(other);
    end
    
    %> @brief Checks if `other` is different from this QRotationGate1.
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
    %> @param obj QRotationGate1 object
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
    %>  third are QRotationGate1 objects of the same type.
    %>  
    %>  IN: -[obj]-[G2]-[G3]-     OUT: -[GA]-[GB]-[GC]-
    %> 
    %>  obj and G3 of same type (X, Y, Z) on same qubits
    %>  G2 of different type (X, Y, Z, XX, YY, ZZ) on overlapping qubits
    %>
    %>  GA and GC are of same type as G2 and act on same qubits
    %>  GB is of same type as obj and G3 and acts on same qubits
    function [GA, GB, GC] = turnover(obj, G2, G3)
      % Check qubits and type
      assert( ~obj.equalType(G2) && obj.equalType(G3) );

      qubit1 = obj.qubit;      
      qubit3 = G3.qubit;
      assert( isequal(qubit1, qubit3) );
  
      qubits2 = G2.qubits;
      if isa( G2, 'qclab.qgates.QRotationGate2' )
        assert( qubits2(1) + 1 == qubits2(2) );
        assert( max( abs(qubit1 - qubits2)  ) == 1 );
      elseif isa( G2, 'qclab.qgates.QRotationGate1' )
        assert( isequal(qubit1, qubits2) );
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
      GB.setQubits( qubit1 );
      GC.setQubits( qubits2 );

    end

    %> @brief Fuse two QRotationGate1 gates.
    %> side = 'R': -[obj]-[other]-
    %> side = 'L': -[other]-[obj]-
    %> Result is independent of side.
    function fuse(obj, other, side)
      if nargin == 2, side = 'R'; end
      assert(obj.equalType(other) && ~other.fixed && ...
             ~obj.fixed && isequal(obj.qubit,other.qubit));
      obj.update( obj.angle + other.angle ) ;
    end
    
    %> @brief Multiplication of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]--[ other ]-
    function [out] = mtimes(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = copy(obj);
      out.update( obj.angle + other.angle );
    end
    
    %> @brief Right division of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]--[ other ]'-
    function [out] = mrdivide(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = copy(obj);
      out.update( obj.angle - other.angle );
    end
    
    %> @brief Left division of two QRotationGate1 objects of equal type
    %> on same qubits: -[ out ]- = -[ obj ]'--[ other ]-
    function [out] = mldivide(obj,other)
      assert( obj.equalType(other) && obj.qubit == other.qubit );
      out = copy(obj);
      out.update( other.angle - obj.angle );
    end
    
    %> @brief Inverse of this QRotationGate1 that results in a QRotationGate1
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
  
  methods (Abstract)
    
    %> checks if other is of the same type as this
    [bool] = equalType(obj, other)
    
  end
  
end % QRotationGate1
