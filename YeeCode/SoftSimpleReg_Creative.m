%winstyle = 'docked';
winstyle = 'normal';

set(0,'DefaultFigureWindowStyle',winstyle)
set(0,'defaultaxesfontsize',18)
set(0,'defaultaxesfontname','Times New Roman')
% set(0,'defaultfigurecolor',[1 1 1])

% clear VARIABLES;
clear
global spatialFactor;
global c_eps_0 c_mu_0 c_c c_eta_0
global simulationStopTimes;
global AsymForcing
global dels
global SurfHxLeft SurfHyLeft SurfEzLeft SurfHxRight SurfHyRight SurfEzRight



dels = 0.75;
spatialFactor = 1;

c_c = 299792458;                  % speed of light
c_eps_0 = 8.8542149e-12;          % vacuum permittivity
c_mu_0 = 1.2566370614e-6;         % vacuum permeability
c_eta_0 = sqrt(c_mu_0/c_eps_0);


tSim = 200e-15
f = 230e12;
%f = 100e12;
lambda = c_c/f;

%Setup region size
xMax{1} = 20e-6;
nx{1} = 200;
ny{1} = 0.75*nx{1};

%Number of simulation regions
Reg.n = 1;

%Setup epsilon and mu
mu{1} = ones(nx{1},ny{1})*c_mu_0;

epi{1} = ones(nx{1},ny{1})*c_eps_0;

%Adds the 'inclusions'
%epi{1}(125:150,55:95)= c_eps_0*11.3;

for i = 1:nx{1}
    for j = 1:ny{1}
        r = sqrt(((nx{1}/2)-i)^2 + ((ny{1}/2)-j)^2);
        if ((r>20 && r<30) || (r>40 && r<50))
            epi{1}(i,j)= c_eps_0*11.3;
        end
    end
end

sigma{1} = zeros(nx{1},ny{1});
sigmaH{1} = zeros(nx{1},ny{1});

dx = xMax{1}/nx{1};
dt = 0.25*dx/c_c;
nSteps = round(tSim/dt*2);
yMax = ny{1}*dx;
nsteps_lamda = lambda/dx

movie = 1;
Plot.off = 0;
Plot.pl = 0;
Plot.ori = '13';
Plot.N = 100;
Plot.MaxEz = 1.1;
Plot.MaxH = Plot.MaxEz/c_eta_0;
Plot.pv = [0 0 90];
Plot.reglim = [0 xMax{1} 0 yMax];

%Define boundary conditions and set sources
% bc{1}.NumS = 1;
bc{1}.NumS = 2;
bc{1}.s(1).xpos = nx{1}/(4) + 1;
bc{1}.s(1).type = 'ss';
bc{1}.s(1).fct = @PlaneWaveBC; %Internal non-reflective plane wave source

bc{1}.s(2).xpos = nx{1}/(4) + 1;
bc{1}.s(2).type = 'ss';
bc{1}.s(2).fct = @PlaneWaveBC; %Internal non-reflective plane wave source

% mag = -1/c_eta_0;
mag = 1;
phi = 0;
omega = f*2*pi;
betap = 0;
t0 = 30e-15;
%st = 15e-15;
st = -0.05;
s = 0;
y0_1 = yMax/8;
y0_2 = 7*yMax/8;
sty = 1.5*lambda;
bc{1}.s(1).paras = {mag,phi,omega,betap,t0,st,s,y0_1,sty,'s'};
bc{1}.s(2).paras = {mag,phi,omega,betap,t0,st,s,y0_2,sty,'s'};

Plot.y0_1 = round(y0_1/dx);
Plot.y0_2 = round(y0_2/dx);

bc{1}.xm.type = 'a';
bc{1}.xp.type = 'a';
bc{1}.ym.type = 'a';
bc{1}.yp.type = 'a';

pml.width = 20 * spatialFactor;
pml.m = 3.5;

Reg.n  = 1;
Reg.xoff{1} = 0;
Reg.yoff{1} = 0;

%Calls 'RunYeeReg.m' which implements 'Yee2DEM.m' to produce plots
RunYeeReg






