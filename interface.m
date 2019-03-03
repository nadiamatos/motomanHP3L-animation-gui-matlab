% Sistema para controle do Manipulador robotico Motoman HP3L

function varargout = interface(varargin)    
    global src;
    % INTERFACE MATLAB code for interface.fig
    %      INTERFACE, by itself, creates a new INTERFACE or raises the existing
    %      singleton*.
    %
    %      H = INTERFACE returns the handle to a new INTERFACE or the handle to
    %      the existing singleton*.
    %
    %      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in INTERFACE.M with the given input arguments.
    %
    %      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before interface_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to interface_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help interface

    % Last Modified by GUIDE v2.5 26-Dec-2017 13:10:47

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @interface_OpeningFcn, ...
                       'gui_OutputFcn',  @interface_OutputFcn, ...
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

% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to interface (see VARARGIN)

    % Choose default command line output for interface
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure

    % -------------------------------------------------------------------------
    % OBS: Falta colocar a logo da ISEC na interface.
    % Area Logo LABIRAS e ISEC
    global l1 l2 l3 l4 l5 l6 lf
    global T01 T02 T03 T04 T05 T06
    global T01old T02old T03old T04old T05old T06old
    global t1 t2 t3 t4 t5 t6
    global t1_ant t2_ant t3_ant t4_ant t5_ant t6_ant
    global x y z x1 y1 z1
    global x_ant y_ant z_ant
    varargout{1} = handles.output;

    %axes(handles.isec);
    %isec = imread('isec1.png');
    %axes(handles.labiras);
    %labiras = imread('labiras.png');

    %grid off; axis off; imshow(labiras); imshow(isec);
    %drawnow;

    % --- Volume do Manipulador -------------------------------------------
    axes(handles.modelo3D)    
    grid on
    axis on    

    % Carregamento das partes do manipulador
    robot = hgload('robot.dat'); % Corpo do manipulador

    l1 = findobj('Tag', 'peca1'); % elo 1 
    l2 = findobj('Tag', 'peca2'); % elo 2
    l3 = findobj('Tag', 'peca3'); % elo 3
    l4 = findobj('Tag', 'peca4'); % elo 4
    l5 = findobj('Tag', 'peca5'); % elo 5
    l6 = findobj('Tag', 'peca6'); % elo 6
    lf = 0;                       % efetuador

    view(120, 30)                    % angulo de visao
    axis([-500 900 -600 600 0 1200]); % tamanho da janela de visao
    light

    % angulos iniciais do manipulador.
    t1 = 0; t2 = 0; t3 = 0; t4 = 0; t5 = 0; t6 = 0;    

    % calculo da cinematica direta
    t = [t1 t2 t3 t4 t5 t6];
    [x_ant, y_ant, z_ant, T01, T02, T03, T04, T05, T06] = cinematicadiretaHP3L(t);
    
    % atualizaï¿½ï¿½o inicial da interface.
    set(handles.interface_coordenada_x1, 'String', num2str(x_ant)) % cinematica direta X
    set(handles.interface_coordenada_y1, 'String', num2str(y_ant)) % cinematica direta Y
    set(handles.interface_coordenada_z1, 'String', num2str(z_ant)) % cinematica direta Z
    set(handles.interface_coordenada_x2, 'String', num2str(x_ant)) % cinematica direta X
    set(handles.interface_coordenada_y2, 'String', num2str(y_ant)) % cinematica direta Y
    set(handles.interface_coordenada_z2, 'String', num2str(z_ant)) % cinematica direta Z

    set(handles.interface_junta_t1, 'String', t1)
    set(handles.interface_junta_t2, 'String', t2)
    set(handles.interface_junta_t3, 'String', t3)
    set(handles.interface_junta_t4, 'String', t4)
    set(handles.interface_junta_t5, 'String', t5)
    set(handles.interface_junta_t6, 'String', t6)    
    
    T01old = T01; T02old = T02; T03old = T03;
    T04old = T04; T05old = T05; T06old = T06;
    
    x = x_ant; y = y_ant; z = z_ant;
    x1 = x_ant; y1 = y_ant; z1 = z_ant;
    t1_ant = t1; t2_ant = t2; t3_ant = t3; 
    t4_ant = t4; t5_ant = t5; t6_ant = t6;

