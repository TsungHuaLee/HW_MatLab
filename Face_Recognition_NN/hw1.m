clear all

%read all folder in CroppedYale
fold = dir('CroppedYale');

training = {}; testing = {};

%the first two are '.' '..', remove them
fold(1:2) = [];

%loop all folder in CroppedYale
for i = 1:numel(fold)
    num_image = dir(fullfile('CroppedYale', fold(i).name, '*pgm'));
  for j = 1:35
    temp = imread(fullfile('CroppedYale', fold(i).name, num_image(j).name));
    training{i,j} = double(temp);
  end
  for j = 36:numel(num_image)
    temp = imread(fullfile('CroppedYale', fold(i).name, num_image(j).name));
    testing{i,j-35} = double(temp);
  end
end


%to know size of testing
[person, num_test] = size(testing);
[person, num_train] = size(training);


SAD = 0;
SSD = 0;
total = 0;
%compute SAD and SSD
for i = 1:numel(fold)   %every person
  for j = 1:num_test   %every testing image
    goal = i;
    min_sad = realmax;    %set max number
    min_ssd = realmax;    %set max number
    src = testing{i,j};
    if numel(src) == 0
      continue
    end
    total = total + 1;
    for x = 1:numel(fold)   %every person
      for y = 1:num_train     %every training image
        sample = training{x,y};
        diff_sad = sum(sum(imabsdiff(src, sample)));
        diff_ssd = sum(sum(imabsdiff(src, sample).^2));
        if diff_sad < min_sad    %find nearest neighbor in sad
          min_sad = diff_sad;
          result_sad = x;
        end
        if diff_ssd < min_ssd    %find nearest neighbor in ssd
          min_ssd = diff_ssd;
          result_ssd = x;
        end
      end
    end
    if result_sad == goal
      SAD = SAD + 1;
    end
    if result_ssd == goal
      SSD = SSD + 1;
    end
  end
end
SAD = SAD/total
SSD = SSD/total
