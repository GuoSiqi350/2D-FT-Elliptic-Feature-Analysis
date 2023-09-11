file_path =  ''; % 图像文件夹路径 
img_path_list = dir(strcat(file_path)); % dir 列出当前文件夹中的文件信息
img_num = length(img_path_list); % 获取图像总数量
fprintf('正在读取的图像为：\n');
for j= 1:img_num-1 % 逐一读取图像
    if  img_path_list(j).isdir==0
    img_name = [file_path,'/',int2str(j),'.tif'];
    pitch=imread(img_name);
%   [im1]=rotate(j,pitch);
%   pitch=im1;
    [c1,c2,r1,r2,ratio] = BDFT(j,pitch);
    result(j,1)=c1;
    result(j,2)=c2;
    result(j,3)=r1;
    result(j,4)=r2;
    result(j,5)=ratio;
    fprintf('第%02d个：%s\n',j,img_name); % %02d表示数字转字符串之后固定长度为2
    end
end