% -------------------------------------------------------------------------
% --- Controle da Interface Grï¿½fica ---------------------------------------

% --- Executes during object creation, after setting all properties.
function labiras_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function modelo3D_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function painel_juntas_CreateFcn(hObject, eventdata, handles)

% --- Executes on slider movement.
function interface_barra_t1_Callback(hObject, eventdata, handles)
  global t1
  t1 = get(hObject,'Value');
  set(handles.interface_junta_t1, 'String', num2str(t1));
  atualizar_interface(handles)
  
% --- Executes during object creation, after setting all properties.
function interface_barra_t1_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function interface_barra_t2_Callback(hObject, eventdata, handles)
    global t2
    t2 = get(hObject,'Value');
    set(handles.interface_junta_t2, 'String', num2str(t2));
    atualizar_interface(handles)

% --- Executes during object creation, after setting all properties.
function interface_barra_t2_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function interface_barra_t3_Callback(hObject, eventdata, handles)
    global t3
    t3 = get(hObject,'Value');
    set(handles.interface_junta_t3, 'String', num2str(t3));
    atualizar_interface(handles)

% --- Executes during object creation, after setting all properties.
function interface_barra_t3_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function interface_barra_t4_Callback(hObject, eventdata, handles)
    global t4
    t4 = get(hObject,'Value');
    set(handles.interface_junta_t4, 'String', num2str(t4));
    atualizar_interface(handles)

% --- Executes during object creation, after setting all properties.
function interface_barra_t4_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function interface_barra_t5_Callback(hObject, eventdata, handles)
    global t5
    t5 = get(hObject,'Value');
    set(handles.interface_junta_t5, 'String', num2str(t5));
    atualizar_interface(handles)

% --- Executes during object creation, after setting all properties.
function interface_barra_t5_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

% --- Executes on slider movement.
function interface_barra_t6_Callback(hObject, eventdata, handles)
    global t6
    t6 = get(hObject,'Value');
    set(handles.interface_junta_t6, 'String', num2str(t6));
    atualizar_interface(handles)

% --- Executes during object creation, after setting all properties.
function interface_barra_t6_CreateFcn(hObject, eventdata, handles)
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end

function interface_junta_t1_Callback(hObject, eventdata, handles)  
  theta = str2num(get(hObject, 'String'));    
  controle_junta_t1(theta, handles);
  atualizar_interface(handles)
  
function controle_junta_t1(theta, handles)
  global t1 t1_ant
  t1_ant = t1;
  if size(theta) == 0           
      set(handles.interface_barra_t1, 'String', num2str(t1));
      set(handles.interface_junta_t1, 'String', t1)
  else
      if (theta > -171 && theta < 170)
          t1 = theta;
          set(handles.interface_barra_t1, 'Value', t1);
          set(handles.interface_junta_t1, 'String', t1)                    
      else          
          if(theta < -171)
              t1 = -170;
          elseif(theta > 170)
              t1 = 169;
          end          
          set(handles.interface_barra_t1, 'Value', t1)
          set(handles.interface_junta_t1, 'String', t1)          
      end
  end   
  
% --- Executes during object creation, after setting all properties.
function interface_junta_t1_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function interface_junta_t2_Callback(hObject, eventdata, handles)    
    theta = str2num(get(hObject,'String'));
    controle_junta_t2(theta, handles);
    atualizar_interface(handles)

