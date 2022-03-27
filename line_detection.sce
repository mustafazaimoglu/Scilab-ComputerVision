clc
clear
close(winsid());

img=imread('src/lines.bmp'); 
img=double(img); //increasing of calculation precision
[row col]=size(img); //acquisition of the input image size

img_gray = img;

//Accumulator
max_rho=ceil(sqrt(row*row+col*col));
max_alpha = 180;
min_alpha = -90
A=zeros(max_rho,max_alpha - min_alpha);

//Hough transform for straight lines
for x=1:col //columns
    for y=1:row //rows
        if img_gray(row-y+1,x) == 0 //if the pixel is active
            for alpha=1:max_alpha - min_alpha //parameter alpha (for the Accumulator)
                a=%pi*(alpha + min_alpha)/180.0; //conversion to radians
                rho=round(x.*cos(a)+y.*sin(a)); //the equation of straight line
                if ((rho>0) && (rho<=max_rho)) 
                    A(max_rho-rho+1,alpha)=A(max_rho-rho+1,alpha)+1; //accumulation
                end;    
            end;
        end; //if
    end;
end;    

line_result = zeros(row,col,3);
output_img = zeros(row,col,3);
output_img(:,:,1) = img_gray(:,:);
output_img(:,:,2) = img_gray(:,:);
output_img(:,:,3) = img_gray(:,:);

for line=1:4
    current_max = A(1,1);
    current_rh = 1;
    current_al = 1;

    for rh=1:max_rho
        for al=1:max_alpha + abs(min_alpha)
            if current_max < A(rh,al) then
                current_max = A(rh,al);
                current_rh = rh;
                current_al = al;
            end;
        end;
    end;    
/*
    disp(current_rh);
    disp(current_al - abs(min_alpha));
*/
    temp_alpha=%pi*(current_al - abs(min_alpha))/180.0; 

    for x=1:col
        for y=1:row 
            if max_rho - current_rh + 1 == round(x.*cos(temp_alpha)+y.*sin(temp_alpha)) then 
                line_result(row-y+1,x,1) = 255;
                output_img(row-y+1,x,1) = 255;
                output_img(row-y+1,x,2) = 0;
                output_img(row-y+1,x,3) = 255;
            end;
        end;
    end;

    r = 3;
    A(current_rh-r:current_rh+r,current_al-r:current_al+r) = 0;
end;

IA=double(zeros(max_rho,max_alpha));
IA=A;
minIA=min(IA);
maxIA=max(IA);
IA(:,:)=255*(IA(:,:)-minIA)/(maxIA-minIA);

//OUTPUT FIGURES
figure(1);
imshow(img_gray);
title('INPUT IMAGE');

figure(2);
imshow(output_img);
title('OUTPUT IMAGE');

figure(3);
imshow(line_result);
title('LINE RESULTS');

IA=uint8(IA);
figure(4);
imshow(uint8(IA));
title('ACCUMULATOR');

figure(5);
surf(A');
title('ACCUMULATOR - 3D');

