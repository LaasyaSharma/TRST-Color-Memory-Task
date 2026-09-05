classdef Triangle
     properties
         x
         y
         height
         width
         triangCenterX
         triangCenterY
         rotationAngle
      end
   methods
       % class constructor
       function obj = Triangle(rotationAngle,triangCenterX,triangCenterY,triangHeight,triangWidth)
           obj.height = triangHeight;
           obj.width = triangWidth;
           obj.rotationAngle = rotationAngle;
           obj.triangCenterX = triangCenterX;
           obj.triangCenterY = triangCenterY;
       end
       
       % rotates a triangle by a given angle
       function [xRotated,yRotated] = rotateTriangle(obj)
            % x - x coordinates of 3 vertices
            % y - y coordinates of 3 vertices
            % triangCenterX -- x coordinate of triangle center
            % triangCenterY -- y coordinate of triangle center
            % thetaDeg -- rotation angle
            % returns xRotated and yRotated -- x and y coordinates of rotated triangle
            % create a matrix of these points, which will be useful in future calculations
            v = [obj.x;obj.y];
            
            % create a matrix which will be used later in calculations
            center = repmat([obj.triangCenterX; obj.triangCenterY], 1, length(obj.x));
            
            % define a theta degree counter-clockwise rotation matrix
            theta = deg2rad(obj.rotationAngle);     
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            
            % do the rotation
            s = v - center;     % shift points in the plane so that the center of rotation is at the origin
            so = R*s;           % apply the rotation about the origin
            vo = so + center;   % shift again so the origin goes back to the desired center of rotation
            
            % pick out the vectors of rotated x- and y-data
            xRotated = vo(1,:);
            yRotated = vo(2,:);
       end
       
       % returns an array of rotated triangle vertices for drawing the rotated triangle
       function tri_dimensions = setTriangleVertices(obj)
            x1 = obj.triangCenterX;
            y1 = obj.triangCenterY-obj.height/2;

            x2 = obj.triangCenterX-obj.width/2;
            y2 = obj.triangCenterY+obj.height/2;

            x3 = obj.triangCenterX+obj.width/2;
            y3 = obj.triangCenterY+obj.height/2;

            obj.x = [x1,x2,x3];
            obj.y = [y1,y2,y3];
        
            %rotate the triangle
            [xRotated,yRotated] = rotateTriangle(obj);
            
            tri_dimensions = [[xRotated(1),yRotated(1)]; [xRotated(2),yRotated(2)]; [xRotated(3),yRotated(3)]; [xRotated(1),yRotated(1)]];
       end
   end
end