function controle_junta_t2(theta, handles)
  global t2 t2_ant
  t2_ant = t2;
  if size(theta) == 0           
      set(handles.interface_barra_t2, 'String', num2str(t2));
      set(handles.interface_junta_t2, 'String', t2)
  else
      if (theta > -45 && theta < 150)
          t2 = theta;
          set(handles.interface_barra_t2, 'Value', t2);
          set(handles.interface_junta_t2, 'String', t2)                    
      else          
          if(theta < -45)
              t2 = -44;
          elseif(theta > 150)
              t2 = 149;
          end         
          set(handles.interface_barra_t2, 'Value', t2)
          set(handles.interface_junta_t2, 'String', t2)          
      end
  end 
  
% --- Executes during object creation, after setting all properties.
function interface_junta_t2_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function interface_junta_t3_Callback(hObject, eventdata, handles)    
    theta = str2num(get(hObject,'String'));
    controle_junta_t3(theta, handles);
    atualizar_interface(handles)    

function controle_junta_t3(theta, handles)
  global t3 t3_ant
  t3_ant = t3;
  if size(theta) == 0           
      set(handles.interface_barra_t3, 'String', num2str(t3));
      set(handles.interface_junta_t3, 'String', t3)
  else
      if (theta > -144 && theta < 235)
          t3 = theta;
          set(handles.interface_barra_t3, 'Value', t3);
          set(handles.interface_junta_t3, 'String', t3)                    
      else          
          if(theta < -144)
              t3 = -143;
          elseif(theta > 235)
              t3 = 234;
          end                              
          set(handles.interface_barra_t3, 'Value', t3)
          set(handles.interface_junta_t3, 'String', t3)
      end
  end 
% --- Executes during object creation, after setting all properties.
function interface_junta_t3_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t3 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function controle_coordenadas()
    % axis([-500 900 -600 600 0 900]); % tamanho da janela de visao
    global x y z
    
    if(x < -500)
        x = -499;
    elseif(x > 900)
        x = 899;
    end
    
    if(y < -600)
        y = -599;
    elseif(y > 600)
        y = 599;
    end    

    if(z < 0)
        z = 1;
    elseif(z > 900)
        z = 899;
    end  
    
% COLOCAR A CINEMATICA INVERSA NA FUNï¿½ï¿½O ABAIXO
function interface_coordenada_x1_Callback(hObject, eventdata, handles)
    % hObject    handle to interface_coordenada_x1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of interface_coordenada_x1 as text
    %        str2double(get(hObject,'String')) returns contents of interface_coordenada_x1 as a double    
    global x x_ant  
    value = str2num(get(hObject,'String'));
    if ((value > -500) && (value < 900))
        x_ant = x; x = value;
    end
    
function interface_coordenada_x1_CreateFcn(hObject, eventdata, handles)
    % --- Executes during object creation, after setting all properties.

    % hObject    handle to interface_coordenada_x1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% COLOCAR A CINEMATICA INVERSA NA FUNï¿½ï¿½O ABAIXO
function interface_coordenada_y1_Callback(hObject, eventdata, handles)
    % hObject    handle to interface_coordenada_y1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of interface_coordenada_y1 as text
    %        str2double(get(hObject,'String')) returns contents of interface_coordenada_y1 as a double    
    global y y_ant
    value = str2num(get(hObject,'String'));
    if ((value > -600) && (value < 600))
        y_ant = y; y = value;        
    end    

% --- Executes during object creation, after setting all properties.
function interface_coordenada_y1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to interface_coordenada_y1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% COLOCAR A CINEMATICA INVERSA NA FUNï¿½ï¿½O ABAIXO
function interface_coordenada_z1_Callback(hObject, eventdata, handles)
    % hObject    handle to interface_coordenada_z1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of interface_coordenada_z1 as text
    %        str2double(get(hObject,'String')) returns contents of interface_coordenada_z1 as a double
    global z z_ant   
    value = str2num(get(hObject, 'String'));
    if ((value > 0) && (value < 900))
        z_ant = z; z = value;
    end    

% --- Executes during object creation, after setting all properties.
function interface_coordenada_z1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to interface_coordenada_y1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

