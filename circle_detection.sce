clc
clear
close(winsid());

img=imread('src/circles.bmp'); 
img=double(img); 
[row col]=size(img);

img_gray = img;

//Accumulator
max_x = col;
max_y = row;
min_r = 5;
max_r = 15;
A=zeros(max_x,max_y,max_r);

for x=1:col 
    for y=1:row 
        if img_gray(y,x) == 0 
            for xs=min_r:max_x-min_r
                for ys=min_r:max_y-min_r 
                    for r=min_r:max_r 
                        if r == round(sqrt((x-xs)^2+(y-ys)^2)) then
                            A(xs,ys,r)=A(xs,ys,r)+1; 
                        end;    
                    end;
                end;
            end;
        end; //if
    end;
end;    

circle_result = zeros(row,col,3);
output_img = zeros(row,col,3);
output_img(:,:,1) = img_gray(:,:);
output_img(:,:,2) = img_gray(:,:);
output_img(:,:,3) = img_gray(:,:);

current_max = A(1,1,1);
current_xs = 1;
current_ys = 1;
current_r = min_r;

for xs=min_r:max_x-min_r
    for ys=min_r:max_y-min_r 
        for r=min_r:max_r 
            if current_max < A(xs,ys,r) then
                current_max = A(xs,ys,r);
                current_xs = xs;
                current_ys = ys;
                current_r = r;
            end;
        end;
    end;
end;


for x=1:col
    for y=1:row 
        if current_r == round(sqrt((x-current_xs)^2+(y-current_ys)^2)) then 
            circle_result(y,x,1) = 255;
            output_img(y,x,1) = 255;
            output_img(y,x,2) = 0;
            output_img(y,x,3) = 255;
        end;
    end;
end;


IA=double(zeros(max_x,max_y,max_r));
IA=A;
for r=min_r:max_r 
    minIA=min(IA(:,:,r));
    maxIA=max(IA(:,:,r));
    IA(:,:,r)=255*(IA(:,:,r)-minIA)/(maxIA-minIA);
end;


//OUTPUT FIGURES
figure(1);
imshow(img_gray);
title('INPUT IMAGE');

figure(2);
imshow(output_img);
title('OUTPUT IMAGE');

figure(3);
imshow(circle_result);
title('CIRCLE RESULT');

figure(4);
title('BEST SLICE ACCUMULATOR');
imshow(uint8(IA(:,:,current_r)));

/*
title('ACCUMULATOR');
figure(5);
for r=min_r:max_r 
    imshow(uint8(IA(:,:,r)));
    sleep(500);
end;
*/


