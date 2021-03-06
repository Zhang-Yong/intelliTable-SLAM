function [z,J,H] = f21(x)

% F21, 2-input , 1-output MIMO function for linearity test purposes.
%   [z, J, H] = F321(x) with x=[x1;x2] returns z, the Jacobian
%   J(1-by-2) and the Hessian H(1-by-2-by-2).
%
%   See also F32, LINVEC, LINMAT, LINIDX.

[x1,x2] = split(x);

z = x1*sin(x2);

if nargout > 1
    J = [sin(x2) x1*cos(x2)];
    
    if nargout > 2
        H(:,:,1) = [   0        cos(x2)];
        H(:,:,2) = [cos(x2) -x1*sin(x2)];

    end
end
return

%% jac
syms x1 x2 x3 real
x = [x1;x2;x3];

z = fun(x);

J = jacobian(z,x)
H1 = diff(J,'x1')
H2 = diff(J,'x2')
H3 = diff(J,'x3')



% ========== End of function - Start GPL license ==========


%   # START GPL LICENSE

%---------------------------------------------------------------------
%
%   This file is part of SLAMTB, a SLAM toolbox for Matlab.
%
%   SLAMTB is free software: you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation, either version 3 of the License, or
%   (at your option) any later version.
%
%   SLAMTB is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You should have received a copy of the GNU General Public License
%   along with SLAMTB.  If not, see <http://www.gnu.org/licenses/>.
%
%---------------------------------------------------------------------

%   SLAMTB is Copyright:
%   Copyright (c) 2008-2010, Joan Sola @ LAAS-CNRS,
%   Copyright (c) 2010-2013, Joan Sola,
%   Copyright (c) 2014-    , Joan Sola @ IRI-UPC-CSIC,
%   SLAMTB is Copyright 2009 
%   by Joan Sola, Teresa Vidal-Calleja, David Marquez and Jean Marie Codol
%   @ LAAS-CNRS.
%   See on top of this file for its particular copyright.

%   # END GPL LICENSE

