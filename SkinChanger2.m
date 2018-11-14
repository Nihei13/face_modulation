function [Image] = SkinChanger2(adr,mask,labtype, value)
%     [Img, map] = imread(adr);
%     Img = double(Img);
%     Origin = ind2rgb(Img, map);
    Origin = imread(adr);
    Image = rgb2lab(Origin);                        %Lab�摜�ϊ�

    %%�@���F�F��
%     I = double(Origin);
%     [hue,s,v]=rgb2hsv(double(imread(mask))./255);       %�猟�o�p�摜�ϊ�
%     [tmpImg, map] = imread(mask);
%     MaskOrigin = ind2rgb(tmpImg, map);
    MaskOrigin = imread(mask);
    MaskOrigin = double(MaskOrigin(:,:,1));
    hsv = rgb2hsv(Origin);
    hue = hsv(:,:,1);
    s   = hsv(:,:,2);
    v   = hsv(:,:,3);
%     cb =  0.148* I(:,:,1) - 0.291* I(:,:,2) + 0.439 * I(:,:,3) + 128;    cr =  0.439 * I(:,:,1) - 0.368 * I(:,:,2) -0.071 * I(:,:,3) + 128;
    [w h]=size(hue(:,:));                               %�摜�T�C�Y�擾
%     for i=1:w
%         for j=1:h
% %             if  140<=cr(i,j) && cr(i,j)<=165 && 140<=cb(i,j) && cb(i,j)<=195 && 0.01<=hue(i,j) && hue(i,j)<=0.1 %���F�̈挟�o
%             if  0 < hue(i,j) && (15*pi/180) > hue(i,j) && 50/255 < s(i,j) && 50/255 < v(i,j) %���F�̈挟�o
%                 segment(i,j)=1;
%             else
%                 segment(i,j)=0;
%             end
%         end
%     end
    for i=1:w
        for j=1:h
            if  0 < hue(i,j)&& 10/255 < s(i,j) && 10/255 < v(i,j) %���F�̈挟�o
                segment(i,j)=1;
            else
                segment(i,j)=0;
            end
        end
    end
    
    %�@�I��͈͂̊ۂ�
	original = medfilt2(segment);
    afterOpening = imfill(original);
    tmpMask = MaskOrigin + ~afterOpening;
    tmpMask = ~tmpMask;
    imshow(tmpMask)
    tmpImage = Image;
    %%�@���F�ϊ�
    for i=1:w
        for j=1:h
            if  tmpMask(i,j) ~= 0
                switch labtype
                    case 'L'
                        tmpImage(i,j,1) = Image(i,j,1) + value;
                    case 'a'
                        tmpImage(i,j,2) = Image(i,j,2) + value;
                    case 'b'
                        tmpImage(i,j,3) = Image(i,j,3) + value;
                end
            end
        end
    end
    Image = lab2rgb(tmpImage,'OutputType','uint8');
    
%	figure, imshow(Origin);
%   figure,imshow(maxArea_d(afterOpening));
%	figure,imshow(Image);
end