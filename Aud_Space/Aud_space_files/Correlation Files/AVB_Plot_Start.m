function varargout = AVB_Plot_Start(varargin)
% AVB_PLOT_START MATLAB code for AVB_Plot_Start.fig
%      AVB_PLOT_START, by itself, creates a new AVB_PLOT_START or raises the existing
%      singleton*.
%
%      H = AVB_PLOT_START returns the handle to a new AVB_PLOT_START or the handle to
%      the existing singleton*.
%
%      AVB_PLOT_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AVB_PLOT_START.M with the given input arguments.
%
%      AVB_PLOT_START('Property','Value',...) creates a new AVB_PLOT_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AVB_Plot_Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AVB_Plot_Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AVB_Plot_Start

% Last Modified by GUIDE v2.5 23-Nov-2015 13:25:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AVB_Plot_Start_OpeningFcn, ...
                   'gui_OutputFcn',  @AVB_Plot_Start_OutputFcn, ...
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


% --- Executes just before AVB_Plot_Start is made visible.
function AVB_Plot_Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AVB_Plot_Start (see VARARGIN)

% Choose default command line output for AVB_Plot_Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AVB_Plot_Start wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AVB_Plot_Start_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.do_bar,'value');
varargout{2}=get(handles.do_scatter,'value');
% The figure can be deleted now
  delete(hObject);


% --- Executes on button press in do_bar.
function do_bar_Callback(hObject, eventdata, handles)
% hObject    handle to do_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_bar


% --- Executes on button press in do_scatter.
function do_scatter_Callback(hObject, eventdata, handles)
% hObject    handle to do_scatter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of do_scatter


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(hObject,'waitstatus'),'waiting')
    %% The GUI is still in the UIWAIT, use UIRESUME
    uiresume(hObject);
else
    % Hint: delete(hObject) closes the figure
    delete(hObject);
end
