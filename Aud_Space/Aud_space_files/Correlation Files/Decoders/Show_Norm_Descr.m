function varargout = Show_Norm_Descr(varargin)
% SHOW_NORM_DESCR MATLAB code for Show_Norm_Descr.fig
%      SHOW_NORM_DESCR, by itself, creates a new SHOW_NORM_DESCR or raises the existing
%      singleton*.
%
%      H = SHOW_NORM_DESCR returns the handle to a new SHOW_NORM_DESCR or the handle to
%      the existing singleton*.
%
%      SHOW_NORM_DESCR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW_NORM_DESCR.M with the given input arguments.
%
%      SHOW_NORM_DESCR('Property','Value',...) creates a new SHOW_NORM_DESCR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Show_Norm_Descr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Show_Norm_Descr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Show_Norm_Descr

% Last Modified by GUIDE v2.5 15-Apr-2015 13:53:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Show_Norm_Descr_OpeningFcn, ...
                   'gui_OutputFcn',  @Show_Norm_Descr_OutputFcn, ...
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


% --- Executes just before Show_Norm_Descr is made visible.
function Show_Norm_Descr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Show_Norm_Descr (see VARARGIN)

% Choose default command line output for Show_Norm_Descr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Show_Norm_Descr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Show_Norm_Descr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
