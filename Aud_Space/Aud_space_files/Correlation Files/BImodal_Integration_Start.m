function varargout = BImodal_Integration_Start(varargin)
% BIMODAL_INTEGRATION_START MATLAB code for BImodal_Integration_Start.fig
%      BIMODAL_INTEGRATION_START, by itself, creates a new BIMODAL_INTEGRATION_START or raises the existing
%      singleton*.
%
%      H = BIMODAL_INTEGRATION_START returns the handle to a new BIMODAL_INTEGRATION_START or the handle to
%      the existing singleton*.
%
%      BIMODAL_INTEGRATION_START('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIMODAL_INTEGRATION_START.M with the given input arguments.
%
%      BIMODAL_INTEGRATION_START('Property','Value',...) creates a new BIMODAL_INTEGRATION_START or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BImodal_Integration_Start_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BImodal_Integration_Start_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BImodal_Integration_Start

% Last Modified by GUIDE v2.5 28-May-2017 11:26:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BImodal_Integration_Start_OpeningFcn, ...
                   'gui_OutputFcn',  @BImodal_Integration_Start_OutputFcn, ...
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


% --- Executes just before BImodal_Integration_Start is made visible.
function BImodal_Integration_Start_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BImodal_Integration_Start (see VARARGIN)

% Choose default command line output for BImodal_Integration_Start
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes BImodal_Integration_Start wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BImodal_Integration_Start_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.do_save,'value');
varargout{2}=get(handles.mod_script,'value');

varargout{3}.respSum_vs_respBim=get(handles.respSum_vs_respBim,'Value');
varargout{3}.respBim_vs_add=get(handles.respBim_vs_add,'Value');
varargout{3}.uniImb_vs_add=get(handles.uniImb_vs_add,'Value');
varargout{3}.absUniImb_vs_add=get(handles.absUniImb_vs_add,'Value');
varargout{3}.ffSum_vs_ffBim=get(handles.ffSum_vs_ffBim,'Value');
varargout{3}.ncSum_vs_ncBim=get(handles.ncSum_vs_ncBim,'Value');

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


% --- Executes on button press in var_sum_vs_comb.
function var_sum_vs_comb_Callback(hObject, eventdata, handles)
% hObject    handle to var_sum_vs_comb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of var_sum_vs_comb


% --- Executes on button press in var_bim_vs_sum.
function var_bim_vs_sum_Callback(hObject, eventdata, handles)
% hObject    handle to var_bim_vs_sum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of var_bim_vs_sum


% --- Executes on button press in var_imp_sums.
function var_imp_sums_Callback(hObject, eventdata, handles)
% hObject    handle to var_imp_sums (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of var_imp_sums


% --- Executes on button press in var_bar.
function var_bar_Callback(hObject, eventdata, handles)
% hObject    handle to var_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of var_bar


% --- Executes on button press in var_scat.
function var_scat_Callback(hObject, eventdata, handles)
% hObject    handle to var_scat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of var_scat


% --- Executes on button press in var_bar_norm.
function var_bar_norm_Callback(hObject, eventdata, handles)
% hObject    handle to var_bar_norm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of var_bar_norm


% --- Executes on button press in ff_bar.
function ff_bar_Callback(hObject, eventdata, handles)
% hObject    handle to ff_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ff_bar


% --- Executes on button press in cov_sum_vs_comb.
function cov_sum_vs_comb_Callback(hObject, eventdata, handles)
% hObject    handle to cov_sum_vs_comb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cov_sum_vs_comb


% --- Executes on button press in cov_bim_vs_sum.
function cov_bim_vs_sum_Callback(hObject, eventdata, handles)
% hObject    handle to cov_bim_vs_sum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cov_bim_vs_sum


% --- Executes on button press in cov_bar.
function cov_bar_Callback(hObject, eventdata, handles)
% hObject    handle to cov_bar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cov_bar


% --- Executes on button press in cov_scat.
function cov_scat_Callback(hObject, eventdata, handles)
% hObject    handle to cov_scat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cov_scat


% --- Executes on button press in respSum_vs_respBim.
function respSum_vs_respBim_Callback(hObject, eventdata, handles)
% hObject    handle to respSum_vs_respBim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of respSum_vs_respBim


% --- Executes on button press in respBim_vs_add.
function respBim_vs_add_Callback(hObject, eventdata, handles)
% hObject    handle to respBim_vs_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of respBim_vs_add


% --- Executes on button press in uniImb_vs_add.
function uniImb_vs_add_Callback(hObject, eventdata, handles)
% hObject    handle to uniImb_vs_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of uniImb_vs_add


% --- Executes on button press in absUniImb_vs_add.
function absUniImb_vs_add_Callback(hObject, eventdata, handles)
% hObject    handle to absUniImb_vs_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of absUniImb_vs_add


% --- Executes on button press in ffSum_vs_ffBim.
function ffSum_vs_ffBim_Callback(hObject, eventdata, handles)
% hObject    handle to ffSum_vs_ffBim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ffSum_vs_ffBim


% --- Executes on button press in ncSum_vs_ncBim.
function ncSum_vs_ncBim_Callback(hObject, eventdata, handles)
% hObject    handle to ncSum_vs_ncBim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ncSum_vs_ncBim
