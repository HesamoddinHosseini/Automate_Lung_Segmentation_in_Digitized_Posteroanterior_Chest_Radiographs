Im_test = imread('JPCLN001.jpg');

im = mat2gray(imresize(rgb2gray(im2double(Im_test)),[347 286]));
im_1third = image(1:round(size(im,1)/3),:);
im_five = zeros(round(size(im_1third,1)/5),286);

for i=1:size(im_five,1)
    im_five(i,:) = (1/5)*(im_1third(5*i-4,:)+im_1third(5*i-3,:)+im_1third(5*i-2,:)+im_1third(5*i-1,:)+im_1third(5*i,:));
end

d1=floor(size(im,2)/4);
d2=floor(3*size(im,2)/4);

for i=1:size(im_five,1)
    [~,H(i)] = max(im_five(i,d1:d2));
end

middle = floor(sum(H) / size(im_five,1))+ d1;

for i=1:size(im_five,1)
    min1(i) = min(im_five(i,middle - floor(size(im,2) / 4):middle));
    if min1(i)<0.15*im_five(i,I(i))||min1(i)>0.85*im_five(i,I(i))
        min1(i) = 3;
    end
    min2(i) = min(im_five(i, middle:middle + floor(size(im,2) / 4)));
    if min2(i) < 0.15 * im_five(i,I(i)) || min2(i) > 0.85 * im_five(i,I(i))
        min2(i) = 3;
    end
end

for i=1:size(im_five,1)
    if min1(i)>min1(i+1)&&min1(i)>min1(i+2)&&min1(i+1)~=3
        apex=i-4;
        break
    end
    if min2(i)>min2(i+1)&&min2(i)>min2(i+2)&&min2(i+1)~=3
        apex=i-4;
        break
    end
end

LungApex=apex*5;
im2= im;
im2(LungApex,:)=0;
im2(:,middle)=0;

figure;
imshow(im2);
%%%%%%%%%%%%%%%%%%%%%%%%3 & 4 & 5
histogram=image(LungApex:end,floor(size(im,2)/6):floor(5*size(im,2)/6));
h=hist(histogram(:),1000);
figure('Name','gim histeq');
plot(h);
se=ones(1,100);
h2 = imdilate(h,se);
[~,max1]=findpeaks(h2);
if length(max1)==1
max1(2)=1000;
end
[~,min1]=min(h2(max1(1):max1(2)));
min1(1)=min1(1)+max1(1);
step=(min1(1)-max1(1))/(7000);
figure;
for i=1:7
    im_tr= image< (max1(1)/1000+(i)*step);
    subplot(3,3,i);imshow(im_tr);
    title(['thresholding after ',num2str(i),' step'])
end

size1=round(size(image)/2);
gim=image(size1(1):end, size1(2):end);
hs=fspecial('sobel');

gim_x=imfilter(gim,hs');
gim_y=imfilter(gim,hs);
gim_G=sqrt(gim_x.^2+gim_y.^2);
gim_G=mat2gray(gim_G);
figure;
imshow(gim_G,[]);

%%%%%%%%%%%%%%%%%%6
SE=ones(3,3);
for i=1:100
if thershold_image(apex+100,middle+i)==1
break;
end
end
for j=1:100
if thershold_image(apex+100,middle-j)==1
break;
end
end
im_blur=bwselect(thershold_image, [middle+i+5 middle-j-5 ],[apex+100 apex+100]);
im_blur=imopen(im_blur,ones(8,8));
edge=imdilate(im_blur,SE)-imerode(im_blur,SE);
edge=imopen(edge,ones(2,2));
figure
imshow(edge);




