function img=binwrite(savename,data)
    fileID = fopen(savename,'w');
    fwrite(fileID,data,'uint16');
    fclose(fileID);
end
