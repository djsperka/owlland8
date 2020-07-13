function varargout = AVB_Bar_Start(varargin)
% AVB_BAR_START MATLAB code for AVB_Bar_Start.fig
%      AVB_BAR_START, by itself, creates a new AVB_BAR_START or raises the existing
%      singleton*.
%
%      H = AVB_BAR_START returns the handle to a new AVB_BAR_START or the handle to
%      the existing singleton*.
%
%      AVB_BAR_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVB_BAR_START.M with the given input arguments.
%
%      AVB_BAR_START('Property','Value',...) creates a new AVB_BAR_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AVB_Bar_Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AVB_Bar_Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AVB_Bar_Start

% Last Modified by GUIDE v2.5 24-Nov-2015 10:28:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AVB_Bar_Start_OpeningFcn, ...
                   'gui_OutputFcn',  @AVB_Bar_Start_OutputFcn, ...
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


% --- Executes just before AVB_Bar_Start is made visible.
function AVB_Bar_Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AVB_Bar_Start (see VARARGIN)

% Choose default command line output for AVB_Bar_Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AVB_Bar_Start wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AVB_Bar_Start_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.do_save,'value');
varargout{2}=get(handles.mod_script,'value');

delete(handles.figure1);


% --- Executes on button press in do_save.
function do_save_Callback(hObject, eventdata, handles)
% hObject    handle to do_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_save


% --- Executes on button press in mod_script.
function mod_script_Callback(hObject, eventdata, handles)
% hObject    handle to mod_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mod_script


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
