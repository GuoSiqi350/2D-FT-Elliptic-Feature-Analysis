function [im1] = rotate(j,pitch)
im=pitch;
sz=size(im); % 求出原图大小
h=sz(1);
w=sz(2);
c1=[h;w]/2; % 原图中心
a=45/180*pi;
R=[cos(a),-sin(a);sin(a),cos(a)]; % 旋转矩阵45°
R=R'; % 求出旋转矩阵的逆矩阵
hh=700;
ww=700; % 画布的大小
c2=[hh,ww]/2; % 求画布中点
im1=uint8(zeros(hh,ww)*128); % 初始化目标画布
    for m = 1:hh
        for n = 1:ww
            p=[m;n]; % 遍历新图像像素点
            pp=round(R*(p-c2)+c1); % 计算在原来图像中的位置
            if(pp(1)>=1&&pp(1)<=h&&pp(2)>=1&&pp(2)<=w)
                im1(m,n)=im(pp(1),pp(2)); % 逆向进行像素查找
            end
        end
    end

figure;
imshow(im1);
gfframe=getframe(gcf); % 得到当前叠加图像
str=[int2str(j),'rotate.jpg'];
print(gcf,'-djpeg',str); % 保存旋转后的图像
end
