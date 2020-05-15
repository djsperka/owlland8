function varargout = Pop_Anal_GUI_Interloom(varargin)
% POP_ANAL_GUI MATLAB code for Pop_Anal_GUI.fig
%      POP_ANAL_GUI, by itself, creates a new POP_ANAL_GUI or raises the existing
%      singleton*.
%
%      H = POP_ANAL_GUI returns the handle to a new POP_ANAL_GUI or the handle to
%      the existing singleton*.
%
%      POP_ANAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POP_ANAL_GUI.M with the given input arguments.
%
%      POP_ANAL_GUI('Property','Value',...) creates a new POP_ANAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pop_Anal_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pop_Anal_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pop_Anal_GUI

% Last Modified by GUIDE v2.5 03-Nov-2013 15:45:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pop_Anal_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Pop_Anal_GUI_OutputFcn, ...
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


% --- Executes just before Pop_Anal_GUI is made visible.
function Pop_Anal_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
global site_names
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pop_Anal_GUI (see VARARGIN)

% Choose default command line output for Pop_Anal_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.sites_list,'String',site_names,...
	'Value',1)

% UIWAIT makes Pop_Anal_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pop_Anal_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in plot_button.
function plot_button_Callback(hObject, eventdata, handles)
global site_cell site_names
Pop_Analysis_Run_interloom(hObject, eventdata, handles) %added 10_31_13 djt 
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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

[file_list,pathname]=uigetfile('MultiSelect','on');
tempcd=cd;
cd(pathname)
for i=1:length(file_list)
    filename=file_list{i};
    site_cell{num_sites+1}=load(filename);
    char_scan=0;
    counter=0;
    while counter<4
        char_scan=char_scan+1;
        if filename(char_scan)=='_';
            counter=counter+1;
        end
    end
    site_ID=filename(1:char_scan-1);
    site_names{num_sites+1}=site_ID;
    set(handles.sites_list,'String',site_names,...
        'Value',1)
    num_sites=num_sites+1;
end

cd(tempcd)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over OpenData.
function OpenData_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to OpenData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
% global selected_site
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% % get(handles.figure1,'SelectionType');
% % if strcmp(get(handles.figure1,'SelectionType'),'open')
% list_index = get(handles.sites_list,'Value');
% listed=get(handles.sites_list,'String');
% selected_site=listed(list_index);
% % end

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


% --- Executes on selection change in stat_loom_type.
function stat_loom_type_Callback(hObject, eventdata, handles)
% hObject    handle to stat_loom_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns stat_loom_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from stat_loom_type


% --- Executes during object creation, after setting all properties.
function stat_loom_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stat_loom_type (see GCBO)
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


% --- Executes on button press in weight_ave_type.
function weight_ave_type_Callback(hObject, eventdata, handles)
% hObject    handle to weight_ave_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of weight_ave_type


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


% --- Executes on button press in layer_deep.
function layer_deep_Callback(hObject, eventdata, handles)
% hObject    handle to layer_deep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of layer_deep


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


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in variable_1.
function variable_1_Callback(hObject, eventdata, handles)
% hObject    handle to variable_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns variable_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from variable_1


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


% --- Executes on button press in statloomcomp.
function statloomcomp_Callback(hObject, eventdata, handles)
% hObject    handle to statloomcomp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of statloomcomp


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



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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


% --- Executes on button press in sing_var_stat_on.
function sing_var_stat_on_Callback(hObject, eventdata, handles)
% hObject    handle to sing_var_stat_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sing_var_stat_on


% --- Executes on button press in two_var_stat_on.
function two_var_stat_on_Callback(hObject, eventdata, handles)
% hObject    handle to two_var_stat_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of two_var_stat_on


% --- Executes on button press in show_norm_check_on.
function show_norm_check_on_Callback(hObject, eventdata, handles)
% hObject    handle to show_norm_check_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_norm_check_on
