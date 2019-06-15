function imshowsp2(img,img2)
%imgすなわち1つめのsp画像を表示します
 [col,row,band]=size(img);
    if band==81
        wl81=380:5:780;
    else
        wl81=1:band;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
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
    tmp2_f(1,:)=img2(1,1,:);

    subplot(1,2,2);
    plot(wl81,tmp1,wl81,tmp2_f,'Linewidth',1.5);
    ylim([0 1]);
    if band==81
        xlabel('Wavelength[nm]') ;
    else
        xlabel('Bandnumber') ;
    end
    ylabel('Spectral Reflectance') ;
    
    if band==81
        xlim([380 780]);
    else
         xlim([1 band]);
    end
    legend('estimate','f')
    if band==81
        daspect([1 1/401  1])
    else
        daspect([1 1/band  1])
    end
    set(gca,'BoxStyle','full','Box','on')
    ax = gca;
    ax.FontSize = 12;
    
    sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',sno_a,'Value',S_a,'SliderStep',[1/(sno_a-1) 10/(sno_a-1)],...
        'Position', [100 100 120 20],...
        'Callback', {@surfzlim,img}); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[100 80 120 20],...
        'String','Band Slider');
    if band==81
        stxthand = uicontrol('Style', 'text','Position', [100 20 120 20], ...
            'String',sprintf('Slice# %d / %d',S*5+375, sno+699), 'BackgroundColor', [0.8 0.8 0.8], ...
            'FontSize', 9);
    else 
        stxthand = uicontrol('Style', 'text','Position', [100 20 120 20], ...
            'String',sprintf('Slice# %d / %d',S, sno), 'BackgroundColor', [0.8 0.8 0.8], ...
            'FontSize', 9);
    end
    
    currentpos = uicontrol('Style', 'text','Position', [100 50 120 20], ...
            'String',sprintf('( %d , %d )',1, 1), 'BackgroundColor', [0.8 0.8 0.8], ...
            'FontSize', 9);
    f.Visible = 'on';


function ImageClickCallback ( objectHandle , ~ )
      axesHandle  = get(objectHandle,'Parent');
      coordinates = get(axesHandle,'CurrentPoint'); 
      coordinates = coordinates(1,1:2);
      tmp(1,:)=img(round(coordinates(2)),round(coordinates(1)),:);
      tmp2(1,:)=img2(round(coordinates(2)),round(coordinates(1)),:);

      subplot(1,2,2);
      plot(wl81,tmp,wl81,tmp2,'Linewidth',1.5);
      ylim([0 1]);
      
      if band==81
        xlim([380 780]);
      else
         xlim([1 band]);
      end
      
    if band==81
        xlabel('Wavelength[nm]') ;
    else
        xlabel('Bandnumber') ;
    end
    ylabel('Spectral Reflectance') ;
        ax = gca;
    ax.FontSize = 12;
    if band==81
        daspect([1 1/401  1])
    else
        daspect([1 1/band  1])
    end
    set(gca,'BoxStyle','full','Box','on')  
       legend('estimate','f')
          set(currentpos, 'String', sprintf('(%d , %d )',round(coordinates(2)), round(coordinates(1))));
end

    function surfzlim(hObj,event,img)
        S = round(get(hObj,'Value')); 
        subplot(1,2,1);
         imageHandle = imshow(img(:,:,S));
        if band==81
            set(stxthand, 'String', sprintf('Slice# %d / %d',S*5+375, sno+699)) ;
       else
           set(stxthand, 'String', sprintf('Slice# %d / %d',S, sno)) ;
       end
        hp = impixelinfo;
        set(hp,'Position',[5 1 300 20]);
        set(imageHandle,'ButtonDownFcn',@ImageClickCallback);
    end

%現在表示しているスペクトルの座標表示　RMSEマップ　スペクトルを、複数表示

end