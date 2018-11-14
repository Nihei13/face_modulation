% clear all;
% close all;

Folder = output_lum_stim_path;
Mask = output_msk_path;

SAVE = {
%     'stim_L';
    'stim_a';
    'stim_b';
    };

val = [
%     [1 4 8];
    8;
    -8;
    ];

Lab = {
%     'L';
    'a';
    'b';
    };

for i_num = 1:length(SAVE)
    for v_num = 1:size(val, 2)
         
        reSAVE = [SAVE{i_num}, num2str(val(i_num, v_num)), '/'];
        
        if exist(reSAVE, 'dir') ~= 7
            mkdir(reSAVE);
        end
        
        listing = dir([Folder,'*.jpg']);
        Mask_listing = dir([Mask,'*.jpg']);
        for J = 1:size(listing)
            imwrite(SkinChanger2([Folder, listing(J).name],[Mask, Mask_listing(J).name], Lab{i_num}, val(i_num, v_num)),[reSAVE, Mask_listing(J).name]);
            new_img_name = [output_stim_path, 'stim', num2str(stim_number, '%03d'),ext];
            copyfile([reSAVE, Mask_listing(J).name], new_img_name);
            stim_number = stim_number + 1;
        end
    end
end
