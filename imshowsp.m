function imshowsp
    macbethsp=csvread('../data/macbeth.csv'); %マクベス分光反射率データ
    img=macbethchart(macbethsp,8,4); %分光画像作成
%     img=csvread('C:\Users\fumin\Documents\wiener_estimate\w_4-1.csv');
%     img=reshape(img,1024,1280,81);
    % Create a figure and axes
    f = figure('Visible','off');
    ax = axes('Units','pixels');
    sno = size(img);  % image size
    sno_a = sno(3);  % number of axial slices
    S_a = round(sno_a/2);
    S = S_a;
    sno = sno_a;
    imshow(img(:,:,S));
    hp = impixelinfo;
set(hp,'Position',[5 1 300 20]);

    sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',sno_a,'Value',S_a,'SliderStep',[1/(sno_a-1) 10/(sno_a-1)],...
        'Position', [400 20 120 20],...
        'Callback', {@surfzlim,img}); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[400 45 120 20],...
        'String','Band Slider');
    
    stxthand = uicontrol('Style', 'text','Position', [100 20 120 20], ...
            'String',sprintf('Slice# %d / %d',S, sno), 'BackgroundColor', [0.8 0.8 0.8], ...
            'FontSize', 9);
    f.Visible = 'on';

    function surfzlim(hObj,event,img)
        S = round(get(hObj,'Value')); 
        imshow(img(:,:,S));
        set(stxthand, 'String', sprintf('Slice# %d / %d',S, sno)) 
        hp = impixelinfo;
        set(hp,'Position',[5 1 300 20]);

    end


end