function [img_out ,guassian, histogram2] = RGBHistoSkinDetection( img_in )

    histogram2 = zeros(256,256);
    pixel_count=0;
    r_sum=0;
    g_sum=0;

    for i=1:51
        rgb_image=imread(strcat(num2str(i),'.png'));
 
        r = rgb_image(:,:,1);
        g = rgb_image(:,:,2);
   
        pixel_count = pixel_count + size(r,1)*size(r,2);
  

        for j=1:size(r,1)
            for k=1:size(r,2)              
                histogram2((r(j,k)+1),(g(j,k)+1)) = histogram2((r(j,k)+1),(g(j,k)+1))+1;
                r_sum = r_sum + double(r(j,k));                              
                g_sum = g_sum + double(g(j,k));
            end
        end
    end


    r_in = img_in(:,:,1);
    g_in = img_in(:,:,2);
    img_out = zeros(size(r_in,1),size(r_in,2));

    for i=1:size(r_in,1)
        for j=1:size(r_in,2)
            if histogram2(r_in(i,j)+1,g_in(i,j)+1) > 0
                img_out(i,j) = 1;
            end
        end
    end

    mask=img_in;
    mask(:,:,1) = img_out;
    mask(:,:,2) = img_out;
    mask(:,:,3) = img_out;

    img_out = mask.*img_in;
    
    figure;
    imshow(img_out);
  
  





%Guassian

r_mean = r_sum/pixel_count
g_mean = g_sum/pixel_count
r_var = 0;
g_var =0;

r_in = double(r_in);
g_in = double(g_in);

for i=1:size(r_in,1)
    for j=1:size(g_in,2)
        rlol=r_in(i,j);
        glol=g_in(i,j);
        r_var = r_var + (rlol-r_mean)^2;
        g_var = g_var + (glol-g_mean)^2;
    end
end
r_var = r_var/pixel_count;
g_var = g_var/pixel_count;

r_sd = r_var^2;
g_sd = g_var^2;


guassian = zeros(size(r_in,1),size(r_in,2));

for i=1:size(r_in,1)
    for j=1:size(r_in,2)
        rlol=double(r_in(i,j));
        glol=double(g_in(i,j));
        guassian(i,j) = (pixel_count/(2*r_sd*g_sd*pi^2)) * exp(-1*((((rlol - r_mean)^2/(2*r_sd))) * ((glol - g_mean)^2/(2*g_sd))));
    end
end


g_out = zeros(size(r_in,1),size(r_in,2));


for i=1:size(r_in,1)
    for j=1:size(r_in,2)
        if guassian(i,j) >= 0
            g_out(i,j)=1;
        end
    end
end

figure;
imshow(g_out);




end




