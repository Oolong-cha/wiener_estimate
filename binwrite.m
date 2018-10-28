function img=binwrite(savename,data)
    fileID = fopen(savename,'w');
    fwrite(fileID,data*4095,'uint16');
    fclose(fileID);
end
