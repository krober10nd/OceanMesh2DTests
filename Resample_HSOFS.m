addpath(genpath('OceanMesh2D/'));
addpath(genpath('external/'));
wl=30;dt=0;grade=0.25;R=5;slp=15; 
bbox = [-100 -53
          5 52.5];
min_el = 1000;
max_el = 10000;
coastline = 'datasets/GSHHS_f_L1';
dem       = 'datasets/topo15_compressed.nc';
gdat{1} = geodata('shp',coastline,'dem',dem,'bbox',bbox,'h0',min_el);
fh{1} = edgefx('geodata',gdat{1},'fs',R,'wl',wl,'slp',slp,...
                'max_el',max_el,'dt',dt,'g',grade);
coastline = glob(strcat('datasets','/*.shp'));
dems = glob(strcat('datasets','/*.nc'));
for ii = 1:length(dems)
    % use same parameters as coarse mesh, just change min_el
    if ii == length(dems)
        min_el    = 10;  % minimum resolution in meters.
    else
        min_el    = 30;  % minimum resolution in meters.
    end
    % bbox is taken automatically from the DEM
    gdat{ii+1} = geodata('shp',coastline{ii},...
                         'dem',dems{ii},...
                         'h0',min_el);
    fh{ii+1} = edgefx('geodata',gdat{ii+1},...
                    'fs',R,...
                    'wl',wl,...
                    'slp',slp,...
                    'max_el',max_el,...
                    'dt',dt,...
                    'g',grade);
end

%% Pass your edgefx class objects along with some meshing options 
%% and build the mesh... 
% (note that the nested edgefxs will be smoothed together with this call)
mshopts = meshgen('ef',fh,'bou',gdat,'plot_on',1,'itmax',50);  
                                                
% now build the mesh with your options and the edge function.
mshopts = mshopts.build; 

% Get out the msh class from meshgen
m = mshopts.grd;

%% Interpolate on the bathy and gradients (automatically loops over all data)
m = interp(m,gdat); 
% % ensure max depth in domain is 1 m (we find this step useful for coastal
% % meshes to help with connectivity through narrow channels)
m.b = max(m.b,1); 

%% Make the nodestrings
m = makens(m,'auto',gdat{1}); % make the nodestring boundary conditions

%% Plot and save the msh class object/write to fort.14
plot(m,'bd',1,'Sinusoidal'); % plot on Sinusoidal projection with nodestrings
plot(m,'b',1,'Sinusoidal'); % plot the bathy on Sinusoidal projection
% Save as a msh class
% save('PRVI_msh.mat','m');
% Write an ADCIRC fort.14 compliant file to disk.
% write(m,'PRVI_mesh')
% for i = 1:length(tile_collection)
%     C = strsplit(char(tile_collection(i)), '/');
%     C = char(C{end});
%     C = strcat('NetCDF_DEM/',strcat(C(1:end-4),'.nc'));    
% end
