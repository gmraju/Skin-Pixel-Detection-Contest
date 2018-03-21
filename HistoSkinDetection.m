function [img_out,guassian,histogram] = HistoSkinDetection(img_in)

    histogram = zeros(100,100);
    pixel_count=0;
    h_sum=0;
    s_sum=0;


    for i=1:51
        rgb_image=imread(strcat(num2str(i),'.png'));
  
        hsv_image = rgb2hsv(rgb_image);
  
        h = hsv_image(:,:,1);
        s = hsv_image(:,:,2);
  
        pixel_count = pixel_count + size(h,1)*size(h,2);
  
        for j=1:size(h,1)
            for k=1:size(h,2)
                histogram(fix(h(j,k)*99+1),fix(s(j,k)*99+1)) = histogram(fix(h(j,k)*99+1),fix(s(j,k)*99+1))+1;
                h_sum = h_sum + h(j,k);
                s_sum = s_sum + s(j,k);
            end
        end
    end

    histogram = histogram*100;

    input_img = rgb2hsv(img_in);
    h_in = input_img(:,:,1);
    s_in = input_img(:,:,2);
    binary_mask = zeros(size(h_in,1),size(h_in,2));

    for i=1:size(h_in,1)
        for j=1:size(h_in,2)
            if histogram(fix(h_in(i,j)*99+1),fix(s_in(i,j)*99+1)) > 2000
                binary_mask(i,j) = 1;
            end
        end
    end

    mask=img_in;
    mask(:,:,1) = uint8(binary_mask);
    mask(:,:,2) = uint8(binary_mask);
    mask(:,:,3) = uint8(binary_mask);

    img_out = mask.*img_in;
    
    figure;
    set(gcf,'numbertitle','off','name','Histogram-based')
    imshow(img_out);
    


    
    %Guassian
    h_mean = h_sum/pixel_count;
    s_mean = s_sum/pixel_count;
    h_var = 0;
    s_var =0;
    
    for i=1:size(h_in,1)
        for j=1:size(h_in,2)
            h_var = h_var + (h_in(i,j)-h_mean)^2;
            s_var = s_var + (s_in(i,j)-s_mean)^2;
        end
    end
    h_var = h_var/pixel_count;
    s_var = s_var/pixel_count;
    
    h_sd = h_var^2;
    s_sd = s_var^2;


    guassian = zeros(size(h_in,1),size(h_in,2));
    
    for i=1:size(h_in,1)
        for j=1:size(h_in,2)
            guassian(i,j) = (pixel_count/(2*h_sd*s_sd*pi^2)) * exp(-1*((((h_in(i,j) - h_mean)^2)/(2*h_sd)) * (((s_in(i,j) - s_mean)^2)/(2*s_sd))));
        end
    end
    
    g_out = zeros(size(input_img,1),size(input_img,2));
    
    for i=1:size(h_in,1)
        for j=1:size(h_in,2)
            if guassian(i,j) >= 1.34146355793083e-286
                
                
                g_out(i,j)=1;
            end
        end
    end

    mask2=img_in;
    mask2(:,:,1) = uint8(g_out);
    mask2(:,:,2) = uint8(g_out);
    mask2(:,:,3) = uint8(g_out);
    
    img_out = mask2.*img_in;
    
    figure;
    set(gcf,'numbertitle','off','name','Gaussian-based')
    imshow(img_out);
    
end

