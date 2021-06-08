classdef test_qclab_QRotation < matlab.unittest.TestCase
  methods (Test)
    function test_QRotation(test)
      R = qclab.QRotation ;
      test.verifyEqual( R.cos, 1.0 );          % cos
      test.verifyEqual( R.sin, 0.0 );          % sin
      test.verifyEqual( R.theta, 0.0 );        % theta
      
      % update(angle)
      new_angle = qclab.QAngle( 0.5 );
      R.update( new_angle ) ;
      test.verifyEqual( R.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( R.cos, cos( 0.5 ), 'AbsTol', eps );
      test.verifyEqual( R.sin, sin( 0.5 ), 'AbsTol', eps );
      
      % update(theta)
      R.update( pi/2 );
      test.verifyEqual( R.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( R.cos, cos(pi/4), 'AbsTol', eps);
      test.verifyEqual( R.sin, sin(pi/4), 'AbsTol', eps);
      
      % update(cos, sin)
      R.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( R.theta, 2*pi/3, 'AbsTol', eps );
      test.verifyEqual( R.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( R.sin, sin(pi/3), 'AbsTol', eps);
      
      % angle greater than pi
      R.update( pi + 1 );
      test.verifyEqual( R.theta, pi + 1, 'AbsTol', eps);
      
      % angle greater than 2*pi
      R.update( 2*pi + 1 );
      test.verifyNotEqual( R.theta, 2*pi + 1);
      test.verifyEqual( R.theta, -2*pi + 1, 'AbsTol', eps);
      
      % angle smaller than -pi
      R.update( -pi - 1 );
      test.verifyEqual( R.theta, -pi - 1, 'AbsTol', eps);
      
      % angle smaller than -2*pi
      R.update( -2*pi - 1 );
      test.verifyNotEqual( R.theta, -2*pi - 1);
      test.verifyEqual( R.theta, 2*pi - 1, 'AbsTol', eps);
      
      % operators == and ~=
      R.update( cos(pi/3), sin(pi/3) );
      R2 = qclab.QRotation( cos(pi/3), sin(pi/3) );
      test.verifyTrue( R == R2 );
      test.verifyFalse( R ~= R2 );
      R2.update( 1 );
      test.verifyTrue( R ~= R2 );
      test.verifyFalse( R == R2 );
      
      % mtimes
      R1 = qclab.QRotation( 1 );
      R2 = qclab.QRotation( 2 );
      R1t2 = R1 * R2 ;
      test.verifyEqual( R1t2.theta, 3, 'AbsTol', eps );
      R2t1 = R2 * R1 ;
      test.verifyEqual( R2t1.theta, 3, 'AbsTol', eps );
      test.verifyTrue( R1t2 == R2t1 );
      
      % mrdivide
      R1mr2 = R1 / R2 ;
      R2mr1 = R2 / R1 ;
      test.verifyEqual( R1mr2.theta, - 1, 'AbsTol', eps );
      test.verifyEqual( R2mr1.theta, 1, 'AbsTol', eps );
      
      % mldivide
      R1ml2 = R1 \ R2 ;
      R2ml1 = R2 \ R1 ;
      test.verifyEqual( R1ml2.theta, 1, 'AbsTol', eps );
      test.verifyEqual( R2ml1.theta, -1, 'AbsTol', eps );
      
      % inv
      Ri1 = qclab.QRotation( -1 );
      iRi1 = inv(Ri1);
      test.verifyEqual( iRi1.theta, 1, 'AbsTol', eps );
      test.verifyTrue( Ri1 == inv(R1) );
      
      % wrap product over 2pi
      R1 = qclab.QRotation( 5 );
      test.verifyEqual( R1.theta, 5, 'AbsTol', eps);
      R2 = qclab.QRotation( 4 );
      test.verifyEqual( R2.theta, 4, 'AbsTol', eps);
      R1t2 = R1 * R2;
      test.verifyNotEqual( R1t2.theta, 9);
      test.verifyEqual( R1t2.theta, 9 - 4*pi, 'AbsTol', 10*eps );
      
      % wrap inv and mrdivide under -2pi
      Rm1minus2 = inv(R1) / R2;
      test.verifyNotEqual( Rm1minus2.theta, -9);
      test.verifyEqual( Rm1minus2.theta, -9 + 4*pi, 'AbsTol', 10*eps );
      
    end
  end
end