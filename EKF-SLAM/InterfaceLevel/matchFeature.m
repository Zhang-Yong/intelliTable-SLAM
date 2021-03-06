function Obs = matchFeature(Sen,Raw,Obs,sig,scTh)

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
                R = Sen.par.pixCov;
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
        %% Create variables for the rectangular search region, sRegion
        %  Centre is mean (Obs.exp.e) with bounds 3 sigma (sqrt. of diag.
        %  of Obs.exp.E).
        
        centre = round(Obs.exp.e);                % mean
        bounds = round(sqrt(diag(Obs.inn.Z)));    % 3sigma in u and v direction.
        
        sBounds = [centre-bounds,centre+bounds];  % The search region for the feature
        if ~any(sBounds < 1)
            %% Store the predicted appearance of the landmark in Obs.app.pred
            %  Resize the appearance using a rotation and zoom factor to
            %  predict appearance in new position.

            % xDiff = abs(sig.pose0 - Sen.frame.x);            % Rotation and zoom factor
            Obs.app.pred = sig; % patchResize(sig.patch, xDiff);    % Predicted appeareance

            %% Scan the rectangular region for the modified patch using ZNCC
            pred = Obs.app.pred.patch;
            Obs.app.sc = -1;
            Obs.measured = false; % Reset measured to default value
            
            % NEEDS FIXING - THE c VALUE IS WRONG - STARTS FROM CENTRE,
            % ONLY GOES UP!
            
            % Scans the region to find the patch that best fits
            for i = 1:(sBounds(1,2)-sBounds(1,1)) % xBounds
                for j = 1:(sBounds(2,2)-sBounds(2,1)) % yBounds
                    % Generate patch to search
                    c = [i;j]+centre-1;% min(sBounds,[],2);
                    rPatch = pix2patch(Raw.data.img, c, 15);
                    
                    % Calculate score between patch in region and predicted
                    % appearance.
                    tmpSc = zncc(... % Can also use ssd (remove the SI values).
                        pred.I,     ...
                        rPatch.I,   ...
                        pred.SI,    ...
                        pred.SII,   ...
                        rPatch.SI,  ...
                        rPatch.SII);
                    % disp(tmpSc)%, rPatch.SI, pred.SI])
                    
                    % If the score is the current highest then update the
                    % values
                    if tmpSc > Obs.app.sc
                        Obs.app.sc      = tmpSc;    % Setting score and current appearance
                        Obs.app.curr    = struct(...
                                            'patch',    rPatch,...
                                            'pose0',     Sen.frame.x);   % for the patch
                        
                        Obs.meas.y      = c;    % Store best pixel
                        Obs.measured    = true;
                    end
                end
            end
            
            %% Test if the zncc score is above the threshold
            %  If so, set Obs.matched to true.
            if Obs.app.sc > scTh
            	Obs.matched = true; 
                % fprintf(f,'%d\n',1); % For recording match_rate - turn on
                % and feed file variable through from slamtb
            else
%                 Obs.meas.y   = zeros(size(Obs.meas.y));
%                 Obs.meas.R   = R;
                Obs.matched  = false;
                % fprintf(f,'%d\n',0);
            end
            
        end
        %% Error left in but commented out for possible future use.
        
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

