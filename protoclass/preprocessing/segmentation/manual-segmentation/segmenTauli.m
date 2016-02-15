function varargout = segmenTauli(varargin)
% SEGMENTAULI M-file for segmenTauli.fig
%      SEGMENTAULI, by itself, creates a new SEGMENTAULI or raises the existing
%      singleton*.
%
%      H = SEGMENTAULI returns the handle to a new SEGMENTAULI or the handle to
%      the existing singleton*.
%
%      SEGMENTAULI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTAULI.M with the given input arguments.
%
%      SEGMENTAULI('Property','Value',...) creates a new SEGMENTAULI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmenTauli_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmenTauli_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmenTauli

% Last Modified by GUIDE v2.5 26-Jan-2011 22:42:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segmenTauli_OpeningFcn, ...
                   'gui_OutputFcn',  @segmenTauli_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before segmenTauli is made visible.
function segmenTauli_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmenTauli (see VARARGIN)

% Choose default command line output for segmenTauli
handles.output = hObject;

% Init code and set variables to the GUI
dirAns = dir('images');
imNames = dirAns( ~[dirAns(:).isdir] );

if ~isdir('images/GT')
    mkdir('images/GT');
end
setappdata(gcf, 'imNames',imNames);


if isempty(imNames)
    setappdata(gcf, 'imIdx', -1);
    msgbox('No images found','loading images', 'error');
    set(handles.nextButton,'Enable','off');
    set(handles.prevButton,'Enable','off');
else
    setappdata(gcf, 'imIdx', 3);
    loadImage(handles);
    if getappdata(gcf, 'imIdx')+1 >length(getappdata(gcf, 'imNames'))
        set(handles.nextButton,'Enable','off');
    end
    if getappdata(gcf, 'imIdx')-1 == 0
        set(handles.prevButton,'Enable','off');
    end
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segmenTauli wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function [handles] = loadImage(handles)
imNames = getappdata(gcf, 'imNames');
imIdx   = getappdata(gcf, 'imIdx'  );
try
    I = im2double(imread(['images/' imNames(imIdx).name]));
catch
    I = dicomread(['images/' imNames(imIdx).name]);
end

if size(I,3)==1
    I = repmat(I,[1 1 3]);
end

namePoints = strfind(imNames(imIdx).name,'.');
lastPointName = namePoints(end);
dirAns = dir(['images/GT/' imNames(imIdx).name(1:lastPointName-1) '*']);
axes(handles.axes1)
imshow(I);
if isempty(dirAns)
   set(handles.showSegmentations,'Enable','off');
   set(handles.auxSeg,'Enable','off');
else
    hold on;
    colors = jet(length(dirAns));
    for i=1:length(dirAns)
        contour(imread(['images/GT/' dirAns(i).name]),.5,'color',colors(i,:));
    end
    hold off
    set(handles.showSegmentations,'Enable','on');
    set(handles.showSegmentations,'Value',1);
    set(handles.auxSeg,'Enable','on');
end

setappdata(gcf, 'currentSeg', dirAns);
setappdata(gcf, 'currentImg', I     );

set(handles.text1,'String',[num2str(imIdx) ' of ' num2str(length(imNames))])
% set data on the GUI    


% --- Outputs from this function are returned to the command line.
function varargout = segmenTauli_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
imNames = getappdata(gcf, 'imNames');
imIdx   = getappdata(gcf, 'imIdx'  );
namePoints = strfind(imNames(imIdx).name,'.');
lastPointName = namePoints(end);
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in newSeg.
function newSeg_Callback(hObject, eventdata, handles)
% hObject    handle to newSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% when new segmentation is created, the previous set is deleted
currentSegNames = getappdata(gcf, 'currentSeg');

segmentationNeeded = false;
if ~isempty(currentSegNames)
    choice = questdlg(['The ' num2str(length(currentSegNames)) ...
        ' previous segmentations will be DELETED'], ...
        'New Segmentation', 'OK','Cancel','Cancel');
    if strcmp(choice,'OK')
        % delete the previous segmentations
        for i = 1:length(currentSegNames)
            delete (['images/GT/' currentSegNames(i).name]);
        end
        % enable the segmentation
        segmentationNeeded = true;
    end
else
    segmentationNeeded = true;
end
if segmentationNeeded
    % get the name of the new segmentation
    imNames = getappdata(gcf, 'imNames');
    imIdx   = getappdata(gcf, 'imIdx'  );
    namePoints = strfind(imNames(imIdx).name,'.');
    lastPointName = namePoints(end);
    segName = ['images/GT/' imNames(imIdx).name(1:lastPointName-1) '_seg01.png'];
    % generate de segmentation and save it
    axes(handles.axes1);
    imshow(getappdata(gcf,'currentImg'));
    maskh = imfreehand;
    mask = createMask(maskh);
    imwrite( mask, segName,'png');
    % display the new segmentations
    loadImage(handles);
end
    

% --- Executes on button press in auxSeg.
function auxSeg_Callback(hObject, eventdata, handles)
% hObject    handle to auxSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% determine the segmentation name
imNames = getappdata(gcf, 'imNames');
imIdx   = getappdata(gcf, 'imIdx'  );
namePoints = strfind(imNames(imIdx).name,'.');
lastPointName = namePoints(end);
segNum = num2str( length(getappdata(gcf, 'currentSeg'))+1 ,'%02d');
segName = ['images/GT/' imNames(imIdx).name(1:lastPointName-1) '_seg' segNum '.png'];
% generate de segmentation and save it
axes(handles.axes1);
imshow(getappdata(gcf,'currentImg'));
maskh = imfreehand;
mask = createMask(maskh);
imwrite( mask, segName,'png');
% display the new segmentations
loadImage(handles);



% --- Executes on button press in prevButton.
function prevButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
indx = getappdata(gcf, 'imIdx')-1;
set(handles.nextButton,'Enable','on');
if indx-1 == 0
    set(handles.prevButton,'Enable','off');
end
setappdata(gcf, 'imIdx', indx);
loadImage(handles);


% --- Executes on button press in nextButton.
function nextButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
indx = getappdata(gcf, 'imIdx')+1;
indxMax = length(getappdata(gcf, 'imNames'));
if indx+1 > indxMax
    set(handles.nextButton,'Enable','off');
end
setappdata(gcf, 'imIdx', indx);
loadImage(handles);
set(handles.prevButton,'Enable','on');

    


% --- Executes on button press in showSegmentations.
function showSegmentations_Callback(hObject, eventdata, handles)
% hObject    handle to showSegmentations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
I = getappdata(gcf, 'currentImg'); 
segNames = getappdata(gcf, 'currentSeg');
imshow(I);
if get(handles.showSegmentations,'Value')
    colors = jet(length(segNames));
    for i=1:length(segNames)
        hold on;
        contour(imread(['images/GT/' segNames(1).name]),.5,'color',colors(i,:));
        hold off;
    end
end
    
    
% Hint: get(hObject,'Value') returns toggle state of showSegmentations
