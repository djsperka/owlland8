function varargout = Pop_Anal_GUI_competition(varargin)
% POP_ANAL_GUI_COMPETITION MATLAB code for Pop_Anal_GUI_competition.fig
%      POP_ANAL_GUI_COMPETITION, by itself, creates a new POP_ANAL_GUI_COMPETITION or raises the existing
%      singleton*.
%
%      H = POP_ANAL_GUI_COMPETITION returns the handle to a new POP_ANAL_GUI_COMPETITION or the handle to
%      the existing singleton*.
%
%      POP_ANAL_GUI_COMPETITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_ANAL_GUI_COMPETITION.M with the given input arguments.
%
%      POP_ANAL_GUI_COMPETITION('Property','Value',...) creates a new POP_ANAL_GUI_COMPETITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pop_Anal_GUI_competition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pop_Anal_GUI_competition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pop_Anal_GUI_competition

% Last Modified by GUIDE v2.5 25-Mar-2018 11:05:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pop_Anal_GUI_competition_OpeningFcn, ...
                   'gui_OutputFcn',  @Pop_Anal_GUI_competition_OutputFcn, ...
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


% --- Executes just before Pop_Anal_GUI_competition is made visible.
function Pop_Anal_GUI_competition_OpeningFcn(hObject, eventdata, handles, varargin)
global site_names
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pop_Anal_GUI_competition (see VARARGIN)

% Choose default command line output for Pop_Anal_GUI_competition

addpath('/Users/dan/git/owlland8/Aud_Space/Aud_space_files/Correlation Files/');

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.sites_list,'String',site_names,...
	'Value',1)

set (handles.figure1,'Position',[.1 .1 .8 .8])

fullpath=mfilename ('fullpath');
fprintf ('\nAdding all subdirectories from %s to path\n\n',fullpath)
fname=mfilename;
fpath=fullpath(1:(findstr(fullpath,fname)-2));
fpath = fullfile(fpath,'Aud_Space','Aud_space_files');
addpath(fpath);
cor_fpath = fullfile(fpath,'Correlation Files');
addpath(cor_fpath);
% addpath ('C:\Users\Doug\Box Sync\Everything\Ganguly Garage\Dougs_Matlab_Programs')
% Add_SubDirs(fpath);

% UIWAIT makes Pop_Anal_GUI_competition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pop_Anal_GUI_competition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set (handles.UTT_running,'String','NO')
Pop_Analysis_Run_Competition(handles) %added 10_31_13 djt 


% --- Executes on selection change in unit_type.
function unit_type_Callback(hObject, eventdata, handles)
% hObject    handle to unit_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns unit_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from unit_type


% --- Executes during object creation, after setting all properties.
function unit_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unit_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in same_trode_type.
function same_trode_type_Callback(hObject, eventdata, handles)
% hObject    handle to same_trode_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of same_trode_type


% --- Executes on selection change in variable_1.
function variable_1_Callback(hObject, eventdata, handles)
% hObject    handle to variable_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns variable_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variable_1

if get(hObject,'Value')==7 || get(hObject,'Value')==11
    set(handles.bin_TC,'Enable','on');
    set(handles.bin_CR,'Enable','on');
    set (handles.norm_to_max,'Enable','on');
    set (handles.norm_to_vwi,'Enable','on');
else
    set (handles.bin_TC,'Value',0);
    set (handles.bin_CR,'Value',0);
    set (handles.norm_to_max,'Value',0);
    set (handles.norm_to_vwi,'Value',1);
    set (handles.bin_TC,'Enable','off');
    set (handles.bin_CR,'Enable','off');
    set (handles.norm_to_max,'Enable','off');
    set (handles.norm_to_vwi,'Enable','off');
end

if get(hObject,'Value')==3 || get(hObject,'Value')==6
    set (handles.bin_DP,'Enable','on');
else
    set (handles.bin_DP,'Enable','off');
end

if get(hObject,'Value')==2 || get(hObject,'Value')==5
    set (handles.bin_sep,'Enable','on');
else
    set (handles.bin_sep,'Enable','off');
end


% --- Executes during object creation, after setting all properties.
function variable_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variable_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variable_2.
function variable_2_Callback(hObject, eventdata, handles)
% hObject    handle to variable_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns variable_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variable_2


% --- Executes during object creation, after setting all properties.
function variable_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to variable_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bin_DP.
function bin_DP_Callback(hObject, eventdata, handles)
% hObject    handle to bin_DP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bin_DP
if get(hObject,'Value')
set(handles.DP_cutoff,'Enable','on');
else
    set (handles.DP_cutoff,'Enable','off')
