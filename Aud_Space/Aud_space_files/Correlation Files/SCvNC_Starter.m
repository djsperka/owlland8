function varargout = SCvNC_Starter(varargin)
% SCVNC_STARTER MATLAB code for SCvNC_Starter.fig
%      SCVNC_STARTER, by itself, creates a new SCVNC_STARTER or raises the existing
%      singleton*.
%
%      H = SCVNC_STARTER returns the handle to a new SCVNC_STARTER or the handle to
%      the existing singleton*.
%
%      SCVNC_STARTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCVNC_STARTER.M with the given input arguments.
%
%      SCVNC_STARTER('Property','Value',...) creates a new SCVNC_STARTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SCvNC_Starter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SCvNC_Starter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SCvNC_Starter

% Last Modified by GUIDE v2.5 14-Jan-2016 15:38:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCvNC_Starter_OpeningFcn, ...
                   'gui_OutputFcn',  @SCvNC_Starter_OutputFcn, ...
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


% --- Executes just before SCvNC_Starter is made visible.
function SCvNC_Starter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SCvNC_Starter (see VARARGIN)

% Choose default command line output for SCvNC_Starter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SCvNC_Starter wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SCvNC_Starter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.nc_post,'Value')
    nc_choice=1;
elseif get(handles.nc_pre,'Value')
    nc_choice=2;
else
    nc_choice=3;
end

if get(handles.sc_dp,'Value')
    sc_choice=1;
elseif get(handles.sc_peak,'Value')
    sc_choice=2;
elseif get(handles.sc_gm,'Value')
    sc_choice=3;    
elseif get(handles.sc_rfderiv,'Value')
    sc_choice=4;
end

use_vwi=get(handles.vwi,'Value');
use_vwo=get(handles.vwo,'Value');
use_vsi=get(handles.vsi,'Value');
use_vso=get(handles.vso,'Value');
use_ai=get(handles.ai,'Value');
use_ao=get(handles.ao,'Value');

varargout{1} = get(handles.mod_script,'Value');
varargout{end+1}=get(handles.save_figs,'Value');
varargout{end+1}=nc_choice;
varargout{end+1}=sc_choice;
varargout{end+1}=use_vwi;
varargout{end+1}=use_vwo;
varargout{end+1}=use_vsi;
varargout{end+1}=use_vso;
varargout{end+1}=use_ai;
varargout{end+1}=use_ao;
varargout{end+1}=get(handles.stat_loom_anc,'Value');



% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in mod_script.
function mod_script_Callback(hObject, eventdata, handles)
% hObject    handle to mod_script (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mod_script


% --- Executes on button press in vwi.
function vwi_Callback(hObject, eventdata, handles)
% hObject    handle to vwi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vwi


% --- Executes on button press in vsi.
function vsi_Callback(hObject, eventdata, handles)
% hObject    handle to vsi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vsi


% --- Executes on button press in vso.
function vso_Callback(hObject, eventdata, handles)
% hObject    handle to vso (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vso


% --- Executes on button press in vwo.
function vwo_Callback(hObject, eventdata, handles)
% hObject    handle to vwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vwo


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


% --- Executes on button press in sc_dp.
function sc_dp_Callback(hObject, eventdata, handles)
% hObject    handle to sc_dp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sc_dp


% --- Executes on button press in ai.
function ai_Callback(hObject, eventdata, handles)
% hObject    handle to ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ai


% --- Executes on button press in ao.
function ao_Callback(hObject, eventdata, handles)
% hObject    handle to ao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ao


% --- Executes on button press in save_figs.
function save_figs_Callback(hObject, eventdata, handles)
% hObject    handle to save_figs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_figs


% --- Executes on button press in stat_loom_anc.
function stat_loom_anc_Callback(hObject, eventdata, handles)
% hObject    handle to stat_loom_anc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stat_loom_anc
