function [images, classif_images] = prepare_images(P, T)
    start = 1;
    end_pos = 29 + start;
    possible_poses = [];
    
    sz = size(P);
    no_features = sz(2); % number of features for more code modularity
    st = size(T);
    no_classes = st(2);
    % making an array of the consecutive counts of the same classification
    % for work with convolutional neural networks
    ct = 1;
    cts = [];
    tot_size = 0;
    
    for i = 2:sz(1)
        if T(i,:) == T(i-1,:)
            ct = ct + 1;
        else
            cts = [cts; [T(i-1,:),ct]];
            tot_size = tot_size + max(ct-no_features+1, 0);
            ct = 1;

        end  
        if i == sz(1)
            cts = [cts; [T(i,:),ct]];
            tot_size = tot_size + max(ct-no_features+1, 0);
        end
    end
    sz = size(cts);
    images = [];
    classifs = [];
    cummulative = 1;

    % assembling the images
    images = zeros(no_features, no_features, tot_size);
    classifs = zeros(tot_size, 1);
    pos = 1;
    for i = 1 : sz(1)
        element = onehotdecode(cts(i,1:no_classes), [1 2 3 4], 2);
        ct = cts(i,no_classes + 1);
        if ct < no_features
            cummulative = cummulative + ct;
            continue;
        end
        for j = 0 : ct - no_features
            arr = P(cummulative + j: cummulative + j+ no_features - 1,:);
            images(:,:, pos) = arr;
            classifs(pos,:) = element;
            pos = pos + 1;
            % will return a 3d array with all the images 
        end
        cummulative = cummulative + ct;
    end
    images = reshape(images, [size(images, 1:2), 1, size(images,3)]);
    classif_images = categorical(classifs);
end