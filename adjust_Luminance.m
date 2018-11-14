% clear all;close all;

in = output_img_path;
out = output_lum_stim_path;
moveto = output_stim_path;

listing = dir([in, '*.jpg']);

num_img = length(listing);
images_L = cell(num_img,1);
images_a = cell(num_img,1);
images_b= cell(num_img,1);

for J = 1:size(listing)

    Origin = imread([in, listing(J).name]);
    tmp = rgb2lab(Origin);
    
    tmp(tmp < 3) = 0;
    images_L{J,1} = tmp(:,:,1);
    images_a{J,1} = tmp(:,:,2);
    images_b{J,1} = tmp(:,:,3);
end

%%
newimages1 = SHINE(images_L);
newimages1 = SHINE(newimages1);
% newimages1 = SHINE(images_L);
% newimages2 = SHINE(images_a);
% newimages3 = SHINE(images_b);

newimages2 = images_a;
newimages3 = images_b;

%%
for J = 1:size(listing)
    tmp1(:,:,1) = newimages1{J,1};
    tmp1(:,:,2) = newimages2{J,1};
    tmp1(:,:,3) = newimages3{J,1};
    RGB = uint8(lab2rgb(double(tmp1))*255);
    imwrite(RGB,[out, listing(J).name]);
    copyfile([out, listing(J).name], [output_stim_path, listing(J).name]);
    
    imwrite(tmp1,[out, listing(J).name(1:end - 4), '.tif'], 'tif', 'ColorSpace','cielab');
end
