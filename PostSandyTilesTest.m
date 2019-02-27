clear all;clc;close all;
addpath(genpath('OceanMesh2D/'));
addpath(genpath('third-party/'));
addpath(genpath('datasets/'));
wl=30;
dt=0;
grade=0.25;
R=5;
slp=15; 
min_el = 1000;
max_el = 10000;
gdat{1} = geodata('shp', 'GSHHS_f_L1',...
                  'dem', 'topo15_compressed.nc',...
                  'bbox', [-100 -53; 5 52.5],...
                  'h0', min_el);
fh{1} = edgefx('geodata',gdat{1},'fs',R,'wl',wl,'slp',slp,...
                'max_el',max_el,'dt',dt,'g',grade);
dems = glob('datasets/*.nc');
dems(ismember(dems,'datasets/topo15_compressed.nc')) = [];
min_el = 100;
for i = 1:length(dems)
    shp = split(dems{i}, '/');
    shp = split(shp{end}, '.nc');
    shp = strcat(shp{1},'.shp');
    shp = strcat('datasets/coastline_', shp);
    gdat{i+1} = geodata('shp', shp,...
                         'dem',dems{i},...
                         'h0',min_el);
    fh{i+1} = edgefx('geodata',gdat{i+1},...
                    'fs',R,...
                    'wl',wl,...
                    'slp',slp,...
                    'max_el',max_el,...
                    'dt',dt,...
                    'g',grade);
end
mshopts = meshgen('ef',fh,'bou',gdat,'plot_on',1,'itmax',50);  
mshopts = mshopts.build; 
m = mshopts.grd;
m = interp(m,gdat); 
m.b = max(m.b,1); 
m = makens(m,'auto',gdat{1});
plot(m,'bd',1,'Sinusoidal');
plot(m,'b',1,'Sinusoidal');
write(m,'PostSandyTestMesh_min_el_100')
