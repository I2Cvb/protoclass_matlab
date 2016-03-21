function [oct_volume] = read_oct_volume(iname, X, Y, Z)
% READ_OCT_VOLUME Function to read an OCT volume from IMG format.
%     [oct_volume] = read_oct_volume(iname, X, Y, Z) load inside 3D
%     matrix the data of the IMG file.
%
% Required arguments:
%     iname: string
%         Filename of the IMG file.
%
%     X : int
%         X dimension.
%
%     Y : int
%         Y dimension.
%
%     Z : int
%         Z dimension.
%
% Return:
%     out_vol: 3D array, shape (Z, X, Y)
%         OCT volume.
%

    % Extract the extension from the filename
    [~, ~, ext] = fileparts(iname);

    if strcmp(ext, '.img')
        oct_volume = zeros(Z, X, Y);
        fin = fopen(iname,'r');
        for i = 1 : Y
            I = fread(fin, [X, Z],'ubit8=>uint8'); 
            oct_volume(:, :, i) = imrotate(I, 90);
        end
        fclose(fin);
    else
        error('read_oct_volume:NotImplemented', ['The format ', ...
                            ext, 'is not supported currently.']);
    end

end