function varargout = UTT_Criteria_GUI(varargin)
% UTT_CRITERIA_GUI MATLAB code for UTT_Criteria_GUI.fig
%      UTT_CRITERIA_GUI, by itself, creates a new UTT_CRITERIA_GUI or raises the existing
%      singleton*.
%
%      H = UTT_CRITERIA_GUI returns the handle to a new UTT_CRITERIA_GUI or the handle to
%      the existing singleton*.
%
%      UTT_CRITERIA_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UTT_CRITERIA_GUI.M with the given input arguments.
%
%      UTT_CRITERIA_GUI('Property','Value',...) creates a new UTT_CRITERIA_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UTT_Criteria_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UTT_Criteria_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UTT_Criteria_GUI

% Last Modified by GUIDE v2.5 16-Jul-2015 16:54:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UTT_Criteria_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @UTT_Criteria_GUI_OutputFcn, ...
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


% --- Executes just before UTT_Criteria_GUI is made visible.
function UTT_Criteria_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UTT_Criteria_GUI (see VARARGIN)

% Choose default command line output for UTT_Criteria_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UTT_Criteria_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UTT_Criteria_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in rrc_vwi.
function rrc_vwi_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_vwi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_vwi


% --- Executes on button press in rrc_ai.
function rrc_ai_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_ai


% --- Executes on button press in rcc_vwo.
function rcc_vwo_Callback(hObject, eventdata, handles)
% hObject    handle to rcc_vwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rcc_vwo


% --- Executes on button press in rcc_vwi_and_vwo.
function rcc_vwi_and_vwo_Callback(hObject, eventdata, handles)
% hObject    handle to rcc_vwi_and_vwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rcc_vwi_and_vwo


% --- Executes on button press in rcc_ao.
function rcc_ao_Callback(hObject, eventdata, handles)
% hObject    handle to rcc_ao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rcc_ao


% --- Executes on button press in rcc_as.
function rcc_as_Callback(hObject, eventdata, handles)
% hObject    handle to rcc_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rcc_as


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global criteria_handles stopper

set(criteria_handles.rrc_vwi,'Value',get(handles.rrc_vwi,'Value')); %Vw.I>0
set(criteria_handles.rrc_vwo,'Value',get(handles.rcc_vwo,'Value')); %Vw.O~>0
set(criteria_handles.rrc_vwi_and_vwo,'Value',get(handles.rcc_vwi_and_vwo,'Value')); %Vw.I>Vw.O
set(criteria_handles.rrc_ai,'Value',get(handles.rrc_ai,'Value')); %A.I>0
set(criteria_handles.rrc_ao,'Value',get(handles.rcc_ao,'Value')); %A.O~>0
set (criteria_handles.rrc_as,'Value',get(handles.rcc_as,'Value')); %A.S~>0

stopper=0;