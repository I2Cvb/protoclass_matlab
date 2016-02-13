function varargout = guifront(varargin)
% GUIFRONT M-file for guifront.fig
%      GUIFRONT, by itself, creates a new GUIFRONT or raises the existing
%      singleton*.
%
%      H = GUIFRONT returns the handle to a new GUIFRONT or the handle to
%      the existing singleton*.
%
%      GUIFRONT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFRONT.M with the given input arguments.
%
%      GUIFRONT('Property','Value',...) creates a new GUIFRONT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guifront_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guifront_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guifront

% Last Modified by GUIDE v2.5 30-Apr-2010 21:05:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guifront_OpeningFcn, ...
                   'gui_OutputFcn',  @guifront_OutputFcn, ...
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


% --- Executes just before guifront is made visible.
function guifront_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guifront (see VARARGIN)

% Choose default command line output for guifront
handles.output = hObject;

% Update handles structure
% Update handles structure
addpath('data');
handles.classBank = {'Campnosperma Auriculatum', 'Mangifera Foetida', 'Dyera Costulata', ...
    'Durio Lowianus', 'Canarium Apertum', 'Kokoona Littoralis', 'Lophopetalum Javanicum', ...
    'Dillenia Reticulata', 'Anisoptera Costata', 'Neobalanocarpus Heimii', 'Parashorea Densiflora', ...
    'Shorea Macroptera', 'Dialium Indum', 'Intsia Palembanica', 'Koompassia Excelsa', ...
    'Koompassia Malaccensis', 'Pithecellobium Splendens', 'Sindora Coriacea', 'Artocarpus Kemando', ...
    'Myristica Iners', 'Scorodocarpus Borneensis', 'Palaquium Impressinervium', 'Tetramerista Glabra', ...
    'Gonystylus Bancanus', 'Pentace Triptera'};
axes(handles.ax_logoUB);
imshow('data/Logo_UB.jpg');

axes(handles.ax_logoVib);
imshow('data/Logo_vibot.jpg');
guidata(hObject, handles);

% UIWAIT makes guifront wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guifront_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_browse.
function btn_browse_Callback(hObject, eventdata, handles)
% hObject    handle to btn_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load only image formats
[imgInput, pathInput] = uigetfile( ...
{'*.jpeg;*.jpg;*.bmp;','Image Files (*.jpeg,*.jpg,*.bmp)';}, ...
   'Choose image file(s)', 'MultiSelect', 'on')

if(pathInput~=0) % If any image is loaded
    
    if(iscell(imgInput)==0) % Hack: If only one image selected
        imgInput = mat2cell(imgInput);
    end

    [trash nInput] = size(imgInput);

    nPage = ceil(nInput/9); % Compute how many pages needed to load all images

    if(nPage>1)
        handles.step = 1/(nPage-1);
        set(handles.sld_pointer,'Visible', 'on');
        set(handles.sld_pointer,'SliderStep', [handles.step 0.1]);
    else % If only one page is needed, hide image slider
        set(handles.sld_pointer,'Visible', 'off');
    end

%     stat = 'Loading Data';
%     set(handles.txt_status, 'String', stat);

    bot = num2str(1);
    if(nInput>9)
        top = num2str(9);
    else
        top = num2str(nInput);
    end

    str = strcat(bot, '-', top, ' of ', num2str(nInput)); % Display image number
    set(handles.txt_img, 'String', str);

    handles.imgInput = imgInput;
    handles.pathInput = pathInput;
    handles.nInput = nInput;
    handles.nPage = nPage;
    handles.pointer = 1;

    guidata(hObject,handles);

    showMontage(hObject, eventdata, handles);
end


% --- Executes on button press in btn_process.
function btn_process_Callback(hObject, eventdata, handles)
% hObject    handle to btn_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


finpred = [];
finconf = [];

% stat = 'Extracting features'
% set(handles.txt_status, 'String', stat);
guidata(hObject,handles);

for nImg=1:handles.nInput
    img = handles.imgInput{nImg};
    imgData = [handles.pathInput img];
    [pred conf] = fextract(imgData, hObject, eventdata, handles); % Extract features
    pred = pred;
    conf = conf*100;
    finpred = [finpred pred];
    finconf = [finconf conf];
end

handles.finpred = finpred;
handles.finconf = finconf;

guidata(hObject,handles);
showResult(hObject, eventdata, handles)

% --- Executes on slider movement.
function sld_pointer_Callback(hObject, eventdata, handles)
% hObject    handle to sld_pointer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

showMontage(hObject, eventdata, handles);

pointer = get(handles.sld_pointer,'Value');
handles.pointer = num2str(pointer);

