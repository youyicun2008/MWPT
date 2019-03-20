function ht = subtitle(text)

    h1 = get(gcf,'children');

    ver = version;
    ver1 = str2double(ver(1:3));
    if ver1>=8.4
        nf = numel(h1);
        for kf = 1:nf
            pos(kf,:) = get(h1(kf),'position');
        end
    else
        ind1 = strcmp('on',get(h1,'visible'));
        ind2 = strcmp('on',get(h1,'handlevisibility'));
        ind = find((ind1+ind2)==2);
        for kd = 1:numel(ind)
            pos(kd,:) = get(h1(ind(kd)),'position');
        end
    end

    left = min(squeeze(pos(:,1)));
    top = max(squeeze(pos(:,2)+pos(:,4)));
    % bottom = min(squeeze(pos(:,2)));
    right = max(squeeze(pos(:,1)+pos(:,3)));
    axest = [left,top-0.01,right-left,0.01];
    ht = axes('Position',axest);
    axis(ht,'off')
    title(ht,text)

end
