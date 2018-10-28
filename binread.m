function img=binread(filename,dimension)
     data=fopen(filename);
     specimg = fread(data,[1310720,81],'uint16');
      img = specimg ./ 65535;
      if dimension==1      
        img=reshape(img,1024,1280,81);
      end
    fclose(data);
end