sliderPos = handles.nPage-floor(((handles.nPage-1)*pointer));

bot = num2str((sliderPos-1)*9+1);
foo = sliderPos*9;
    if(foo>handles.nInput)
        top = num2str(handles.nInput);
    else
        top = num2str(foo);
    end
    
n = num2str(handles.nInput);

str = strcat(bot, '-', top, ' of  ', n);
set(handles.txt_img, 'String', str); % Display image number
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function sld_pointer_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sld_pointer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function showMontage(hObject, eventdata, handles)
% This function is used to show all chosen images

pointer = get(handles.sld_pointer,'Value');
handles.pointer = num2str(pointer);

sliderPos = handles.nPage-floor(((handles.nPage-1)*pointer));

if(handles.nInput>9)
    handles.bot = (sliderPos-1)*9+1;
    foo = sliderPos*9;
    if(foo>handles.nInput)
        handles.top = handles.nInput;
    else
        handles.top = foo;
    end
else
    handles.bot = 1;
    handles.top = handles.nInput;
end

frames = 0;
for i = handles.bot:handles.top;
    frames = frames+1;
    
    foo = strcat(handles.pathInput, handles.imgInput{i});
    img = imread(foo);
    img = imresize(img, 0.5, 'bilinear');
    
    [row col] = size(img);
    img(1:5, :) = 255;
    img(row-4:row, :) = 255;
    img(:, 1:5) = 255;
    img(:, col-4:col) = 255;
    
    imThumb(:,:,:,frames) = img;
end

if(frames==1)
    mRow = 1;    
    mCol = 1;
elseif(frames==2)
    mRow = 1;    
    mCol = 2;
elseif(frames==4)
    for i=5:6
        imThumb(:,:,:,i) = 255;
    end
    mRow = 2;
    mCol = 3;
elseif(frames==5)    
    imThumb(:,:,:,6) = 255;
    mRow = 2;
    mCol = 3;    
elseif(frames==7)
    for i=8:9
        imThumb(:,:,:,i) = 255;
    end
    mRow = 3;
    mCol = 3;
else
    mRow = NaN;
    mCol = 3;
end

axes(handles.ax_input);
montage(imThumb, 'Size', [mRow mCol]);

guidata(hObject,handles);



function [pred_out_1 pred_out_2] = fextract(imgdata, hObject, eventdata, handles)
% Input: Image data

% Process:
%     - Read image
%     - Extract features with glcm, lbp
%     - Feed features into classifiers
%     - Vote the classifer result

% Output: Predicted class & average confidence value based on voting
% procedure

% addpath('data');
preds = [];
confs = [];
    
img = imread(imgdata);

%% LBP

try
    load 'mapper_16';
    map_16 = mapper;
catch
    h = warndlg('16-neighborhood map is not found. A new map will be created.', 'LBP Info');
    uiwait(h);
%     stat = 'Creating 16-neighborhood map';
%     set(handles.txt_status, 'String', stat);
    map_16 = LBPMap(16);
    stat = '16-neighborhood map is successfully created';
    % Set handles here
end

try
    load 'mapper_24';
    map_24 = mapper;
catch
    h = warndlg('24-neighborhood map is not found. A new map will be created.', 'LBP Info');
    uiwait(h);
    stat = 'Creating 24-neighborhood map';
    % Set handles here
    map_24 = LBPMap(24);
    stat = '24-neighborhood map is successfully created';
    % Set handles here
end

tic
stat = 'Extracting features with LBP'
% Set handles here


% Use only the most prominent feature extraction methods (LBP-16+24)
% and the best classifier: Neural Network-10

H_16=LBP(img,2,16,map_16,'nh');
H_24=LBP(img,3,24,map_24,'nh');

features = cat(2, H_16, H_24);

load cs_nn_lbp_1624
pred = Ws.data;

tempConf = [];
    
for j=1:25 % One-Versus-All classification test
    estim = features*pred{1, j}*classc;
    val = estim.data;
    tempConf = cat(1, tempConf, val);
end
    
[a b c] = find(tempConf(:, 2)==max(tempConf(:, 2)));
pred_out_1 = a;
pred_out_2 = tempConf(a, 2);

toc

function showResult(hObject, eventdata, handles)
% Show result in the provided table

for nImg=1:handles.nInput
    img = handles.imgInput{nImg};
%     img = cell2mat(img)   
    foo = handles.finpred(nImg);
    predres = handles.classBank{1, foo};
    %predres = strcat(predres, ' (', num2str(foo), ')')
    confres = handles.finconf(nImg);
    
    data(nImg, :) = {img predres confres};    
end

set(handles.tbl_result,'Data',data);


