function varargout = Location_Decoder_GUI(varargin)
% LOCATION_DECODER_GUI MATLAB code for Location_Decoder_GUI.fig
%      LOCATION_DECODER_GUI, by itself, creates a new LOCATION_DECODER_GUI or raises the existing
%      singleton*.
%
%      H = LOCATION_DECODER_GUI returns the handle to a new LOCATION_DECODER_GUI or the handle to
%      the existing singleton*.
%
%      LOCATION_DECODER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOCATION_DECODER_GUI.M with the given input arguments.
%
%      LOCATION_DECODER_GUI('Property','Value',...) creates a new LOCATION_DECODER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Location_Decoder_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Location_Decoder_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Location_Decoder_GUI

% Last Modified by GUIDE v2.5 29-May-2015 08:53:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Location_Decoder_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Location_Decoder_GUI_OutputFcn, ...
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


% --- Executes just before Location_Decoder_GUI is made visible.
function Location_Decoder_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Location_Decoder_GUI (see VARARGIN)

% Choose default command line output for Location_Decoder_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Location_Decoder_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Location_Decoder_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
cd('C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition');
[file_list,pathname]=uigetfile('MultiSelect','on');
cd(tempcd);

%deals w/ case where you only select one file
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
% handles    structure with handles and user data (see GUIDATA).global site_cell site_names
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
global site_cell site_names pathname
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

site_names=cell(0);

pathname='C:\Users\debellolab\Desktop\Doug\DATA\OwlLand_8chan\Aud_Space\Aud_space_files\Dougs_Data\Correlation Summary Workspaces\Competition\All_Owls\';

file_list{1}='05_24_15_p1s1_summary.mat';
file_list{2}='05_24_15_p2s1_summary.mat';
file_list{3}='05_24_15_p3s1_summary.mat';
file_list{4}='06_06_15_p2s1_summary.mat';
file_list{5}='06_06_15_p3s1_summary.mat';
file_list{6}='06_10_15_p1s1_summary.mat';
file_list{7}='06_10_15_p3s1_summary.mat';
file_list{8}='06_17_15_p1s1_summary.mat';
file_list{9}='06_17_15_p2s1_summary.mat';
file_list{10}='06_27_15_p1s1_summary.mat';
file_list{11}='07_01_15_p1s1_summary.mat';
file_list{12}='07_01_15_p2s1_summary.mat';
file_list{13}='07_01_15_p3s1_summary.mat';
file_list{14}='07_06_15_p2s1_summary.mat';
file_list{15}='07_06_15_p4s1_summary.mat';
file_list{16}='11_18_14_p1s1_summary.mat';
file_list{17}='11_18_14_p1s2_summary_Sin_Switched.mat';
file_list{18}='11_29_14_p1s1_summary.mat';
file_list{19}='11_29_14_p2s1_summary.mat';
file_list{20}='2_12_15_p1s1_summary.mat';
file_list{21}='2_24_15_p1s1_summary.mat';
file_list{22}='2_24_15_p2s1_summary.mat';
file_list{23}='full_10_29_13_p2s1_summary_3to4weak.mat';
file_list{24}='full_10_29_13_p2s2_summary_3to4weak.mat';
file_list{25}='full_1_26_14_p1s1_summary_static.mat';
file_list{26}='full_1_26_14_p1s2_summary_static.mat';
file_list{27}='full_2_14_14_p1s1_summary_static.mat';
file_list{28}='short_1_11_14_p1s2_summary_static.mat';

for i=1:length(file_list)
    filename=file_list{i};
    site_cell{i}=load(strcat(pathname,filename));
    char_scan=0;
    no_period=1;
    while no_period
        char_scan=char_scan+1;
        if filename(char_scan)=='.';
            no_period=0;
        end
    end
    site_ID=filename(1:char_scan-1);
    site_names{i}=site_ID;
    set(hObject,'String',site_names,...
        'Value',1)