end



function DP_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to DP_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DP_cutoff as text
%        str2double(get(hObject,'String')) returns contents of DP_cutoff as a double


% --- Executes during object creation, after setting all properties.
function DP_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DP_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bin_sep.
function bin_sep_Callback(hObject, eventdata, handles)
% hObject    handle to bin_sep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bin_sep
if get(hObject,'Value')
set(handles.sep_cutoff,'Enable','on');
else
    set (handles.sep_cutoff,'Enable','off')
end



function sep_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to sep_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sep_cutoff as text
%        str2double(get(hObject,'String')) returns contents of sep_cutoff as a double


% --- Executes during object creation, after setting all properties.
function sep_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sep_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in show_norm_check_on.
function show_norm_check_on_Callback(hObject, eventdata, handles)
% hObject    handle to show_norm_check_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_norm_check_on



function rstat_Callback(hObject, eventdata, handles)
% hObject    handle to rstat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rstat as text
%        str2double(get(hObject,'String')) returns contents of rstat as a double


% --- Executes during object creation, after setting all properties.
function rstat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rstat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rloom_Callback(hObject, eventdata, handles)
% hObject    handle to rloom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rloom as text
%        str2double(get(hObject,'String')) returns contents of rloom as a double


% --- Executes during object creation, after setting all properties.
function rloom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rloom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rS_rL_Callback(hObject, eventdata, handles)
% hObject    handle to rS_rL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rS_rL as text
%        str2double(get(hObject,'String')) returns contents of rS_rL as a double


% --- Executes during object creation, after setting all properties.
function rS_rL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rS_rL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in two_var_stat_on.
function two_var_stat_on_Callback(hObject, eventdata, handles)
% hObject    handle to two_var_stat_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of two_var_stat_on



function v1S_v1L_disp_Callback(hObject, eventdata, handles)
% hObject    handle to v1S_v1L_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v1S_v1L_disp as text
%        str2double(get(hObject,'String')) returns contents of v1S_v1L_disp as a double


% --- Executes during object creation, after setting all properties.
function v1S_v1L_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v1S_v1L_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v2S_v2L_disp_Callback(hObject, eventdata, handles)
% hObject    handle to v2S_v2L_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v2S_v2L_disp as text
%        str2double(get(hObject,'String')) returns contents of v2S_v2L_disp as a double


% --- Executes during object creation, after setting all properties.
function v2S_v2L_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v2S_v2L_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in sing_var_stat_on.
function sing_var_stat_on_Callback(hObject, eventdata, handles)
% hObject    handle to sing_var_stat_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sing_var_stat_on


% --- Executes on button press in OpenData.
function OpenData_Callback(hObject, eventdata, handles)
% hObject    handle to OpenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global site_cell site_names selected_site
if ~exist('site_cell')
    site_cell={};
    site_names={};
end
num_sites=length(site_cell);

tempcd=cd;
fullpath=mfilename('fullpath');
fname=mfilename;
startname=strfind(fullpath,fname);
fpath=fullpath(1:startname-1);
targ_path=strcat(fpath,'Aud_Space/Aud_space_files/Dougs_Data/Correlation Summary Workspaces/Competition');
cd(targ_path);
[file_list,pathname]=uigetfile('MultiSelect','on');
cd(tempcd);

if ~iscell(file_list)
    temp_cell{1}=file_list;
    file_list=temp_cell;
end
tempcd=cd;
cd(pathname)
for i=1:length(file_list)
    filename=file_list{i};
    site_cell{num_sites+1}=load(filename);
    char_scan=0;
    no_period=1;
    while no_period
        char_scan=char_scan+1;
        if filename(char_scan)=='.';
            no_period=0;
        end
    end
    site_ID=filename(1:char_scan-1);
    site_names{num_sites+1}=site_ID;
    set(handles.sites_list,'String',site_names,...
        'Value',1)
    num_sites=num_sites+1;
end

cd(tempcd)

% --- Executes on button press in ClearAll.
function ClearAll_Callback(hObject, eventdata, handles)
% hObject    handle to ClearAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global site_cell site_names selected_site
site_cell={};
site_names={};
set(handles.sites_list,'String',site_names,...
	'Value',1)


