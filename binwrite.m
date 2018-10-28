function img=binwrite(savename,data)
    fileID = fopen(savename,'w');
    fwrite(fileID,data*65535,'uint16');
    fclose(fileID);
end
