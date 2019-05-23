function imshowspsingle(img)
%     clear all
%     img=binread19('C:\Users\fumin\Documents\wiener_estimate\19bandimg.bin',1);
%     macbethsp=csvread('../data/macbeth.csv'); %マクベス分光反射率データ
%     img=macbethchart(macbethsp,8,4); %分光画像作成
    [col,row,band]=size(img);
    wl81=380:5:780;
%     wl81=1:19;
%       wl81=1:band;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     img=reshape(csvread('D:\spimage\originalimage\3-1.csv'),1024,1280,81);
  
    % Create a figure and axes
    f = figure('Visible','off');
    ax = axes('Units','pixels');
    
    sno = size(img);  % image size
    sno_a = sno(3);  % number of axial slices
    S_a = round(sno_a/2);
    S = S_a;
    sno = sno_a;
    
    subplot(1,2,1);
    imageHandle = imshow(img(:,:,S));
    hp = impixelinfo;
    set(hp,'Position',[5 1 300 20]);
    set(imageHandle,'ButtonDownFcn',@ImageClickCallback);

    tmp1(1,:)=img(1,1,:);
    subplot(1,2,2);
    plot(wl81,tmp1);
    ylim([0 1]);
          xlim([380 780]);
%     xlim([1 band]);
   
    sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',sno_a,'Value',S_a,'SliderStep',[1/(sno_a-1) 10/(sno_a-1)],...
        'Position', [100 100 120 20],...
        'Callback', {@surfzlim,img}); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[100 80 120 20],...
        'String','Band Slider');
    
    stxthand = uicontrol('Style', 'text','Position', [100 20 120 20], ...
            'String',sprintf('Slice# %d / %d',S*5+375, sno+699), 'BackgroundColor', [0.8 0.8 0.8], ...
            'FontSize', 9);
    f.Visible = 'on';
    
    currentpos = uicontrol('Style', 'text','Position', [100 50 120 20], ...
            'String',sprintf('( %d , %d )',1, 1), 'BackgroundColor', [0.8 0.8 0.8], ...
            'FontSize', 9);
    f.Visible = 'on';


function ImageClickCallback ( objectHandle , ~ )
      axesHandle  = get(objectHandle,'Parent');
      coordinates = get(axesHandle,'CurrentPoint'); 
      coordinates = coordinates(1,1:2);
      tmp(1,:)=img(round(coordinates(2)),round(coordinates(1)),:);
      subplot(1,2,2);
      plot(wl81,tmp);
      ylim([0 1]);
      xlim([380 780]);
%     xlim([1 band]);
      legend('f','fromrgb','from16','from19')
          set(currentpos, 'String', sprintf('(%d , %d )',round(coordinates(2)), round(coordinates(1))));
end

    function surfzlim(hObj,event,img)
        S = round(get(hObj,'Value')); 
        subplot(1,2,1);
         imageHandle = imshow(img(:,:,S));
        set(stxthand, 'String', sprintf('Slice# %d / %d',S*5+375, sno+699)) ;
        hp = impixelinfo;
        set(hp,'Position',[5 1 300 20]);
        set(imageHandle,'ButtonDownFcn',@ImageClickCallback);
    end

%現在表示しているスペクトルの座標表示　RMSEマップ　スペクトルを、複数表示

end