function interface_coordenada_x2_Callback(hObject, eventdata, handles)
% hObject    handle to interface_coordenada_x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interface_coordenada_x2 as text
%        str2double(get(hObject,'String')) returns contents of interface_coordenada_x2 as a double
    global x1
    value = str2num(get(hObject, 'String'));
    if ((value > -500) && (value < 900))
        x1 = value;
    end    
    
% --- Executes during object creation, after setting all properties.
function interface_coordenada_x2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interface_coordenada_x2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function interface_coordenada_y2_Callback(hObject, eventdata, handles)
% hObject    handle to interface_coordenada_y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interface_coordenada_y2 as text
%        str2double(get(hObject,'String')) returns contents of interface_coordenada_y2 as a double
    global y1    
    value = str2num(get(hObject, 'String'));
    if ((value > -600) && (value < 600))
        y1 = value;
    end    


% --- Executes during object creation, after setting all properties.
function interface_coordenada_y2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interface_coordenada_y2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function interface_coordenada_z2_Callback(hObject, eventdata, handles)
% hObject    handle to interface_coordenada_z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of interface_coordenada_z2 as text
%        str2double(get(hObject,'String')) returns contents of interface_coordenada_z2 as a double
    global z1    
    value = str2num(get(hObject, 'String'));
    if ((value > 0) && (value < 900))
        z1 = value;
    end    

