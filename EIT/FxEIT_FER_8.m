function [imdl,Proj_Mat] = FxEIT_FER_8(bd_n,thick,hmax,E_posi)
if nargin < 3
    bd_n=10;
    thick=0.05;
    hmax=0.05;
end

if nargin < 4
    E_posi(:,1) = cos(linspace(0,2*pi,17));
    E_posi(:,2) = -sin(linspace(0,2*pi,17));
    E_posi(end,:) = [];
end

%% Mesh Gen
option=[];
[Node,Element,erod,BndIndex,fnum,bnd]=func_MeshGeneration_Bd(E_posi,bd_n,thick,hmax,option);
%
indx_near_bd=find(fnum==1);
indx_interior=find(fnum==2);
% indx_near_bd=func_get_near_bd(Geom.Element,Geom.Node,Geom.BndIndex,8);

% Display Mesh result
pix=zeros(size(Element,1),1);
pix(indx_near_bd)=1;
pix(indx_interior)=2;
figure(2000);clf;
patch('Faces',Element,'Vertices',Node,'FaceVertexCData',pix,'FaceColor','flat','EdgeColor','None');
axis normal image off

%% Construct Reconstruction matrix
mm=size(Element,1);
isKyunghee=1;
Nskip=0;

mask = [1 2 8 9 10 11 18 19 20 27 28 29 36 37 38 45 46 47 54 55 56 57 63 64];
% Sensitivity=func_sensitivity_skip(Geom.Element,Geom.Node,Geom.erod,ones(mm,1),Nskip,isKyunghee);
[Sensitivity,Area]=func_sensitivity_skip_fast(Element,Node,erod,ones(mm,1),Nskip,isKyunghee);
Sensitivity(mask,:)=[];

%%
alpha=1*1e-5;
inv_Sense=(Sensitivity'*Sensitivity+alpha*eye(size(Sensitivity,2)))\(Sensitivity');

[R_WeightAvg,S_normal]=func_Recon_WeightedAvg(Sensitivity);
inv_Sense_corr_infty=S_normal';
% Kotre's formula
R_Kotre=diag(1./sum(Sensitivity))*Sensitivity';
R_Kotre_abs=diag(1./sum(abs(Sensitivity)))*Sensitivity';

%% Boundary Artifact Reduction
bd_alpha=1e-9;
Proj_Mat=func_bd_artifact_elim_newnew(Sensitivity,indx_interior,bd_alpha);

%% Data Export
imdl.fwd_model.name = 'FER_model';
imdl.fwd_model.nodes = Node;
imdl.fwd_model.elems = Element;

for i = 1:length(erod);
    imdl.fwd_model.electrode(1,i).nodes = erod(i);
    imdl.fwd_model.electrode(1,i).z_contact = 1.0e-3;
end
imdl.fwd_model.type = 'fwd_model';
imdl.fwd_model.normalize_measurements = 0;
imdl.fwd_model.solve = 'eidors_default';
imdl.fwd_model.system_mat = 'eidors_default';
imdl.fwd_model.jacobian = 'eidors_default';
imdl.fwd_model.gnd_node = 1;
imdl.fwd_model.boundary = find_boundary2(imdl.fwd_model);

imdl.solve = @solve_use_matrix;
imdl.reconst_type = 'difference'
imdl.jacobian_bkgnd.value = 1;
imdl.type = 'inv_model';
imdl.solve_use_matrix.RM = R_WeightAvg;
imdl.Proj_Mat = Proj_Mat;

function [srf, idx] = find_boundary2(simp);
% [srf, idx] = find_boundary(simp);
%
%Caclulates the boundary faces of a given 3D volume.
%Usefull in electrode assignment.
%
%srf  =  array of elements on each boundary simplex
%        boundary simplices are of 1 lower dimention than simp
%idx  =  index of simplex to which each boundary belongs
%simp = The simplices matrix

