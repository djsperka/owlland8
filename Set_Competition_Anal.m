function varargout = Set_Competition_Anal(varargin)
% SET_COMPETITION_ANAL MATLAB code for Set_Competition_Anal.fig
%      SET_COMPETITION_ANAL, by itself, creates a new SET_COMPETITION_ANAL or raises the existing
%      singleton*.
%
%      H = SET_COMPETITION_ANAL returns the handle to a new SET_COMPETITION_ANAL or the handle to
%      the existing singleton*.
%
%      SET_COMPETITION_ANAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET_COMPETITION_ANAL.M with the given input arguments.
%
%      SET_COMPETITION_ANAL('Property','Value',...) creates a new SET_COMPETITION_ANAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Set_Competition_Anal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Set_Competition_Anal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Set_Competition_Anal

% Last Modified by GUIDE v2.5 10-Apr-2015 12:45:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Set_Competition_Anal_OpeningFcn, ...
                   'gui_OutputFcn',  @Set_Competition_Anal_OutputFcn, ...
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


% --- Executes just before Set_Competition_Anal is made visible.
function Set_Competition_Anal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Set_Competition_Anal (see VARARGIN)

% Choose default command line output for Set_Competition_Anal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes Set_Competition_Anal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Set_Competition_Anal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in do_bimodal.
function do_bimodal_Callback(hObject, eventdata, handles)
% hObject    handle to do_bimodal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_bimodal


% --- Executes on button press in do_competition.
function do_competition_Callback(hObject, eventdata, handles)
% hObject    handle to do_competition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_competition


% --- Executes on button press in do_prism.
function do_prism_Callback(hObject, eventdata, handles)
% hObject    handle to do_prism (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_prism


% --- Executes on button press in done_button.
function done_button_Callback(hObject, eventdata, handles)
% hObject    handle to done_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global do_competition do_bimodal do_prism stopper set_comp_handle
do_competition=get(handles.do_competition,'Value');
do_bimodal=get(handles.do_bimodal,'Value');
do_prism=get(handles.do_prism,'Value');

%close the window
set_comp_handle=handles.output;

stopper=0;
