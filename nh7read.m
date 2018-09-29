function specimg=nh7read(filename)
 data=fopen(filename);
 tmpmatrix=zeros(1024,1280,151);
 for y=1:1024
     %y
    for ch=1:151
         tmp = fread(data,[1280,1],'uint16');
         tmpmatrix(y,:,ch)=tmp;
    end
 end
 
specimg=tmpmatrix;
%   specimg = specimg - min(min(specimg));
  specimg = specimg ./ 4095;
%   specimg = specimg ./ max(max(specimg));
%   specimg=specimg.*255
fclose(data);