end

% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Location_Decoder_Wrapper (handles)


% --- Executes when selected object is changed in sel_mod_pan.
function sel_mod_pan_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in sel_mod_pan 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.justaud,'Value') || get (handles.justvis,'Value')
    
    set (findall(handles.man_select_panel,'-property','enable'),'enable','off');
else
    
    set (findall(handles.man_select_panel,'-property','enable'),'enable','on');
end
    


% --- Executes on button press in keepvisin.
function keepvisin_Callback(hObject, eventdata, handles)
% hObject    handle to keepvisin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of keepvisin


% --- Executes on button press in dropvisout.
function dropvisout_Callback(hObject, eventdata, handles)
% hObject    handle to dropvisout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dropvisout


% --- Executes on button press in keepaudin.
function keepaudin_Callback(hObject, eventdata, handles)
% hObject    handle to keepaudin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of keepaudin


% --- Executes on button press in dropaudout.
function dropaudout_Callback(hObject, eventdata, handles)
% hObject    handle to dropaudout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dropaudout


% --- Executes on button press in vistuned.
function vistuned_Callback(hObject, eventdata, handles)
% hObject    handle to vistuned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of vistuned


% --- Executes on button press in audtuned.
function audtuned_Callback(hObject, eventdata, handles)
% hObject    handle to audtuned (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of audtuned


% --- Executes on button press in VsI.
function VsI_Callback(hObject, eventdata, handles)
% hObject    handle to VsI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VsI


% --- Executes on button press in VwO.
function VwO_Callback(hObject, eventdata, handles)
% hObject    handle to VwO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VwO


% --- Executes on button press in VsO.
function VsO_Callback(hObject, eventdata, handles)
% hObject    handle to VsO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VsO


% --- Executes on button press in VsO_VwI.
function VsO_VwI_Callback(hObject, eventdata, handles)
% hObject    handle to VsO_VwI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VsO_VwI


% --- Executes on button press in VwO_VsI.
function VwO_VsI_Callback(hObject, eventdata, handles)
% hObject    handle to VwO_VsI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VwO_VsI


% --- Executes on button press in VwO_VwI.
function VwO_VwI_Callback(hObject, eventdata, handles)
% hObject    handle to VwO_VwI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VwO_VwI


% --- Executes on button press in AI.
function AI_Callback(hObject, eventdata, handles)
% hObject    handle to AI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AI


% --- Executes on button press in AO.
function AO_Callback(hObject, eventdata, handles)
% hObject    handle to AO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AO


% --- Executes on button press in AO_VwI.
function AO_VwI_Callback(hObject, eventdata, handles)
% hObject    handle to AO_VwI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AO_VwI


% --- Executes on button press in AI_VwO.
function AI_VwO_Callback(hObject, eventdata, handles)
% hObject    handle to AI_VwO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AI_VwO


% --- Executes on button press in AI_VwI.
function AI_VwI_Callback(hObject, eventdata, handles)
% hObject    handle to AI_VwI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AI_VwI


% --- Executes on button press in VwI.
function VwI_Callback(hObject, eventdata, handles)
% hObject    handle to VwI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of VwI


% --- Executes on button press in AO_VwO.
function AO_VwO_Callback(hObject, eventdata, handles)
% hObject    handle to AO_VwO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AO_VwO


% --- Executes on button press in AI_AO.
function AI_AO_Callback(hObject, eventdata, handles)
% hObject    handle to AI_AO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AI_AO


% --- Executes on selection change in respORpost.
function respORpost_Callback(hObject, eventdata, handles)
% hObject    handle to respORpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns respORpost contents as cell array
%        contents{get(hObject,'Value')} returns selected item from respORpost


% --- Executes during object creation, after setting all properties.
function respORpost_CreateFcn(hObject, eventdata, handles)
% hObject    handle to respORpost (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in norm_type.
function norm_type_Callback(hObject, eventdata, handles)
% hObject    handle to norm_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns norm_type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from norm_type


% --- Executes during object creation, after setting all properties.
function norm_type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to norm_type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in norm_desc.
function norm_desc_Callback(hObject, eventdata, handles)
% hObject    handle to norm_desc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Show_Norm_Descr



function num_shuffles_Callback(hObject, eventdata, handles)
% hObject    handle to num_shuffles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_shuffles as text
%        str2double(get(hObject,'String')) returns contents of num_shuffles as a double


% --- Executes during object creation, after setting all properties.
function num_shuffles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_shuffles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function interp_scale_Callback(hObject, eventdata, handles)
% hObject    handle to interp_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interp_scale as text
%        str2double(get(hObject,'String')) returns contents of interp_scale as a double


% --- Executes during object creation, after setting all properties.
function interp_scale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interp_scale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_pd.
function plot_pd_Callback(hObject, eventdata, handles)
% hObject    handle to plot_pd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_pd

if get(hObject,'Value')
    set(handles.ppd_choice,'Enable','on')
else
    set(handles.ppd_choice,'Enable','off')
end


% --- Executes on selection change in ppd_choice.
function ppd_choice_Callback(hObject, eventdata, handles)
% hObject    handle to ppd_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ppd_choice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ppd_choice


% --- Executes during object creation, after setting all properties.
function ppd_choice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ppd_choice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_trial_samples.
function plot_trial_samples_Callback(hObject, eventdata, handles)
% hObject    handle to plot_trial_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_trial_samples

if get(hObject,'Value')
    set (handles.ts_az,'Enable','on')
    set (handles.ts_el,'Enable','on')
    set (handles.ts_dist,'Enable','on')
else
    set (handles.ts_az,'Enable','off')
    set (handles.ts_el,'Enable','off')
    set (handles.ts_dist,'Enable','off')
end


% --- Executes on button press in ts_az.
function ts_az_Callback(hObject, eventdata, handles)
% hObject    handle to ts_az (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ts_az


% --- Executes on button press in ts_el.
function ts_el_Callback(hObject, eventdata, handles)
% hObject    handle to ts_el (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ts_el


% --- Executes on button press in ts_dist.
function ts_dist_Callback(hObject, eventdata, handles)
% hObject    handle to ts_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ts_dist


% --- Executes on button press in plot_cohort_samples.
function plot_cohort_samples_Callback(hObject, eventdata, handles)
% hObject    handle to plot_cohort_samples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_cohort_samples

if get(hObject,'Value')
    set (handles.cs_az,'Enable','on')
    set (handles.cs_el,'Enable','on')
    set (handles.cs_dist,'Enable','on')
else
    set (handles.cs_az,'Enable','off')
    set (handles.cs_el,'Enable','off')
    set (handles.cs_dist,'Enable','off')
end


% --- Executes on button press in cs_az.
function cs_az_Callback(hObject, eventdata, handles)
% hObject    handle to cs_az (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cs_az


% --- Executes on button press in cs_el.
function cs_el_Callback(hObject, eventdata, handles)
% hObject    handle to cs_el (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cs_el


% --- Executes on button press in cs_dist.
function cs_dist_Callback(hObject, eventdata, handles)
% hObject    handle to cs_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cs_dist


% --- Executes on button press in comp_nc.
function comp_nc_Callback(hObject, eventdata, handles)
% hObject    handle to comp_nc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of comp_nc



function min_chan_Callback(hObject, eventdata, handles)
% hObject    handle to min_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of min_chan as text
%        str2double(get(hObject,'String')) returns contents of min_chan as a double


% --- Executes during object creation, after setting all properties.
function min_chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to min_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in site_plot.
function site_plot_Callback(hObject, eventdata, handles)
% hObject    handle to site_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of site_plot


% --- Executes on button press in show_rf.
function show_rf_Callback(hObject, eventdata, handles)
% hObject    handle to show_rf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_rf
