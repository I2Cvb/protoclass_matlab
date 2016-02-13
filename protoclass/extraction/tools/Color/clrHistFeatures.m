%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Mojdeh Rastgo , 1-07-13 
%%% clrHistFeatures 
%%% colorHistcube part was originally implemented by Jan Zatyik, Pavel Rajmic at 
%%% Brno University of Technology, Czech Republic
%%% and was adapted to suit this purpose 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  [colorHistMatrix, colorHistCube, colorHistVec] = clrHistFeatures (Img, Mask, nbins)

%%% checking the input arguments 
    if nargin <= 2 
        nbins = 6; 
    end
    if nbins == 1
        error('it is nonsense to use n=1');
    end
    if isempty(Mask)
        [row, col, d] = size(Img); 
        InputImg = Img; 
%         InputImg = Min_Max_normalization(InputImg); 
        InputImg = InputImg.*255; 

        %%% colorHistMatrix 
        colorHistMatrix = zeros(3,nbins); 
        steps = 255 / nbins ; 
        fullcell_no = ceil(InputImg/steps); 
        fullcell_no(fullcell_no==0) = 1; 

        lesioncell_no = fullcell_no; 

        for n = 1 : nbins 
        colorHistMatrix(1,n) = sum (find(lesioncell_no(:,:,1) == n));
        colorHistMatrix(2,n) = sum (find(lesioncell_no(:,:,2) == n));
        colorHistMatrix(3,n) = sum (find(lesioncell_no(:,:,3) == n));
        end 


        %%% colorHistCube
        freq = zeros(nbins^3,1); 
        % computing to which index belong the data
        r = lesioncell_no(:,:,1) - 1; r(r == -1) = 0 ; 
        g = lesioncell_no(:,:,2) - 1; g(g == -1) = 0 ; 
        b = lesioncell_no(:,:,3) - 1; b(b == -1) = 0 ; 

        index = nbins * r +nbins^2 *g + b + 1;

        % computation of frequencies
        for icol = 1:col
            for irow = 1:row
                freq(index(irow,icol)) = freq(index(irow,icol)) + 1;
            end
        end

        colorHistVec = freq; 

        % Reshaping into 3D-array
        freq = reshape(freq,n,n,n);


        %%% Compensation due to (possible) non-uniform length of cells
        bound = linspace(0,255,nbins+1); %where are the cell boundaries
        bound_int = floor(bound); %integers
        % averages (used later during plotting)
        cell_avrg = cumsum(diff(bound)) - (255/nbins)/2;
        cell_avrg_int = round(cell_avrg);

        % how many values can the cells contain
        % (these values can differ by 1 or will be the same)
        cell_ranges = diff(bound_int);
        maxmin_ratio = max(cell_ranges) / min(cell_ranges);
        % determining which cells are to be compensated
        cells_to_compensate = find(cell_ranges - min(cell_ranges)); %nonzero elements
        % calculate the compensated frequencies (rows(R), columns(G), slides(B))
        freq(cells_to_compensate,:,:) = freq(cells_to_compensate,:,:) / maxmin_ratio;
        freq(:,cells_to_compensate,:) = freq(:,cells_to_compensate,:) / maxmin_ratio;
        freq(:,:,cells_to_compensate) = freq(:,:,cells_to_compensate) / maxmin_ratio;

        colorHistCube = freq; 

        %%%% Compute FREQ_APP

        freq_app = zeros(nbins,nbins,nbins);
        for w = 1:nbins
            freq_app(:,:,w) = (flipud((freq(:,:,w))));
        end
    
    else
        [row, col, d] = size(Img); 
        Mask = im2bw (Mask);
        Mask = im2double(Mask); 
        InputImg = Img.*repmat(Mask , [1 1 3]); 

        InputImg = Min_Max_normalization(InputImg); 
        InputImg = InputImg.*255; 

        %%% colorHistMatrix 
        colorHistMatrix = zeros(3,nbins); 
        steps = 255 / nbins ; 
        fullcell_no = ceil(InputImg/steps); 
        fullcell_no(fullcell_no==0) = 1; 

        lesioncell_no = fullcell_no.*repmat(Mask, [1 1 3]); 

        for n = 1 : nbins 
        colorHistMatrix(1,n) = sum (find(lesioncell_no(:,:,1) == n));
        colorHistMatrix(2,n) = sum (find(lesioncell_no(:,:,2) == n));
        colorHistMatrix(3,n) = sum (find(lesioncell_no(:,:,3) == n));
        end 


        %%% colorHistCube
        freq = zeros(nbins^3,1); 
        % computing to which index belong the data
        r = lesioncell_no(:,:,1) - 1; r(r == -1) = 0 ; 
        g = lesioncell_no(:,:,2) - 1; g(g == -1) = 0 ; 
        b = lesioncell_no(:,:,3) - 1; b(b == -1) = 0 ; 

        index = nbins * r +nbins^2 *g + b + 1;

        % computation of frequencies
        for icol = 1:col
            for irow = 1:row
                freq(index(irow,icol)) = freq(index(irow,icol)) + 1;
            end
        end

        colorHistVec = freq; 

        % Reshaping into 3D-array
        freq = reshape(freq,n,n,n);


        %%% Compensation due to (possible) non-uniform length of cells
        bound = linspace(0,255,nbins+1); %where are the cell boundaries
        bound_int = floor(bound); %integers
        % averages (used later during plotting)
        cell_avrg = cumsum(diff(bound)) - (255/nbins)/2;
        cell_avrg_int = round(cell_avrg);

        % how many values can the cells contain
        % (these values can differ by 1 or will be the same)
        cell_ranges = diff(bound_int);
        maxmin_ratio = max(cell_ranges) / min(cell_ranges);
        % determining which cells are to be compensated
        cells_to_compensate = find(cell_ranges - min(cell_ranges)); %nonzero elements
        % calculate the compensated frequencies (rows(R), columns(G), slides(B))
        freq(cells_to_compensate,:,:) = freq(cells_to_compensate,:,:) / maxmin_ratio;
        freq(:,cells_to_compensate,:) = freq(:,cells_to_compensate,:) / maxmin_ratio;
        freq(:,:,cells_to_compensate) = freq(:,:,cells_to_compensate) / maxmin_ratio;

        colorHistCube = freq; 

        %%%% Compute FREQ_APP

        freq_app = zeros(nbins,nbins,nbins);
        for w = 1:nbins
            freq_app(:,:,w) = (flipud((freq(:,:,w))));
        end
    end 