% --- Executes during object creation, after setting all properties.
function interface_coordenada_z2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to interface_coordenada_z2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function interface_junta_t6_Callback(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of interface_junta_t6 as text
    %        str2double(get(hObject,'String')) returns contents of interface_junta_t6 as a double    
    theta = str2num(get(hObject,'String'));
    controle_junta_t6(theta, handles);
    atualizar_interface(handles)    

function controle_junta_t6(theta, handles)
  global t6 t6_ant
  t6_ant = t6;
  if size(theta) == 0           
      set(handles.interface_barra_t6, 'String', num2str(t6));
      set(handles.interface_junta_t6, 'String', t6)
  else
      if (theta > -360 && theta < 360)
          t6 = theta;
          set(handles.interface_barra_t6, 'Value', t6);
          set(handles.interface_junta_t6, 'String', t6)                    
      else          
          if(theta < -360)
             t6 = -359;
          elseif(theta > 360)
             t6 = 359;
          end                      
          set(handles.interface_barra_t6, 'Value', t6)                    
          set(handles.interface_junta_t6, 'String', t6)                    
      end
  end
  
% --- Executes during object creation, after setting all properties.
function interface_junta_t6_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t6 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on slider movement.
function interface_junta_t5_Callback(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of interface_junta_t5 as text
    %        str2double(get(hObject,'String')) returns contents of interface_junta_t5 as a double    
    theta = str2num(get(hObject,'String'));
    controle_junta_t5(theta, handles);
    atualizar_interface(handles)        

function controle_junta_t5(theta, handles)
  global t5 t5_ant
  t5_ant = t5;
  if size(theta) == 0           
      set(handles.interface_barra_t5, 'String', num2str(t5));
      set(handles.interface_junta_t5, 'String', t5)
  else
      if (theta > -125 && theta < 125)
          t5 = theta;
          set(handles.interface_barra_t5, 'Value', t5);
          set(handles.interface_junta_t5, 'String', t5)                    
      else          
          if(theta < -125)
             t5 = -124;
          elseif(theta > 125)
             t5 = 124;
          end            
          set(handles.interface_barra_t5, 'Value', t5)                              
          set(handles.interface_junta_t5, 'String', t5)          
      end
  end
  
% --- Executes during object creation, after setting all properties.
function interface_junta_t5_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t5 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% --- Executes on slider movement.
function interface_junta_t4_Callback(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of interface_junta_t4 as text
    %        str2double(get(hObject,'String')) returns contents of interface_junta_t4 as a double    
    theta = str2num(get(hObject,'String'));
    controle_junta_t4(theta, handles)
    atualizar_interface(handles)        

function controle_junta_t4(theta, handles)
  global t4 t4_ant
  t4_ant = t4;
  if size(theta) == 0          
      set(handles.interface_barra_t4, 'String', num2str(t4));
      set(handles.interface_junta_t4, 'String', t4)
  else
      if (theta > -190 && theta < 190)
          t4 = theta;
          set(handles.interface_barra_t4, 'Value', t4);
          set(handles.interface_junta_t4, 'String', t4)                    
      else          
          if(theta < -190)
             t4 = -189;
          elseif(theta > 190)
              t4 = 189;
          end                      
          set(handles.interface_barra_t4, 'Value', t4)                    
          set(handles.interface_junta_t4, 'String', t4)          
      end
  end 
  
% --- Executes during object creation, after setting all properties.
function interface_junta_t4_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to interface_junta_t4 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end

% actualizaï¿½ï¿½o da posiï¿½ï¿½o do robot
function atualizar_interface(handles)
  global t1 t2 t3 t4 t5 t6  
  global l1 l2 l3 l4 l5 l6
  global x_ant y_ant z_ant x y z
  % global a2 a3 a4 d1 d2 d4 d5 d6
  global T01 T02 T03 T04 T05 T06
  global T01old T02old T03old T04old T05old T06old
    
  t = [t1 t2 t3 t4 t5 t6];
  x_ant = x; y_ant = y; z_ant = z;
  [x, y, z, T01, T02, T03, T04, T05, T06] = cinematicadiretaHP3L(t);  
  
  j = 1; k = 0; old = 0;
  set(handles.interface_coordenada_x1, 'String', num2str(x))
  set(handles.interface_coordenada_y1, 'String', num2str(y))
  set(handles.interface_coordenada_z1, 'String', num2str(z))
  
  while(j ~= 7)
      if(j == 1)
          peca = l1; T1 = T01old^-1; T2 = T01;
      elseif(j == 2)
          peca = l2; T1 = T02old^-1; T2 = T02;
      elseif(j == 3)
          peca = l3; T1 = T03old^-1; T2 = T03;            
      elseif(j == 4)
          peca = l4; T1 = T04old^-1; T2 = T04;            
      elseif(j == 5)
          peca = l5; T1 = T05old^-1; T2 = T05;            
      elseif(j == 6)
          peca = l6; T1 = T06old^-1; T2 = T06;
      end
    
      % sï¿½ processa a partir do angulo alterado em comparaï¿½ao com 
      % a ultima alteraï¿½ao
      if(old == 0)
        if(T1^-1 == T2) % quando ocorrer, nao houve alteracao do angulo.
            j = j + 1;                       
        else
            old = 1;            
        end      
      elseif (old == 1)          
          X = get(peca, 'XData'); x1 = X(1,:);         
          if size(X,1) == 3
              x2 = X(2,:); x3 = X(3,:);
          end
          
          Y = get(peca, 'YData'); y1 = Y(1,:);          
          if size(Y,1) == 3
              y2 = Y(2,:); y3 = Y(3,:);
          end          
          
          Z = get(peca, 'ZData'); z1 = Z(1,:);          
          if size(Z,1) == 3
              z2 = Z(2,:); z3 = Z(3,:);
          end      
          if size(X,1) == 1
              objecto=[x1; y1; z1; ones(1,size(x1,2))];
              if k == 0
                  final = T1*objecto;
              elseif k == 1
                  final = T2*objecto;
              end
              set(peca, 'XData', [final(1,1:size(x1,2))]);
              set(peca, 'YData', [final(2,1:size(x1,2))]);
              set(peca, 'ZData', [final(3,1:size(x1,2))]);
          end      
          if size(X,1) == 3
              objecto = [x1 x2 x3; y1 y2 y3; ... 
                         z1 z2 z3; ones(1,3*size(x1,2))];
              if k == 0
                  final = T1*objecto;          
              elseif k == 1
                  final = T2*objecto;
              end
              set(peca,'XData',[final(1, 1:size(x1, 2)); ...
                                final(1, size(x1, 2)+1:2*size(x1, 2)); ...
                                final(1, 2*size(x1, 2)+1:3*size(x1, 2))]);
              set(peca,'YData',[final(2, 1:size(x1, 2)); ...
                                final(2, size(x1, 2)+1:2*size(x1, 2)); ... 
                                final(2, 2*size(x1, 2)+1:3*size(x1, 2))]);
              set(peca,'ZData',[final(3, 1:size(x1, 2)); ... 
                                final(3, size(x1, 2)+1:2*size(x1, 2)); ...
                                final(3, 2*size(x1, 2)+1:3*size(x1, 2))]);
          end      
          if(j == 1)
              l1 = peca;            
          elseif(j == 2)
              l2 = peca;
          elseif(j == 3)
              l3 = peca;
          elseif(j == 4)
              l4 = peca;
          elseif(j == 5)
              l5 = peca;
          elseif(j == 6)
              l6 = peca;
          end
      
          k = k + 1;
          if(k == 2)
              j = j + 1; k = 0;
          end
      end
  end
  % if(roundn(T06(3,4),-1)>0)  
  T01old = T01; T02old = T02; T03old = T03;
  T04old = T04; T05old = T05; T06old = T06;
  drawnow;  

function controles_juntas(t, handles)    
    controle_junta_t1(t(1), handles); 
    controle_junta_t2(t(2), handles);
    controle_junta_t3(t(3), handles); 
    controle_junta_t4(t(4), handles);
    controle_junta_t5(t(5), handles); 
    controle_junta_t6(t(6), handles);

function [pt] = interpolacao(ptf, pti)
    tf = 3; % 3 segundos
    t = 0: 0.3 : tf;    
    a0 = pti; a2 = (3*(ptf - pti))/(tf^2);
    a3 = (-2*(ptf - pti))/(tf^3);
    pt = a0 + a2*(t.^2) + a3*(t.^3);    

% --- Executes on button press in btn_confirma_coordenadas.
function btn_confirma_coordenadas_Callback(hObject, eventdata, handles)
    % hObject    handle to btn_confirma_coordenadas (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    global t1 t2 t3 t4 t5 t6 object_tipos_traj
    global t1_ant t2_ant t3_ant t4_ant t5_ant t6_ant
    global x y z x1 y1 z1 x_ant y_ant z_ant
    tf = 3;
    if(get(object_tipos_traj, 'Value') == 2)
      % traj espaço cartesianos      
      coord_x = interpolacao(x1, x);
      coord_y = interpolacao(y1, y);
      coord_z = interpolacao(z1, z);
      t = [t1 t2 t3 t4 t5 t6];
      pts_coordenadas = [coord_x; coord_y; coord_z];
      pts_juntas = zeros(6, length(coord_x));            
      for i = 1 : (length(coord_x)-1)
        [t1, t2, t3, t4, t5, t6] = pseudoinversa([coord_x(i), coord_y(i), coord_z(i)], ...
                                                 [coord_x(i+1), coord_y(i+1), coord_z(i+1)], t);   
        t = [t1 t2 t3 t4 t5 t6];
        controles_juntas(t, handles)
        atualizar_interface(handles)
        [pts_coordenadas(1, i), pts_coordenadas(2, i), pts_coordenadas(3, i)] = cinematicadiretaHP3L(t);                      
        pts_juntas(:, i) = t;     
      end  
    % plotagem gráficos
    indice = 0: 0.3 : tf; cont = 0;
    f1 = figure('Name', "Trajetórias Espaço CARTESIANO");   
    cont = cont + 1;
    subplot(2, 3, cont); 
    plot(pts_coordenadas(1,:), pts_coordenadas(2,:), 'b')    
    title('Cartesian Trajectory');  
    xlabel('axis x'); ylabel('axis y');  
    axis([-500 900 -600 600]); % tamanho da janela de visao
    grid on;         
    
 	  for i = 1:5
	  	  cont = cont + 1;
	  	  subplot(2, 3, cont);    	
	  	  pts_juntas  	  
		  if degtorad(pts_juntas(i, :)) == 0
		  	% se todos os elementos NAO forem nulos.	
		  else
		  	plot(indice, degtorad(pts_juntas(i, :)), 'b');			  	
		  end		  
		  ylabel('Angles (rad)'); xlabel('Time (sec)'); 
		  title(strcat('Joint positions t', num2str(i)));			  
		  grid on; 
		  axis([0 2 -pi pi])		     
	  end               
      
    elseif(get(object_tipos_traj, 'Value') == 3)
      % traj espaço juntas 
      t = [t1_ant t2_ant t3_ant t4_ant t5_ant t6_ant];
      [t_inicial(1), t_inicial(2), t_inicial(3), ... 
       t_inicial(4), t_inicial(5), t_inicial(6)] = pseudoinversa([x_ant, y_ant, z_ant], ...
                                                                 [x, y, z], t);       
      t = [t1 t2 t3 t4 t5 t6];
      [t_final(1), t_final(2), t_final(3), ... 
       t_final(4), t_final(5), t_final(6)] = pseudoinversa([x, y, z], ...
                                                           [x1, y1, z1], t);               
      coord_t1 = interpolacao(t_final(1), t_inicial(1));
      coord_t2 = interpolacao(t_final(2), t_inicial(2));
      coord_t3 = interpolacao(t_final(3), t_inicial(3));
      coord_t4 = interpolacao(t_final(4), t_inicial(4));
      coord_t5 = interpolacao(t_final(5), t_inicial(5));
      coord_t6 = interpolacao(t_final(6), t_inicial(6));
      pts_juntas = zeros(6, length(coord_t1));   
      for i = 1 : (length(coord_t1))
        [pts_coordenadas(1, i), pts_coordenadas(2, i), pts_coordenadas(3, i)] = cinematicadiretaHP3L(t);
        t = [coord_t1(i) coord_t2(i) coord_t3(i) coord_t4(i) coord_t5(i) coord_t6(i)];
        pts_juntas(:, i) = t'; 
        controles_juntas(t, handles);
        atualizar_interface(handles);         
      end      
      % plotagem gráficos
      indice = 0: 0.3 : tf; cont = 0;
      f1 = figure('Name', "Trajetórias Espaço JUNTAS");        
      cont = cont + 1;
	  subplot(2, 3, cont); 
	  plot(pts_coordenadas(1,:), pts_coordenadas(2,:), 'b')
	  title('Cartesian Trajectory');   
	  xlabel('axis x'); ylabel('axis y');
	  axis([-500 900 -600 600]); % tamanho da janela de visao
	  grid on;	      
	    	  	 
 	  for i = 1:5
	  	  cont = cont + 1;
	  	  subplot(2, 3, cont);    
		  if degtorad(pts_juntas(i, :)) == 0
		  	% se todos os elementos NAO forem nulos.	
		  else
		  	plot(indice, degtorad(pts_juntas(i, :)), 'b');	
		  end		  
		  ylabel('Angles (rad)'); xlabel('Time (sec)'); 
		  title(strcat('Joint positions t', num2str(i)));			  
		  grid on; 
		  axis([0 2 -pi pi])		     
	  end  

    end
    
% --- Executes on selection change in select_tipos_traj.
function select_tipos_traj_Callback(hObject, eventdata, handles)
    % hObject    handle to select_tipos_traj (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: contents = cellstr(get(hObject,'String')) returns select_tipos_traj contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from select_tipos_traj
    global object_tipos_traj       
    object_tipos_traj = hObject;

% --- Executes during object creation, after setting all properties.
function select_tipos_traj_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to select_tipos_traj (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
