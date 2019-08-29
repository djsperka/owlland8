function [gamma_inv, gamma_xaxis]=gamma_function_calc(xax,yax)
%inputs: 
%xax = the luminance values you input to psychtoolbox (from 0-1)
%yax = the luminance values you measured for each value you entered

%process: scale the luminance values to go from 0-1.  interpolate to get
%adequate number of points.  Then invert the gamma curve along the 45
%degree unity line.  

%output = gamma_inv and gamma_xaxis for the OwlLand calibration
%DJT 4/25/2014

yax_norm=(yax-min(yax))/ (max(yax)-min(yax)); %normalize yaxis to a 0-1 scale
xax_interp=[0:.01:1];
yax_interp=interp1(xax,yax_norm,xax_interp);


yax_trans=[];
for i=0:.025:1
    [~,index]=min(abs(yax_interp-i));
    yax_trans=[yax_trans,xax_interp(index)];
end
yax_t_i=interp1(0:.025:1,yax_trans,xax_interp);
figure
hold
plot (xax_interp,yax_t_i)
plot (xax_interp,yax_interp)

gamma_inv=yax_t_i;
gamma_xaxis=xax_interp;