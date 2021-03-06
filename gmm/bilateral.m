% Implements bilateral filter for color images.
function [B]= bilateral(A,P,m,n,w)

sigma_d=3;  % Space Extend of kernal, size of the considered neighborhood
sigma_r=0.1; % "minimum" amplitude of an edge
d = size(P,2);

A=reshape(A,m,n,3);
P=reshape(P,m,n,3);

% Pre-compute Gaussian domain weights.
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

% Rescale range variance (using maximum luminance).
sigma_r = 100*sigma_r;

% Create waitbar.
%h = waitbar(0,'Applying bilateral filter...');
%set(h,'Name','Bilateral Filter Progress');

% Apply bilateral filter.
dim = size(A);
B = zeros(dim);
for i = 1:dim(1)
   for j = 1:dim(2)
      
         % Extract local region.
         iMin = max(i-w,1);
         iMax = min(i+w,dim(1));
         jMin = max(j-w,1);
         jMax = min(j+w,dim(2));
         I = A(iMin:iMax,jMin:jMax,:);
         Pt = P(iMin:iMax,jMin:jMax,:);
      
         % Compute Gaussian range weights.
         dL = I(:,:,1)-A(i,j,1);
         da = I(:,:,2)-A(i,j,2);
         db = I(:,:,3)-A(i,j,3);
         H = exp(-(dL.^2+da.^2+db.^2)/(2*sigma_r^2));%?? why is not abs?
      
         % Calculate bilateral filter response.
         F = H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
         for k=1:d
            sF(k) = sum(sum(F.*Pt(:,:,k)));
         end 
         norm_F=sum(sF);
         B(i,j,:) = sF/norm_F;
   end
end

B=reshape(B,m*n,d);

end