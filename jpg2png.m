clear
close all;

input_dir = './Stimuli/';
output_dir = './Stimuli/';

img_list = dir(strcat(input_dir, '/*.jpg'));
load('face_mask.mat');

for i_img = 1:length(img_list)
    img = imread(fullfile(input_dir, img_list(i_img).name));
    
    alpha = double(BW);
    imwrite(img, [output_dir, img_list(i_img).name(1:end-4), '.png'], 'Alpha', alpha);
    
end