404410082 資工三 李宗樺
=====
#### 1) 方法描述 - 演算法原理與實作方式描述
先將一堆沒用的圖砍掉。

用二維cell array儲存圖片。<br/>
&emsp;ex:training[2][5] 表示第二個人的第五張圖

直接暴力搜尋找最近
#### 2) 執行方式 – 執行的函數名稱、參數設定等
<pre><code>
clear all

%read all folder in CroppedYale
fold = dir('CroppedYale');

training = {}; testing = {};

%the first two are '.' '..', remove them
fold(1:2) = [];

%loop all folder in CroppedYale
for i = 1:numel(fold)
    num_image = dir(fullfile('CroppedYale', fold(i).name, '*pgm'));*
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
    min_sad = realmax;    
    min_ssd = realmax;    %set max number
    src = testing{i,j};
    if numel(src) == 0    %將陣列中那些因自動補齊而產生的0x0跳過
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

</code></pre>

#### 3) 實驗結果 – 每一個階段的圖片、數據結果
SAD = 0.4511<br/>
SSD = 0.4603

<img src="anspic.png" alt="answer demo">


#### 4) 結果討論 – 對於實驗結果的一些解釋和討論
實驗結果比預期的低很多，個人推測是因為我們將圖片分成兩組 train and test，圖片來源前後部份的照片風格，亮度，角度其實有些差異。<br/>
所以在和training組比對的時候，算出來的距離其實可能不比想像中接近，也間接縮小了和錯誤答案的差別。<br/>
如果不分組的話，答案會提昇許多。

#### 5) 問題討論 – 作業撰寫中遭遇的演算法問題與實作的困難

*   Q:<br/>
    使用dir()讀檔會讀到 '.' and '..'

    Sol:<br/>
    因為剛好會存在 [1] 和 [2]，將它設為空。<br/>
	  <pre><code>fold(1:2) = [];</pre></code>

*   Q:<br/>
	  imabsdiff() 和 abs() 算出來的答案不一樣。<br/>
	  原因:overflow<br/>
	  把圖讀進來時，type = uint8 代表 unsigned integer，用abs()相減的時候會
    有overflow的問題，會產生很多0，而imabsdiff()卻不會。<br/>

    Sol:<br/>
	  type conversion to double
    <pre><code>training{i,j} = double(temp);</pre></code>

*   Q:<br/>
    儲存圖片的cell array 有 {0x0 double}，而使用imabsdiff(A,B)AB需要same size。

    原因:<br/>
    在產生陣列的時候，matlab會自懂將其補0對齊。<br/>
    因為有將破圖刪除的原因，導致每個資料夾中的照片數不一樣,matlab會將缺的地方補0對齊去第一維的個數29。<br/>

    Sol:<br/>
    手動判斷，如果是0x0的話跳過