% --- Executes on button press in clear_site.
function clear_site_Callback(hObject, eventdata, handles)
% hObject    handle to clear_site (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global site_cell site_names
list_value=get (handles.sites_list,'Value');
site_cell(list_value)=[]
site_names(list_value)=[]
set(handles.sites_list,'String',site_names,...
	'Value',1)

% --- Executes on selection change in sites_list.
function sites_list_Callback(hObject, eventdata, handles)
% hObject    handle to sites_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sites_list contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sites_list


% --- Executes during object creation, after setting all properties.
function sites_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sites_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in layer_deep.
function layer_deep_Callback(hObject, eventdata, handles)
% hObject    handle to layer_deep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of layer_deep


% --- Executes on button press in layer_supe.
function layer_supe_Callback(hObject, eventdata, handles)
% hObject    handle to layer_supe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of layer_supe


% --- Executes on button press in layer_inter.
function layer_inter_Callback(hObject, eventdata, handles)
% hObject    handle to layer_inter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of layer_inter


% --- Executes on selection change in layer_combo.
function layer_combo_Callback(hObject, eventdata, handles)
% hObject    handle to layer_combo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns layer_combo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layer_combo


% --- Executes during object creation, after setting all properties.
function layer_combo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layer_combo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rrc_vwi.
function rrc_vwi_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_vwi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_vwi


% --- Executes on button press in rrc_vwo.
function rrc_vwo_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_vwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_vwo


% --- Executes on button press in rrc_vwi_and_vwo.
function rrc_vwi_and_vwo_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_vwi_and_vwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_vwi_and_vwo


% --- Executes on button press in rrc_ai.
function rrc_ai_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_ai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_ai


% --- Executes on button press in rrc_ao.
function rrc_ao_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_ao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_ao


% --- Executes on button press in rrc_vis_resp.
function rrc_vis_resp_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_vis_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_vis_resp


% --- Executes on button press in rrc_aud_resp.
function rrc_aud_resp_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_aud_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_aud_resp


% --- Executes on button press in rrc_as.
function rrc_as_Callback(hObject, eventdata, handles)
% hObject    handle to rrc_as (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rrc_as


% --- Executes on button press in no_prism.
function no_prism_Callback(hObject, eventdata, handles)
% hObject    handle to no_prism (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no_prism


% --- Executes on button press in bin_TC.
function bin_TC_Callback(hObject, eventdata, handles)
% hObject    handle to bin_TC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bin_TC

if get(hObject,'Value')
set(handles.TC_cutoff,'Enable','on');
else
    set (handles.TC_cutoff,'Enable','off')
end



function TC_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to TC_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TC_cutoff as text
%        str2double(get(hObject,'String')) returns contents of TC_cutoff as a double


% --- Executes during object creation, after setting all properties.
function TC_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TC_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bin_CR.
function bin_CR_Callback(hObject, eventdata, handles)
% hObject    handle to bin_CR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bin_CR
if get(hObject,'Value')
    set (handles.CR_cutoff,'Enable','on')
else
    set (handles.CR_cutoff,'Enable','off')
end



function CR_cutoff_Callback(hObject, eventdata, handles)
% hObject    handle to CR_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CR_cutoff as text
%        str2double(get(hObject,'String')) returns contents of CR_cutoff as a double


% --- Executes during object creation, after setting all properties.
function CR_cutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CR_cutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in norm_to_max.
function norm_to_max_Callback(hObject, eventdata, handles)
% hObject    handle to norm_to_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of norm_to_max


% --- Executes on button press in nc_bg_sites.
function nc_bg_sites_Callback(hObject, eventdata, handles)
% hObject    handle to nc_bg_sites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nc_bg_sites


% --- Executes on button press in nc_bg_std.
function nc_bg_std_Callback(hObject, eventdata, handles)
% hObject    handle to nc_bg_std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of nc_bg_std


% --- Executes on button press in resp_bg_sites.
function resp_bg_sites_Callback(hObject, eventdata, handles)
% hObject    handle to resp_bg_sites (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resp_bg_sites


% --- Executes on button press in resp_bg_std.
function resp_bg_std_Callback(hObject, eventdata, handles)
% hObject    handle to resp_bg_std (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resp_bg_std


% --- Executes on button press in show_scat.
function show_scat_Callback(hObject, eventdata, handles)
% hObject    handle to show_scat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value')
    set (handles.sim_metric_type,'Enable','on')
else
    set (handles.sim_metric_type,'Enable','off')
end

% Hint: get(hObject,'Value') returns toggle state of show_scat


% --- Executes on button press in show_nc.
function show_nc_Callback(hObject, eventdata, handles)
% hObject    handle to show_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_nc


% --- Executes on button press in show_resp.
function show_resp_Callback(hObject, eventdata, handles)
% hObject    handle to show_resp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_resp


% --- Executes on button press in show_nc_hist.
function show_nc_hist_Callback(hObject, eventdata, handles)
% hObject    handle to show_nc_hist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_nc_hist


% --- Executes on button press in comp2.
function comp2_Callback(hObject, eventdata, handles)
% hObject    handle to comp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of comp2
if get(hObject,'Value') || get(handles.twoway_glob_nc,'Value')
    set (handles.comp_cond_1,'Enable','on')
    set (handles.comp_cond_2,'Enable','on')
    set (handles.bin_2way,'Enable','on')
else
    set(handles.comp_cond_1,'Enable','off')
    set(handles.comp_cond_2,'Enable','off')
    set (handles.bin_2way,'Enable','off')
end


% --- Executes on selection change in comp_cond_1.
function comp_cond_1_Callback(hObject, eventdata, handles)
% hObject    handle to comp_cond_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comp_cond_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comp_cond_1


% --- Executes during object creation, after setting all properties.
function comp_cond_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comp_cond_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in comp_cond_2.
function comp_cond_2_Callback(hObject, eventdata, handles)
% hObject    handle to comp_cond_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns comp_cond_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comp_cond_2


% --- Executes during object creation, after setting all properties.
function comp_cond_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comp_cond_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in norm_to_vwi.
function norm_to_vwi_Callback(hObject, eventdata, handles)
% hObject    handle to norm_to_vwi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of norm_to_vwi


% --- Executes on selection change in sim_metric_type.
function sim_metric_type_Callback(hObject, eventdata, handles)
% hObject    handle to sim_metric_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sim_metric_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sim_metric_type


% --- Executes during object creation, after setting all properties.
function sim_metric_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_metric_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prism_vs_normal.
function prism_vs_normal_Callback(hObject, eventdata, handles)
% hObject    handle to prism_vs_normal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of prism_vs_normal


% --- Executes on button press in save_n_close.
function save_n_close_Callback(hObject, eventdata, handles)
% hObject    handle to save_n_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_n_close


% --- Executes on button press in no_pause.
function no_pause_Callback(hObject, eventdata, handles)
% hObject    handle to no_pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of no_pause


% --- Executes on button press in bin_2way.
function bin_2way_Callback(hObject, eventdata, handles)
% hObject    handle to bin_2way (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bin_2way


% --- Executes on button press in resp_scat_log.
function resp_scat_log_Callback(hObject, eventdata, handles)
% hObject    handle to resp_scat_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resp_scat_log


% --- Executes on button press in allow_tie.
function allow_tie_Callback(hObject, eventdata, handles)
% hObject    handle to allow_tie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of allow_tie


% --- Executes on button press in comp_to_preNC.
function comp_to_preNC_Callback(hObject, eventdata, handles)
% hObject    handle to comp_to_preNC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of comp_to_preNC


% --- Executes on button press in av_integration.
function av_integration_Callback(hObject, eventdata, handles)
% hObject    handle to av_integration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of av_integration


% --- Executes on button press in av_competition.
function av_competition_Callback(hObject, eventdata, handles)
% hObject    handle to av_competition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of av_competition


% --- Executes on button press in glob_nc.
function glob_nc_Callback(hObject, eventdata, handles)
% hObject    handle to glob_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of glob_nc


% --- Executes on button press in twoway_glob_nc.
function twoway_glob_nc_Callback(hObject, eventdata, handles)
% hObject    handle to twoway_glob_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of twoway_glob_nc
if get(hObject,'Value') || get(handles.comp2,'Value')
    set (handles.comp_cond_1,'Enable','on')
    set (handles.comp_cond_2,'Enable','on')
    set (handles.bin_2way,'Enable','on')
else
    set(handles.comp_cond_1,'Enable','off')
    set(handles.comp_cond_2,'Enable','off')
    set (handles.bin_2way,'Enable','off')
end


% --- Executes on button press in gnc_sqrt.
function gnc_sqrt_Callback(hObject, eventdata, handles)
% hObject    handle to gnc_sqrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gnc_sqrt


% --- Executes on button press in gnc_rho_sq.
function gnc_rho_sq_Callback(hObject, eventdata, handles)
% hObject    handle to gnc_rho_sq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gnc_rho_sq


% --- Executes on selection change in glob_corr_type.
function glob_corr_type_Callback(hObject, eventdata, handles)
% hObject    handle to glob_corr_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns glob_corr_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from glob_corr_type


% --- Executes during object creation, after setting all properties.
function glob_corr_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to glob_corr_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gnc_log_abs.
function gnc_log_abs_Callback(hObject, eventdata, handles)
% hObject    handle to gnc_log_abs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gnc_log_abs


% --- Executes on button press in gnc_abs_sqrt.
function gnc_abs_sqrt_Callback(hObject, eventdata, handles)
% hObject    handle to gnc_abs_sqrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gnc_abs_sqrt


% --- Executes on button press in respmag_vs_nc.
function respmag_vs_nc_Callback(hObject, eventdata, handles)
% hObject    handle to respmag_vs_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of respmag_vs_nc


% --- Executes on button press in dp_v_nc_button.
function dp_v_nc_button_Callback(hObject, eventdata, handles)
Delta_SC_vs_NC_Wrap(handles) %added 10_31_13 djt 

% hObject    handle to dp_v_nc_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in plot_ang_sep.
function plot_ang_sep_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ang_sep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_ang_sep


% --- Executes on button press in resp_vs_ff.
function resp_vs_ff_Callback(hObject, eventdata, handles)
% hObject    handle to resp_vs_ff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of resp_vs_ff


% --- Executes on button press in plot_n2o.
function plot_n2o_Callback(hObject, eventdata, handles)
% hObject    handle to plot_n2o (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_n2o


% --- Executes on button press in run_unpaired_ttest.
function run_unpaired_ttest_Callback(hObject, eventdata, handles)
% hObject    handle to run_unpaired_ttest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Pop_Anal_Unpaired_TTest (handles)


% --- Executes on button press in comp_widths.
function comp_widths_Callback(hObject, eventdata, handles)
% hObject    handle to comp_widths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Compare_Widths_Wrap(handles)


% --- Executes on button press in comp_widths_bim.
function comp_widths_bim_Callback(hObject, eventdata, handles)
% hObject    handle to comp_widths_bim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('/Users/dan/git/owlland8/Aud_Space/Aud_space_files/Correlation Files')
Compare_Widths_Bim_Wrap(handles)


% --- Executes on button press in bim_int.
function bim_int_Callback(hObject, eventdata, handles)
% hObject    handle to bim_int (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('/Users/dan/git/owlland8/Aud_Space/Aud_space_files/Correlation Files')

Bimodal_Integration_Wrap(handles)


% --- Executes on button press in avb_plot.
function avb_plot_Callback(hObject, eventdata, handles)
% hObject    handle to avb_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('/Users/dan/git/owlland8/Aud_Space/Aud_space_files/Correlation Files')
AVB_Plot_Wrap(handles)


% --- Executes on button press in av_comp_plot.
function av_comp_plot_Callback(hObject, eventdata, handles)
% hObject    handle to av_comp_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('/Users/dan/git/owlland8/Aud_Space/Aud_space_files/Correlation Files')
AV_Comp_Scatter(handles)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global site_cell site_names
site_cell={};
site_names={};

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes on button press in sc_vs_nc.
function sc_vs_nc_Callback(hObject, eventdata, handles)
% hObject    handle to sc_vs_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
addpath('/Users/dan/git/owlland8/Aud_Space/Aud_space_files/Correlation Files')
SC_vs_NC(handles)


% --- Executes on button press in var_cov_source.
function var_cov_source_Callback(hObject, eventdata, handles)
% hObject    handle to var_cov_source (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Var_and_Cov_Sources_Wrap(handles)


% --- Executes on button press in rf_sym.
function rf_sym_Callback(hObject, eventdata, handles)
% hObject    handle to rf_sym (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Check_RF_Symmetry(handles)


% --- Executes on button press in stat_loom_resp_counts.
function stat_loom_resp_counts_Callback(hObject, eventdata, handles)
% hObject    handle to stat_loom_resp_counts (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Stat_Loom_Resp_Count(handles)


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Unisensory_Imbalance(handles)


% --- Executes on button press in stat_looom_resp_ff_nc.
function stat_looom_resp_ff_nc_Callback(hObject, eventdata, handles)
% hObject    handle to stat_looom_resp_ff_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Stat_Loom_Resp_FF_NC(handles)


% --- Executes on button press in check_high_nc.
function check_high_nc_Callback(hObject, eventdata, handles)
% hObject    handle to check_high_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Check_High_NC(handles)
