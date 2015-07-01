function Obs = matchFeature(Sen,Raw,Obs)

% MATCHFEATURE  Match feature.
% 	Obs = MATCHFEATURE(Sen,Raw,Obs) matches one feature in Raw to the predicted
% 	feature in Obs.

%   Copyright 2008-2009 Joan Sola @ LAAS-CNRS.

switch Obs.ltype(4:6)
    case 'Pnt'
        switch Raw.type
            case {'simu', 'dump'}
            	rawDataLmks = Raw.data.points;
            	R = Sen.par.pixCov;
            case 'image'
            	% Maybe stuff for image is needed?
            otherwise
                error('??? Unknown Raw data type ''%s''.',Raw.type)
        end
    case 'Lin'
        rawDataLmks = Raw.data.segments;
        R = blkdiag(Sen.par.pixCov,Sen.par.pixCov);
    otherwise
        error('??? Unknown landmark type ''%s''.',Obs.ltype);
end

switch Raw.type
    
    case {'simu','dump'}
        
        id  = Obs.lid;
        idx = find(rawDataLmks.app==id);
        
        if ~isempty(idx)
            Obs.meas.y   = rawDataLmks.coord(:,idx);
            Obs.meas.R   = R;
            Obs.measured = true;
            Obs.matched  = true;
        else
            Obs.meas.y   = zeros(size(Obs.meas.y));
            Obs.meas.R   = R;
            Obs.measured = false;
            Obs.matched  = false;
        end
        
    case 'image'
        % TODO: the 'image' case
        
        % Rectangular search region centred around Obs.exp.e
        % ?sqrt(diag(Obs.exp.E))
        centre = round(Obs.exp.e);                              % mean
        bounds = round(sqrt(diag(Obs.exp.E)));                  % ?3sigma in u and v direction.
        
        
        % while loop(s) here to make sure none of the values in xSearch and
        % ySearch are invalid
        while(false) % While the Rectangle is outside of the image.
           % need to change the value of centre in the right axis
           % then recalculate bounds. 
        end
        
        xSearch = (centre(1)-bounds(1)):(centre(1)+bounds);     % x,y for region
        ySearch = (centre(2)-bounds(2)):(centre(2)+bounds(2));
        
        % sRegion = Raw.data.img(xSearch,...
        %     ySearch); % rectangular search region
        
        % error('??? Feature matching for Raw data type ''%s'' not implemented yet.', Raw.type)
        
        
    otherwise
        
        error('??? Unknown Raw data type ''%s''.',Raw.type)
        
end



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

