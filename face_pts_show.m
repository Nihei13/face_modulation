function face_pts_show(img,pts)

figure, imshow(img);
hold on
% scatter(faceCoordinatesUnwarped(:,1), faceCoordinatesUnwarped(:,2));

for i_fid = 1:length(pts)
    text(pts(i_fid, 1),pts(i_fid, 2),num2str(i_fid));
end

end

