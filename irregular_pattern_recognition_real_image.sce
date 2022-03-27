clc
clear
close(winsid());

image = imread("src/cancer.bmp");
image_out = image;
image = rgb2gray(image);
image = double(image);

pattern = imread("src/cell.bmp");
pattern = rgb2gray(pattern);
pattern = double(pattern);

[i_row,i_col] = size(image);
[p_row,p_col] = size(pattern);

accumulator = zeros(i_row - p_row + 1,i_col - p_col + 1);
[a_row,a_col] = size(accumulator);

for i=1:a_row
    for j=1:a_col
        difference = sum(abs(image(i:i + p_row - 1,j:j + p_col - 1) - pattern));
        accumulator(i,j) = difference;
    end;
end;

temp_accumulator = accumulator;
max_value = max(image) * (p_row * p_col);

for object_count=1:8
    min_value = max_value;
    temp_i = 1;
    temp_j = 1;
    for i=1:a_row
        for j=1:a_col
            if min_value > temp_accumulator(i,j) then
                min_value = temp_accumulator(i,j);
                temp_i = i;
                temp_j = j;
            end;
        end;
    end;

    disp(temp_i);
    disp(temp_j);

    // DRAW RENCTANGLE
    width = 2;
    image_out(temp_i:temp_i+width,temp_j:temp_j+p_col,1) = 50;
    image_out(temp_i:temp_i+width,temp_j:temp_j+p_col,2) = 255;
    image_out(temp_i:temp_i+width,temp_j:temp_j+p_col,3) = 0;

    image_out(temp_i:temp_i+p_row,temp_j:temp_j+width,1) = 50;
    image_out(temp_i:temp_i+p_row,temp_j:temp_j+width,2) = 255;
    image_out(temp_i:temp_i+p_row,temp_j:temp_j+width,3) = 0;

    image_out(temp_i+p_row:temp_i+p_row+width,temp_j:temp_j+p_col,1) = 50;
    image_out(temp_i+p_row:temp_i+p_row+width,temp_j:temp_j+p_col,2) = 255;
    image_out(temp_i+p_row:temp_i+p_row+width,temp_j:temp_j+p_col,3) = 0;

    image_out(temp_i:temp_i+p_row+width,temp_j+p_col:temp_j+p_col+width,1) = 50;
    image_out(temp_i:temp_i+p_row+width,temp_j+p_col:temp_j+p_col+width,2) = 255;
    image_out(temp_i:temp_i+p_row+width,temp_j+p_col:temp_j+p_col+width,3) = 0;
    
    // CLEAR SIMILAR AREAS
    temp_accumulator(temp_i-p_row:temp_i+p_row,temp_j-p_col:temp_j+p_col) = max_value;
end;

figure(1);
title("Pattern");
imshow(uint8(pattern));
figure(2);
title("Result");
imshow(uint8(image_out));
