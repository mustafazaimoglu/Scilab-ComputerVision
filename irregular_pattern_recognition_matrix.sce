clc
clear

image = [7 9 1 8 0 5 7 1 0 5;
         1 5 3 0 7 5 1 2 6 7;
         5 1 2 4 0 3 4 1 9 0;
         9 1 7 0 2 9 4 0 3 2;
         5 1 3 4 9 3 4 1 9 0;
         0 8 0 4 1 6 0 5 0 7;
         4 8 6 9 5 1 2 3 4 5;
         5 9 6 2 7 5 6 9 8 2;
         1 3 5 9 7 4 5 6 6 9;
         1 2 3 6 4 8 9 6 4 5;];

pattern = [1 2 4 0; 1 7 0 2; 1 3 4 9; 8 0 4 1;];

image_size = size(image);
pattern_size = size(pattern);

accumulator = zeros(image_size(1) - pattern_size(1) + 1,image_size(2) - pattern_size(2) + 1);
accumulator_size = size(accumulator);

for i=1:accumulator_size(1)
    for j=1:accumulator_size(2)
        total =(pattern_size(1)* pattern_size(2))*9 - sum(abs(image(i:i + pattern_size(1) - 1,j:j + pattern_size(2) - 1) - pattern));
         
        accumulator(i,j) = total;
    end;
end;

disp(accumulator);
