clc
clear
close(winsid());

function result=normalization(matrix)
    min_m=min(matrix);
    max_m=max(matrix);
    matrix(:,:)=255*(matrix(:,:)-min_m)/(max_m-min_m);

    result = matrix;
endfunction;

function result=binary_converter(matrix,threshold)
    [row,col] = size(matrix);
    result = zeros(row,col)
    for i=1:row
        for j=1:col
            if (matrix(i,j) > threshold) then
                result(i,j) = 255
            end;
        end;
    end;
endfunction;

img = imread("hand.jpg");
img = double(img);
img_gray = rgb2gray(img);
[i_row i_col i_deep] = size(img);

NW = [2  1  0;
      1  0 -1;
      0 -1 -2;];
NE = [ 0  1  2;
      -1  0  1;
      -2 -1  0;];

k_size = size(NW)(1);
k_center = round(k_size / 2);

NW_out = ones(i_row,i_col);
NE_out = NW_out;

for i=k_center:i_row - k_center + 1
    for j=k_center:i_col - k_center + 1
        NW_out(i,j) =  sum(img_gray(i-k_center+1:i+k_center-1, j-k_center+1:j+k_center-1).*NW);
        NE_out(i,j) =  sum(img_gray(i-k_center+1:i+k_center-1, j-k_center+1:j+k_center-1).*NE);
    end;
end;

NW_out = -(abs(NW_out));
NE_out = -(abs(NE_out));
NW_out = normalization(NW_out);
NE_out = normalization(NE_out);

output = NW_out + NE_out;
output = normalization(output);

binary = binary_converter(output,217);

// LINE DETECTION
max_rho=ceil(sqrt(i_row*i_row+i_col*i_col));
max_alpha = 180;
min_alpha = -90
A=zeros(max_rho,max_alpha - min_alpha);

//Hough transform for straight lines
for x=1:i_col //columns
    for y=1:i_row //rows
        if binary(i_row-y+1,x) == 0 //if the pixel is active
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

output_img = zeros(i_row,i_col,3);
output_img(:,:,1) = binary(:,:);
output_img(:,:,2) = binary(:,:);
output_img(:,:,3) = binary(:,:);

for line=1:7
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

    for x=1:i_col
        for y=1:i_row 
            if max_rho - current_rh + 1 == round(x.*cos(temp_alpha)+y.*sin(temp_alpha)) then 
                output_img(i_row-y+1,x,1) = 255;
                output_img(i_row-y+1,x,2) = 0;
                output_img(i_row-y+1,x,3) = 255;
            end;
        end;
    end;

    r = 3;
    A(current_rh-r:current_rh+r,current_al-r:current_al+r) = 0;
end;


figure(1);
title("Original")
imshow(uint8(img_gray));

figure(2);
title("Binary Output")
imshow(uint8(binary));

figure(3);
title('Line Detected Output');
imshow(output_img);

