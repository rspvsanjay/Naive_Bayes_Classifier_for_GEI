path1= 'H:\CASIA_B\CASIA_B090degree_Centered_Alinged_Energy_Image\';
list1 = dir(path1);
fName1 = {list1.name};
[~,y1] = size(fName1);
path1
y1
group1=cell(1,1);
train=[];
temp=[];
for f_no=3:y1
    list2 = dir(char(strcat(path1,fName1(f_no),'\')));
    fName2 = {list2.name};
    [~,y2] = size(fName2);
    for ff_no=7:y2
        group1{1} = [group1{1},f_no-2];
%         pathh=char(strcat(path1,fName1(f_no),'\',fName2(ff_no)))
        Image = imread(char(strcat(path1,fName1(f_no),'\',fName2(ff_no))));
        temp=Image(:);
        train=[train; double(temp')];
    end
end

[coeff,score,~,~,explained] = pca(train);
sm = 0;
no_components = 0;
for k = 1:size(explained,1)
    sm = sm+explained(k);
    if sm <= 99.4029
        no_components= no_components+1;
    end
end
m = mean(train,1);
mat1 = score(:,1:no_components);

test1= [];
group2=cell(1,1);

for f_no=3:y1
    list2 = dir(char(strcat(path1,fName1(f_no),'\')));
    fName2 = {list2.name};
    [~,y2] = size(fName2);
    for ff_no = 7:8
        group2{1} = [group2{1},f_no-2];
%         pathh=char(strcat(path1,fName1(f_no),'\',fName2(ff_no)))
        Image = imread(char(strcat(path1,fName1(f_no),'\',fName2(ff_no))));
        Img_mean = double(Image(:)')-m;
        Img_proj = Img_mean*coeff;
        test_features = Img_proj(:,1:no_components);
        test1 = [test1; test_features];
    end
end
mat2 = double(test1);
class = classify(mat2,mat1,group1{1},'diaglinear');

accuracy = 0;
for number=1:length(class)
    if class(number)==group2{1}(number)
        accuracy = accuracy+1;
    end
end
group22=cell(1,1);
group22{1} = [group22{1},group2{1}];   

disp("Result for nm to nm");
(accuracy*100)/length(class)
total = (accuracy*100)/length(class);