% $Id: find_boundary.m 4926 2015-05-07 23:10:02Z aadler $

if isstr(simp) && strcmp(simp,'UNIT_TEST'); do_unit_test; return; end
if isstruct(simp) && strcmp(simp.type,'fwd_model'); simp= simp.elems; end

wew = size(simp,2) - 1;

if wew==3 || wew==2
   [srf,idx]= find_2or3d_boundary(simp,wew);
elseif wew == 1
   [srf,idx]= find_1d_boundary(simp);
else
   eidors_msg('find_boundary: WARNING: not 1D, 2D or 3D simplices',1);
   srf=[]; return;
end

% sort surfaces. If there is more than one, its not on the boundary
function [srf,idx]= find_2or3d_boundary(simp,dim);
   if size(simp,1) < 4e9 % max of uint32
      % convert to integer to make sort faster
      simp = uint32( simp );
   end
   localface = nchoosek(1:dim+1,dim);
   srf_local= simp(:,localface');
   srf_local= reshape( srf_local', dim, []); % D x 3E
   srf_local= sort(srf_local)'; % Sort each row
   [sort_srl,sort_idx] = sortrows( srf_local );

   % Fine the ones that are the same
   first_ones =  sort_srl(1:end-1,:);
   next_ones  =  sort_srl(2:end,:);
   same_srl = find( all( first_ones == next_ones, 2) );

   % Assume they're all different. then find the same ones
   diff_srl = logical(ones(size(srf_local,1),1));
   diff_srl(same_srl) = 0;
   diff_srl(same_srl+1) = 0;

   srf= sort_srl( diff_srl,: );
   idx= sort_idx( diff_srl);
   idx= ceil(idx/(dim+1));

function [srf,idx]= find_1d_boundary(simp);
   if size(simp,1) < 4e9 % max of uint32
      % convert to integer to make sort faster
      simp = uint32( simp );
   end
   % we expect two nodes as a result
   idx = find(isunique(simp(:)) == 1);
   srf = simp(idx);
   idx = rem(idx-1,size(simp,1))+1;

function x = isunique(a);
   u=unique(a);
   n=histc(a,u);
   x=ismember(a,u(n==1));

function do_unit_test

%2D Test:  
mdl = mk_common_model('c2c',8);
bdy = find_boundary(mdl.fwd_model.elems);
bdy = sort_boundary(bdy);
bdyc= sort_boundary(mdl.fwd_model.boundary);

unit_test_cmp('2D test', bdy, bdyc);

%3D Test:  
mdl = mk_common_model('n3r2',[8,2]);
bdy = find_boundary(mdl.fwd_model.elems);
bdy = sort_boundary(bdy);
bdyc= sort_boundary(mdl.fwd_model.boundary);

unit_test_cmp( '3D test n3r2', bdy,bdyc);

%3D Test:  
mdl = mk_common_model('a3cr',8);
bdy = find_boundary(mdl.fwd_model.elems);
bdy = sort_boundary(bdy);
bdyc= sort_boundary(mdl.fwd_model.boundary);

unit_test_cmp('3D test a3c2', bdy, bdyc);

%3D Test:  
mdl = mk_common_model('b3cr',8);
bdy = find_boundary(mdl.fwd_model.elems);
bdy = sort_boundary(bdy);
bdyc= sort_boundary(mdl.fwd_model.boundary);

unit_test_cmp('3D test b3c2', bdy, bdyc);

simp = [  10 190; ...
         182 183; ...
         183 184; ...
         184 185; ...
          11 182; ...
         185 186; ...
         187 186; ...
         187 188; ...
         188 189; ...
         189 190];
[bdy, idx] = find_boundary(simp);
unit_test_cmp('1D bdy', bdy,[10;11]);
unit_test_cmp('1D bdy', idx,[1;5]);

function bdy= sort_boundary(bdy)
   bdy = sort(bdy,2);
   bdy = sortrows(bdy);