%% Displaying color Cube 
 
    %%% Emphasizing small frequencies by gamma
% % %     maxfreq = max(max(max(freq))); %maximum frequency
% % %     if gamma ~=1
% % %         disp(['Recalculating frequencies by means of gamma=' num2str(gamma) ' ...'])
% % %         if gamma == 0
% % %             disp('!!! Warning: GAMMA is zero!');
% % %             freq_emph = zeros(size(freq)); %zeros everywhere
% % %             freq_emph(freq~=0) = 1; %ones; the same result as if .^0 was computed
% % %             maxfreq = 1;
% % %         else
% % %             freq_emph = freq / maxfreq;   %first, normalize to [0,1]
% % %             freq_emph = freq_emph.^gamma; %second, emphasize
% % %             freq_emph = freq_emph * maxfreq; %finally, un-normalize
% % %             %maximum frequency remains unchanged
% % %         end
% % %     else
% % %         freq_emph = freq; %no change
% % %     end


% % % % %% Drawing the histogram
% % % % disp('Drawing the histogram...')
% % % % figure
% % % % % whitebg([0.9 0.9 0.9])   
% % % % maxradius = 255/n;
% % % % [Rss Gss Bss] = sphere(16); % mesh for unit sphere
% % % % % resizing the sphere to maximum
% % % % Rss = Rss * maxradius/2; 
% % % % Gss = Gss * maxradius/2;
% % % % Bss = Bss * maxradius/2;
% % % % 
% % % % % loop over all histogram cells and plot the balls
% % % % for cnt_B = 1:nbins
% % % %     for cnt_G = 1:nbins
% % % %         for cnt_R = 1:nbins
% % % %             RGBfreq = freq_emph(cnt_B, cnt_R, cnt_G); %scalar
% % % %             if RGBfreq ~= 0 % if a sphere has to appear
% % % %                 % begin with the initial sphere
% % % %                 Rs = Rss;
% % % %                 Gs = Gss;
% % % %                 Bs = Bss;
% % % %                 % size of the sphere according to the frequency
% % % %                 ratio = RGBfreq / maxfreq;
% % % %                 Rs = Rs * ratio;
% % % %                 Gs = Gs * ratio;
% % % %                 Bs = Bs * ratio;
% % % %                 % translation the sphere to the right place
% % % %                 modR = mod(cnt_R-1,n);
% % % %                 modG = mod(cnt_G-1,n);
% % % %                 modB = mod(cnt_B-1,n);
% % % %                 Rs = Rs + (modR+0.5) * maxradius;
% % % %                 Gs = Gs + (modG+0.5) * maxradius;
% % % %                 Bs = Bs + (modB+0.5) * maxradius;
% % % %                 % drawing
% % % %                 h = surf(Rs,Gs,Bs);
% % % %                 % coloring the sphere by the color taken from the center of the respective cube
% % % %                 colorR = cell_avrg_int(modR+1);
% % % %                 colorG = cell_avrg_int(modG+1);
% % % %                 colorB = cell_avrg_int(modB+1);
% % % %                 set(h,'EdgeColor','none', ...
% % % %                     'FaceColor',[ colorR colorG colorB ]/255, ...
% % % %                     'FaceLighting','phong', ...
% % % %                     'AmbientStrength',0.7, ...
% % % %                     'DiffuseStrength',0.4, ...
% % % %                     'SpecularStrength',0.4, ...
% % % %                     'SpecularExponent',500, ...
% % % %                     'BackFaceLighting','reverselit');
% % % %                 hold on
% % % %                 hidden off
% % % %             end
% % % %         end
% % % %     end
% % % % end
% % % % 
% % % % % visualization parameters
% % % % set(gca, 'XColor', 'r','YColor', 'g', 'ZColor', 'b');
% % % % %set(gca, 'XColor', 'r','YColor', [0 0.7 0], 'ZColor', 'b');
% % % % set(gcf, 'color', 'none');
% % % % set(gca, 'color', 'none');
% % % % axis([ 0 255 0 255 0 255]);
% % % % xlabel('R');
% % % % ylabel('G');
% % % % zlabel('B');
% % % % camlight(14,36);
% % % % rotate3d on 
% % % % view(14,36)
% % % % axis square
