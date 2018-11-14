clear
close all;

morphing_path = './morphing/';

addpath(morphing_path);

db_dir = './FaceDB/';

img_dir = 'Identities/';
pts_dir = 'Fiducial_points/';

%% choose facial expression
% 01:neutral, 02:happy, 03:sad
% 04:fearful, 05:angry, 06:surprised
% 07:disgusted, 08:h-suprised, 09:h-dis
% 10:sadly-fear, 11:sadly-angry, 12:sadly-supr
% 13:sadly-disgusted, 14:fear-angry
% 15:fear-sur, 16:fear-dis, 17:ang-sur
% 18:ang-disgust, 19:disgust-sur
% 20:appalled, 21:hatred, 22:awed

FE_label = {
    'Neutral';  %1
    'Happy';    %2
    'Sad';      %3
    'Fearful';  %4
    'Angry';    %5
    'Surprised';
    'Disgusted';
    'Happy-Surprised';
    'Happy-Disgusted';
    'Sadly-Fearful';
    'Sadly-Angry';
    'Sadly-Surprised';
    'Sadly-Disgusted';
    'Fearly-Angry';
    'Fearly-Surprised';
    'Fearly-Disgusted';
    'Angry-Surprised';
    'Angry-Disgusted';
    };
fe_num1 = 4;
fe_num2 = 5;
face_list = [4,21,75,179,228];
%[7,9,65,175,181];
%[41,51,54,132,210];
%[37,40,63,184,204];
for i_face = 1:length(face_list)
    
    face_num = num2str(face_list(i_face), '%03d');
    
    img_list = dir(strcat(db_dir, img_dir, '*', face_num, '.jpg'));
    Fiducial_list = dir(strcat(db_dir, pts_dir, '*', face_num, '.mat'));
    
    %%
    
    img1 = imread(fullfile(db_dir, img_dir, img_list(fe_num1).name));
    pts1 = load(fullfile(db_dir, pts_dir, Fiducial_list(fe_num1).name));
    
    img2 = imread(fullfile(db_dir, img_dir, img_list(fe_num2).name));
    pts2 = load(fullfile(db_dir, pts_dir, Fiducial_list(fe_num2).name));
    
    %%
    
    % --------- Specify the following parameters --------- %
    im1_name = FE_label{fe_num1};
    im2_name = FE_label{fe_num2};
    SAVE_FRAMES = true; % 'true': save intermediate frames
    frames_num = 7; % shouldn't be too large
    second_each_frame = 0.1;
    ext = '.jpg';
    % input_dir = 'input';
    output_dir = ['output/', face_num, '-', im1_name, '_', im2_name, filesep];
    % ---------------------------------------------------- %
    
    % init
    % Extension of images (mean face/frames) is the same as im1 by default
    im_midway_name = [im1_name, '_', im2_name, '_midway', ext];
    gif_name = [im1_name, '_to_', im2_name, '.gif'];
    
    im_midway_path = [output_dir, filesep, im_midway_name];
    Mask_path = [output_dir, filesep, 'Mask/'];
    gif_path = [output_dir, filesep, gif_name];
    % im1_pts_path = [input_dir, filesep, im1_name, '.mat'];
    % im2_pts_path = [input_dir, filesep, im2_name, '.mat'];
    
    % assert(exist(im1_path, 'file')==2,'Path %s of image 1 not found.',im1_path);
    % assert(exist(im2_path, 'file')==2,'Path %s of image 2 not found.',im2_path);
    if ~exist(output_dir, 'dir')
        mkdir(output_dir)
    end
    
    if ~exist(Mask_path, 'dir')
        mkdir(Mask_path)
    end
    %%
    
    D_size = 300;
    
    im1 = im2double(img1);
    im1_pts = pts1.faceCoordinatesUnwarped;
    
    [Trim_im1, im1_pts] = face_norm2(im1, im1_pts, D_size);
    
    im2 = im2double(img2);
    
    im2_pts = pts2.faceCoordinatesUnwarped;
    
    [Trim_im2, im2_pts] = face_norm2(im2, im2_pts, D_size);
    
    pts_mean = (im1_pts + im2_pts) / 2;
    tri = delaunay(pts_mean);
    
    im1 = Trim_im1;
    im2 = Trim_im2;
    %%
    % Computing the "Mid-way Face"
    morphed_mean_im = morph(im1, im2, im1_pts, im2_pts, tri, 0.5, 0.5);
    
    %%
    [im_y, im_x, im_z] = size(morphed_mean_im);
    trim_size = [ round(pts_mean(76,1) - pts_mean(64,1)) - D_size/10, im_y - D_size/10];
    
    h = imshow(morphed_mean_im);
    trim_area = [
        im_x/2 - trim_size(1)/2, im_y/2 - trim_size(2)/2,...
        trim_size(1), trim_size(2)];
    
    e = imellipse(gca, trim_area);
    
    %
    BW = createMask(e,h);
    % here assuming your image is uint8
    % BW = uint8(BW);
    morphed_mean_im2 = morphed_mean_im.*BW; % everything outside circle to black
    
    close
    %%
    imwrite(morphed_mean_im2, im_midway_path);
    % triplot(tri,im1_pts(:,1),im1_pts(:,2));
    % The Morph Sequence
    frame = 0;
    for frac = linspace(0, 1, frames_num)
        disp(['Processing #', num2str(frame), ' frame']);
        [morphed_im, morphed_pts] = morph2(im1, im2, im1_pts, im2_pts, tri, frac, frac);
        %     face_pts_show(morphed_im, morphed_pts)
        morphed_im2 = morphed_im.*BW;
        
        [width, height] = size(rgb2gray(morphed_im2));
        Mask = zeros(width, height);
        
        mask_region = [
            2:9;
            11:18;
            50:57;
            ];
        
        for i_region = 1:size(mask_region, 1)
            % left eye
            X1 = morphed_pts(mask_region(i_region, :), 1);
            Y1 = morphed_pts(mask_region(i_region, :), 2);
            
            J = poly2mask(X1, Y1, width, height);
            
            % here assuming your image is uint8
            mask(:,:,i_region) = J;
            Mask = Mask + mask(:,:,i_region);
        end
        
        if SAVE_FRAMES == true
            frame_name = [im1_name,'_to_',im2_name,'_',num2str(frame),ext];
            frame_path = [output_dir, filesep, frame_name];
            Mask_file_path = [Mask_path, filesep, frame_name];
            imwrite(morphed_im2, frame_path);
            imwrite(Mask, Mask_file_path);
        end
        % imshow(morphed_im);
        % write to animated gif
        [A,map] = rgb2ind(morphed_im2, 256);
        if frac == 0
            imwrite(A,map,gif_path,'gif','LoopCount',...
                Inf,'DelayTime',second_each_frame);
        else
            imwrite(A,map,gif_path,'gif','WriteMode',...
                'append','DelayTime',second_each_frame);
        end
        frame = frame + 1;
    end
end
