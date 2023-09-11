function [c1,c2,r1,r2,ratio] = BDFT(j,pitch)

i=pitch;
thre=200;

f=abs(fft2(i)/256);               
s=fftshift(f);                    
smap=uint8(s);                    
smap=imresize(smap,[800,800]);    
figure;
set(gcf,'Position',[0,0,800,800]);
imshow(smap,'border','tight','initialmagnification','fit');
hold on

[dm,dn]=size(smap);
dm=int32(dm);
dn=int32(dn);
halfH=idivide(dm,2,'floor');
halfW=idivide(dn,2,'floor');

k=1;
for theta=1:1:44
    z=tan((90-theta)/180*pi);
    kk=1;
    for y=1:1:dm   %每一行
        x=(halfH-y)/z+halfW;
        allPixel1(k,kk)=smap(x,y);
        kk=kk+1;
    end
    fwhm1(1,k)=length(find(allPixel1(k,:)>=thre));
    k=k+1;
end

k=1;
p=1;
for theta=45:1:135
    z=tan((90-theta)/180*pi);
    kk=1;
    for x=1:1:dn   %每一列
        y=halfH-z*(x-halfW);
         if y<=0 
          p=p+1;
           break;
         end
        allPixel2(k,kk)=smap(x,y);
        kk=kk+1;
    end
    fwhm2(1,k)=length(find(allPixel2(k,:)>=thre));
    k=k+1;
end

k=1;
for theta=136:1:179
    z=tan((90-theta)/180*pi);
    kk=1;
    for y=1:1:dm    %每一行
        x=(halfH-y)/z+halfW;
        allPixel3(k,kk)=smap(x,y);
        kk=kk+1;
    end
    fwhm3(1,k)=length(find(allPixel3(k,:)>=thre));
    k=k+1;
end

fwhm=[fwhm1,fwhm2,fwhm3];
[r1,c1]=min(fwhm);
r1=int32(r1);
k1=idivide(r1,2,'floor');

if c1<=90
    c2=c1+90;
    r2=fwhm(c2);
    r2=int32(r2);
    k2=idivide(r2,2,'floor');
    z1=tan((90-c1)/180*pi);  %短轴
    z2=tan((90-c2)/180*pi);  %长轴
    if c1>0 && c1<=45
        y1=halfH-k1;  
        y2=halfH+k1;  
        x1=(halfH-y1)*z1+halfW;   %1
        x2=halfW-(y2-halfH)*z1;   %短,2
        x3=halfW-k2;  
        x4=halfW+k2;  
        y3=(x4-halfW)/z2+halfH;   %4
        y4=halfH-(halfW-x3)/z2;   %长,3

    end
    if c1>45 && c1<=90
        x1=halfW-k1;  
        x2=halfW+k1;  
        y1=(halfW-x1)/z1+halfH;   %2
        y2=halfH-(x2-halfW)/z1;   %短,1
        y3=halfH-k2;    
        y4=halfH+k2;  
        x3=(y4-halfH)*z2+halfW;   %4
        x4=halfW-(halfH-y3)*z2;   %长,3
    end
end

if c1>90
    c2=c1-90;
    r2=fwhm(c2);
    r2=int32(r2);
    k2=idivide(r2,2,'floor');
    z1=tan((90-c1)/180*pi);    %短轴
    z2=tan((90-c2)/180*pi);    %长轴
    if c1>90 && c1<=135
        x1=halfW-k1;  
        x2=halfW+k1;  
        y1=halfH-(halfW-x2)/z1;   %4
        y2=(x1-halfW)/z1+halfH;   %短,3
        y3=halfH-k2;  
        y4=halfH+k2;  
        x3=(halfH-y3)*z2+halfW;   %1
        x4=halfW-(y4-halfH)*z2;   %长,2
    end
    if c1>135 && c1<180
        y1=halfH-k1;  
        y2=halfH+k1;  
        x1=(y2-halfH)*z1+halfW;   %4
        x2=halfW-(halfH-y1)*z1;   %短,3   
        x3=halfW-k2;  
        x4=halfW+k2;  
        y3=(halfW-x3)/z2+halfH;   %2
        y4=halfH-(x4-halfW)/z2;   %长,1
    end
end

        ratio=double(r2)/double(r1);

        plot(y1,x1,'*','color','r');
        plot(y2,x2,'*','color','r');
        plot(y3,x3,'*','color','r');
        plot(y4,x4,'*','color','r');
        plot([y1,y2],[x1,x2],'Color','g','LineWidth',2);         
        plot([y3,y4],[x3,x4],'Color','g','LineWidth',2);

        k1=double(k1);
        k2=double(k2);       
        plotEllipse(400,400,k2*29/20,k1*29/20,(c2-90)/180*pi,'b',20,2,'-');
        axis off
        gfframe=getframe(gcf);%得到当前叠加图像
        str=[int2str(j),'after.jpg'];
        saveas(gcf,str);
end

