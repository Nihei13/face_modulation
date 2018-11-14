function [norm_face, norm_pts] = face_norm2(img,pts, L)
% face_norm for FaceDB OSU
% Er = 1
% El = 10
% nose bottom = 44

const_L = L;

const_D = round(const_L * 0.85);

Y = 3 * const_D / 2;

gap = const_L / 10;

face_L = pts(77,1) - pts(65,1);

face_D = pts(71,2) - pts(35,2);

D_rate = const_D / face_D;

L_rate = const_L / face_L;

tform = affine2d([L_rate 0 0; 0 D_rate 0; 0 0 1]);

scaled_img = imwarp(img, tform);

new_pts = [pts(:,1) * L_rate, pts(:,2) * D_rate];

%%
% figure, imshow(scaled_img);
% hold on
% % scatter(faceCoordinatesUnwarped(:,1), faceCoordinatesUnwarped(:,2));
% 
% for i_fid = 1:length(norm_pts)
%     text(norm_pts(i_fid, 1),norm_pts(i_fid, 2),num2str(i_fid));
% end

%%
X = const_L + 2 * gap;

minX = round(new_pts(35,1)) - (const_L/2 + gap);
minY = round(new_pts(35,2)) - const_D/2;

norm_pts = [new_pts(:,1) - minX, new_pts(:,2) - minY];

norm_face = imcrop(scaled_img, [minX, minY, X, Y]);

end

