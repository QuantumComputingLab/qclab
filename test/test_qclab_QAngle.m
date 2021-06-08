classdef test_qclab_QAngle < matlab.unittest.TestCase
  methods (Test)
    function test_QAngle(test)
      angle = qclab.QAngle ;
      test.verifyEqual( angle.cos, 1.0 );          % cos
      test.verifyEqual( angle.sin, 0.0 );          % sin
      test.verifyEqual( angle.theta, 0.0 );        % theta
      
      % update(angle)
      new_angle = qclab.QAngle( 1 );
      angle.update( new_angle ) ;
      test.verifyEqual( angle.theta, 1.0, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos( 1 ), 'AbsTol', eps );
      test.verifyEqual( angle.sin, sin( 1 ), 'AbsTol', eps );
      
      % update(theta)
      angle.update( pi/2 );
      test.verifyEqual( angle.theta, pi/2, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos(pi/2), 'AbsTol', eps);
      test.verifyEqual( angle.sin, sin(pi/2), 'AbsTol', eps);
      
      % update(cos, sin)
      angle.update( cos(pi/3), sin(pi/3) );
      test.verifyEqual( angle.theta, pi/3, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos(pi/3), 'AbsTol', eps);
      test.verifyEqual( angle.sin, sin(pi/3), 'AbsTol', eps);
      
      % angle greater than pi
      angle.update( pi + 1 );
      test.verifyNotEqual( angle.theta, pi + 1);
      test.verifyEqual( angle.theta, -pi + 1, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos(pi + 1), 'AbsTol', eps);
      test.verifyEqual( angle.sin, sin(pi + 1), 'AbsTol', eps);
      
      % angle smaller than -pi
      angle.update( -pi - 1 );
      test.verifyNotEqual( angle.theta, -pi - 1);
      test.verifyEqual( angle.theta, pi - 1, 'AbsTol', eps );
      test.verifyEqual( angle.cos, cos(-pi - 1), 'AbsTol', eps);
      test.verifyEqual( angle.sin, sin(-pi - 1), 'AbsTol', eps);
      
      % operators == and ~=
      test.verifyTrue( angle ~= new_angle );
      test.verifyFalse( angle == new_angle );
      new_angle.update( angle );
      test.verifyTrue( angle == new_angle );
      test.verifyFalse( angle ~= new_angle );
      
      % plus
      angle1 = qclab.QAngle( 1 );
      angle2 = qclab.QAngle( 2 );
      angle1plus2 = angle1 + angle2 ;
      test.verifyEqual( angle1plus2.theta, 3, 'AbsTol', eps );
      angle2plus1 = angle2 + angle1 ;
      test.verifyEqual( angle2plus1.theta, 3, 'AbsTol', eps );
      test.verifyTrue( angle1plus2 == angle2plus1 );
      
      % minus
      angle1minus2 = angle1 - angle2;
      test.verifyEqual( angle1minus2.theta, -1, 'AbsTol', eps );
      angle2minus1 = angle2 - angle1;
      test.verifyEqual( angle2minus1.theta, 1, 'AbsTol', eps );
      test.verifyTrue( angle1minus2 == -angle2minus1 );
      
      % uminus
      anglem1 = qclab.QAngle( -1 );
      test.verifyEqual( -anglem1.theta, 1, 'AbsTol', eps );
      test.verifyTrue( anglem1 == -angle1 );
      
      % wrap sum over pi
      angle1 = qclab.QAngle( 1.5 );
      test.verifyEqual( angle1.theta, 1.5, 'AbsTol', eps);
      angle2 = qclab.QAngle( 2.4 );
      test.verifyEqual( angle2.theta, 2.4, 'AbsTol', eps);
      angle1plus2 = angle1 + angle2 ;
      test.verifyNotEqual( angle1plus2.theta, 3.9);
      test.verifyEqual( angle1plus2.theta, 3.9 - 2*pi, 'AbsTol', 10*eps );
      
      % wrap minus under -pi
      anglem1minus2 = -angle1 - angle2 ;
      test.verifyNotEqual( anglem1minus2.theta, -3.9);
      test.verifyEqual( anglem1minus2.theta, -3.9 + 2*pi, 'AbsTol', 10*eps );
      

    end
  end
end