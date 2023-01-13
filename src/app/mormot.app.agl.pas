/// High-Level Angelize Logic to Manage Multiple Daemons
// - this unit is a part of the Open Source Synopse mORMot framework 2,
// licensed under a MPL/GPL/LGPL three license - see LICENSE.md
unit mormot.app.agl;

{
  *****************************************************************************

   Daemon (e.g. Windows Service) Stand-Alone Background Executable Support
    - TSynAngelize App-As-Service Launcher

  *****************************************************************************
}

interface

{$I ..\mormot.defines.inc}

uses
  sysutils,
  classes,
  variants,
  mormot.core.base,
  mormot.core.os,
  mormot.core.unicode,
  mormot.core.text,
  mormot.core.buffers,
  mormot.core.datetime,
  mormot.core.rtti,
  mormot.core.json,
  mormot.core.data,
  mormot.core.threads,
  mormot.core.log,
  mormot.net.client,
  mormot.app.console,
  mormot.app.daemon;


{ ************ TSynAngelize App-As-Service Launcher }

type
  /// exception class raised by TSynAngelize
  ESynAngelize = class(ESynException);

  /// define one TSynAngelizeService action
  // - depending on the context, as "method:param" pair
  TSynAngelizeAction = type RawUtf8;
  /// define one or several TSynAngelizeService action(s)
  // - stored as a JSON array in the settings
  TSynAngelizeActions = array of TSynAngelizeAction;

  /// one sub-process definition as recognized by TSynAngelize
  // - TSynAngelizeAction properties will expand %abc% place-holders when needed
  // - specifies how to start, stop and watch a given sub-process
  // - main idea is to let sub-processes remain simple process, not Operating
  // System daemons/services, for a cross-platform and user-friendly experience
  TSynAngelizeService = class(TSynJsonFileSettings)
  protected
    fName: RawUtf8;
    fDescription: RawUtf8;
    fRun, fService: RawUtf8;
    fStart, fStop, fWatch: TSynAngelizeActions;
    fStateMessage: RawUtf8;
    fState: TServiceState;
    fLevel, fWatchDelaySec: integer;
    fRedirectLogFile: TFileName;
    fStarted: array of record
      Executable: RawUtf8;
      PID: PtrUInt;
    end;
    fNextWatch: Int64;
    function GetStartedPID(const Executable: RawUtf8): PtrUInt;
  public
    /// initialize and set the default settings
    constructor Create; override;
    /// the current state of the service, as retrieved during the Watch phase
    property State: TServiceState
      read fState;
    /// text associated to the current state, as generated during Watch phase
    property StateMessage: RawUtf8
      read fStateMessage;
  published
    /// computer-friendly case-insensitive identifier of this sub-service
    // - as used internally by TSynAngelize to identify this instance
    // - should be a short, if possible ASCII and pascal-compatible, identifier
    // - contains e.g. "Name": "AuthService",
    property Name: RawUtf8
      read fName write fName;
    /// some reusable parameter available as %run% place holder
    // - default is void '', but could be used to store an executable name
    // or a Windows service name, e.g. "Run":"/path/to/authservice" or
    // "Run": "MyCompanyService"
    property Run: RawUtf8
      read fRun write fRun;
    /// some reusable parameter available as %run% place holder on Windows
    // - default is void ''
    // - contains e.g. "Service": "MyCompanyAuthService",
    property Service: RawUtf8
      read fService write fService;
    /// human-friendly Unicode text which could be displayed on Web or Console UI
    // - in addition to the Name short identifier
    // - contains e.g. "Name": "Authentication Service",
    property Description: RawUtf8
      read fDescription write fDescription;
    /// sub-services are started from their increasing Level
    // - allow to define dependencies between sub-services
    // - it could be a good idea to define it by increments of ten (10,20,30...),
    // so that intermediate services may be inserted easily in the rings
    // - will disable the entry if set to 0 or any negative number
    property Level: integer
      read fLevel write fLevel;
    /// the action(s) executed to start the sub-process
    // - will be executed in-order
    // - could include %abc% place holders
    // - "start:/path/to/file" for starting and monitoring the process,
    // terminated with "Stop": [ "stop:/path/to/file" ] command, optionally
    // writing console output to RedirectLogFile
    // - "exec:/path/to/file" for not waiting up to its ending
    // - "wait:/path/to/file" for waiting for its ending with 0 exitcode
    // - "http://127.0.0.1:8080/publish/on" for a local HTTP request
    // - "sleep:1000" e.g. for 1 second wait between steps or after start
    // - on Windows, "service:ServiceName" calls TServiceController.Start
    // - if no ':' is set, ":%run%" is assumed, e.g. "start" = "start:%run%"
    // - you can add =## to change the expected result (0 as file exitcode, 200
    // as http status) - e.g. 'wait:%agl.base%\
    property Start: TSynAngelizeActions
      read fStart write fStart;
    /// the action(s) executed to stop the sub-process
    // - will be executed in-order
    // - could include %abc% place holders
    // - "exec:/path/to/file" for not waiting up to its ending
    // - "wait:/path/to/file" for waiting for its ending
    // - "stop:/path/to/file" for stopping a process monitored from a "Start":
    // [ "start:/path/to/file" ] previous command
    // - "http://127.0.0.1:8080/publish/off" for a local HTTP request
    // - "sleep:1000" e.g. for 1 second wait between steps or after stop
    // - on Windows, "service:ServiceName" calls TServiceController.Stop
    // - if no ':' is set, ":%run%" is assumed, e.g. "stop" = "stop:%run%"
    // - you can add =## but the value is ignored during stopping
    property Stop: TSynAngelizeActions
      read fStop write fStop;
    // - will be executed in-order every at WatchDelaySec pace
    // - could include %abc% place holders
    // - "wait:/path/to/file" for waiting for its ending with 0 exitcode
    // - "http://127.0.0.1:8080/publish/watchme" for a local HTTP
    // request returning 200 on status success
    // - on Windows, "service:ServiceName" calls TServiceController.State
    // - if no ':' is set, ":%run%" is assumed, e.g. "exec" = "exec:%run%"
    // - you can add =## to change the expected result (0 as file exitcode, 200
    // as http status)
    property Watch: TSynAngelizeActions
      read fWatch write fWatch;
    /// how many seconds should we wait between each Watch method step
    // - default is 60 seconds
    property WatchDelaySec: integer
      read fWatchDelaySec write fWatchDelaySec;
    /// redirect "start:/path/to/executable" console output to a log file
    property RedirectLogFile: TFileName
      read fRedirectLogFile write fRedirectLogFile;
  end;

  TSynAngelizeServiceClass = class of TSynAngelizeService;

  /// define the main TSynAngelize daemon/service behavior
  TSynAngelizeSettings = class(TSynDaemonSettings)
  protected
    fFolder, fExt, fStateFile: TFileName;
    fHtmlStateFileIdentifier: RawUtf8;
    fHttpTimeoutMS: integer;
  public
    /// set the default values
    constructor Create; override;
  published
    /// where the TSynAngelizeService settings are stored
    // - default is the 'services' sub-folder of the TSynAngelizeSettings
    property Folder: TFileName
      read fFolder write fFolder;
    /// the extension of the TSynAngelizeService settings files
    // - default is '.service'
    property Ext: TFileName
      read fExt write fExt;
    /// timeout in seconds for "http://....." local HTTP requests
    // - default is 200
    property HttpTimeoutMS: integer
      read fHttpTimeoutMS write fHttpTimeoutMS;
    /// the local file used to communicate the current sub-process files
    // from running daemon to the state
    // - default is a TemporaryFileName instance
    property StateFile: TFileName
      read fStateFile write fStateFile;
    /// if set, will generate a StateFile+'.html' content
    // - with a HTML page with this text as description, followed by a <table>
    // of the current services states
    // - could be served e.g. via a local nginx server over Internet (or
    // Intranet) to monitor the services state from anywhere in the world
    property HtmlStateFileIdentifier: RawUtf8
      read fHtmlStateFileIdentifier write fHtmlStateFileIdentifier;
  end;

  /// used to serialize the current state of the services in the executable
  TSynAngelizeState = packed record
    Service: array of record
      Name: RawUtf8;
      State: TServiceState;
      Info: RawUtf8;
    end;
  end;

  /// can run a set of executables as sub-process(es) from *.service definitions
  // - agl ("angelize") is an alternative to NSSM / SRVANY / WINSW
  // - at OS level, there will be a single agl daemon or service
  // - this main agl instance will manage one or several executables as
  // sub-process(es), and act as both Launcher and WatchDog
  // - in addition to TSynDaemon command line switches, you could use /list
  // to retrieve the state of services
  TSynAngelize = class(TSynDaemon)
  protected
    fAdditionalParams: TFileName;
    fSettingsClass: TSynAngelizeServiceClass;
    fExpandLevel: byte;
    fLastUpdateServicesFromSettingsFolder: cardinal;
    fSectionName: RawUtf8;
    fService: array of TSynAngelizeService;
    fLevels: TIntegerDynArray;
    fLastGetServicesStateFile: RawByteString;
    fWatchThread: TSynBackgroundThreadProcess;
    // TSynDaemon command line methods
    function CustomParseCmd(P: PUtf8Char): boolean; override;
    function CustomCommandLineSyntax: string; override;
    function LoadServicesState(out state: TSynAngelizeState): boolean;
    procedure ListServices;
    procedure StartServices;
    procedure StopServices;
    procedure StartWatching;
    procedure WatchEverySecond(Sender: TSynBackgroundThreadProcess);
    procedure StopWatching;
    // sub-service support
    function FindService(const ServiceName: RawUtf8): PtrInt;
    function ComputeServicesStateFiles: integer;
    procedure DoExpand(aService: TSynAngelizeService; const aInput: TSynAngelizeAction;
      out aOutput: TSynAngelizeAction); virtual;
    function DoExpandLookup(aService: TSynAngelizeService;
      var aID: RawUtf8): boolean; virtual;
    procedure DoWatch(aLog: TSynLog; aService: TSynAngelizeService;
      const aAction: TSynAngelizeAction); virtual;
  public
    /// initialize the main daemon/server redirection instance
    // - main TSynAngelizeSettings is loaded
    constructor Create(aSettingsClass: TSynAngelizeServiceClass = nil;
      const aSectionName: RawUtf8 = 'Main'; aLog: TSynLogClass = nil); reintroduce;
    /// finalize the stored information
    destructor Destroy; override;
    /// read and parse all *.service definitions from Settings.Folder
    // - as called by Start overriden method
    // - may be called before head to validate the execution settings
    // - raise ESynAngelize on invalid settings or dubious StateFile
    function LoadServicesFromSettingsFolder: integer;
    /// compute a path/action, replacing all %abc% place holders with their values
    // - %agl.base% is the location of the agl executable
    // - %agl.settings% is the location of the *.service files
    // - %agl.params% are the additional parameters supplied to the command line
    // - %agl.toto% is the "toto": property value in the .service settings,
    // e.g. %agl.servicename% is the service name
    // - TSystemPath values are available as %CommonData%, %UserData%,
    // %CommonDocuments%, %UserDocuments%, %TempFolder% and %Log%
    function Expand(aService: TSynAngelizeService;
      const aAction: TSynAngelizeAction): TSynAngelizeAction;
    /// overriden for proper sub-process starting
    procedure Start; override;
    /// overriden for proper sub-process stoping
    // - should do nothing if the daemon was already stopped
    procedure Stop; override;
  end;


implementation


{ ************ TSynAngelize App-As-Service Launcher }

{ TSynAngelizeService }

constructor TSynAngelizeService.Create;
begin
  inherited Create;
  fWatchDelaySec := 60;
end;

function TSynAngelizeService.GetStartedPID(const Executable: RawUtf8): PtrUInt;
var
  i: PtrInt;
begin
  for i := 0 to high(fStarted) do
    if fStarted[i].Executable = Executable then
    begin
      result := fStarted[i].PID;
      exit;
    end;
  result := 0;
end;


{ TSynAngelizeSettings }

constructor TSynAngelizeSettings.Create;
begin
  inherited Create;
  fHttpTimeoutMS := 200;
  fFolder := Executable.ProgramFilePath + 'services';
  fExt := '.service';
  fStateFile := TemporaryFileName;
end;


{ TSynAngelize }

constructor TSynAngelize.Create(aSettingsClass: TSynAngelizeServiceClass;
  const aSectionName: RawUtf8; aLog: TSynLogClass);
begin
  if aSettingsClass = nil then
    aSettingsClass := TSynAngelizeService;
  fSettingsClass := aSettingsClass;
  inherited Create(TSynAngelizeSettings, Executable.ProgramFilePath,
    Executable.ProgramFilePath,  Executable.ProgramFilePath + 'log');
  with fSettings as TSynAngelizeSettings do
    if fHtmlStateFileIdentifier = '' then // some default text
      FormatUtf8('% Current State',
        [fSettings.ServiceName], fHtmlStateFileIdentifier);
end;

destructor TSynAngelize.Destroy;
begin
  inherited Destroy;
  ObjArrayClear(fService);
  fSettings.Free;
end;

// TSynDaemon command line methods

const
  AGL_CMD: array[0..2] of PAnsiChar = (
    'LIST',
    'SETTINGS',
    nil);

function TSynAngelize.CustomParseCmd(P: PUtf8Char): boolean;
begin
  result := true; // the command has been identified and processed
  case IdemPPChar(P, @AGL_CMD) of
    0:
      ListServices;
    1:
      ConsoleWrite('Found %', [Plural('setting', LoadServicesFromSettingsFolder)]);
  else
    result := false; // display syntax
  end;
end;

function TSynAngelize.CustomCommandLineSyntax: string;
begin
  {$ifdef OSWINDOWS}
  result := '/list /settings';
  {$else}
  result := '--list --settings';
  {$endif OSWINDOWS}
end;

// sub-service support

function TSynAngelize.FindService(const ServiceName: RawUtf8): PtrInt;
begin
  if ServiceName <> '' then
    for result := 0 to high(fService) do
      if IdemPropNameU(fService[result].Name, ServiceName) then
        exit;
  result := -1;
end;

const
  _STATEMAGIC = $5131e3a6;

function SortByLevel(const A, B): integer; // to display by increasing Level
begin
  result := TSynAngelizeService(A).Level - TSynAngelizeService(B).Level;
end;

function TSynAngelize.LoadServicesFromSettingsFolder: integer;
var
  bin: RawByteString;
  fn: TFileName;
  r: TSearchRec;
  s: TSynAngelizeService;
  sas: TSynAngelizeSettings;
  i: PtrInt;
begin
  ObjArrayClear(fService);
  Finalize(fLevels);
  sas := fSettings as TSynAngelizeSettings;
  // remove any previous local state file
  bin := StringFromFile(sas.StateFile);
  if (bin = '') or
     (PCardinal(bin)^ <> _STATEMAGIC) then
  begin
    // this existing file is clearly invalid: store a new safe one in settings
    sas.StateFile := TemporaryFileName;
    // avoid deleting of a non valid file (may be used by malicious tools)
    raise ESynAngelize.CreateUtf8(
      'Invalid StateFile=% content', [sas.StateFile]);
  end;
  DeleteFile(sas.StateFile); // from now on, StateFile is meant to be valid
  // browse folder for settings files and generates fService[]
  fn := sas.Folder + '*' + sas.Ext;
  if FindFirst(fn, faAnyFile - faDirectory, r) = 0 then
  begin
    repeat
      if SearchRecValidFile(r) then
      begin
        s := fSettingsClass.Create;
        s.SettingsOptions := sas.SettingsOptions; // share ini/json format
        fn := sas.Folder + r.Name;
        if s.LoadFromFile(fn) and
           (s.Name <> '') and
           (s.Start <> nil) and
           (s.Stop <> nil) then
          if s.Level > 0 then
          begin
            i := FindService(s.Name);
            if i >= 0 then
              raise ESynAngelize.CreateUtf8(
                'GetServices: duplicated % name in % and %',
                [s.Name, s.FileName, fService[i].FileName]);
            // seems like a valid .service file
            ObjArrayAdd(fService, s);
            AddSortedInteger(fLevels, s.Level);
            s := nil; // don't Free - will be owned by fService[]
          end
          else // s.Level <= 0
            fSettings.LogClass.Add.Log(
              sllDebug, 'GetServices: disabled %', [r.Name], self)
        else
          raise ESynAngelize.CreateUtf8(
                  'GetServices: invalid % content', [r.Name]);
        s.Free;
      end;
    until FindNext(r) <> 0;
    FindClose(r);
  end;
  ObjArraySort(fService, SortByLevel);
  result := length(fService);
end;

function TSynAngelize.ComputeServicesStateFiles: integer;
var
  s: TSynAngelizeService;
  state: TSynAngelizeState;
  sas: TSynAngelizeSettings;
  bin: RawByteString;
  ident, html: RawUtf8;
  i: PtrInt;
begin
  result := length(fService);
  // compute main binary state file
  SetLength(state.Service, result);
  for i := 0 to result - 1 do
  begin
    s := fService[i];
    state.Service[i].Name := s.Name;
    state.Service[i].State := s.State;
    state.Service[i].Info := copy(s.StateMessage, 1, 80); // truncate on display
  end;
  bin := 'xxxx' + RecordSave(state, TypeInfo(TSynAngelizeState));
  PCardinal(bin)^ := _STATEMAGIC;
  if bin <> fLastGetServicesStateFile then
  begin
    // current state did change: persist on disk
    sas := fSettings as TSynAngelizeSettings;
    FileFromString(bin, sas.StateFile);
    fLastGetServicesStateFile := bin;
    ident := sas.HtmlStateFileIdentifier;
    if ident <> '' then
    begin
      // generate human-friendly HTML state file
      FormatUtf8('<!DOCTYPE html><html><head><title>%</title></head>' +
        '<body style="font-family:verdana"><h1>%</h1><hr>' +
        '<h2>Main Service</h2><p>Change Time : %</p><p>Current State : %</p> ' +
        '<p>Services Count : %</p><hr>' +
        '<h2>Sub Services</h2><table><thead><tr><th>Service Name</th>' +
        '<th>Service State</th><th>State Info</th></tr></thead><tbody>',
        [ident, ident, NowToString, ToText(CurrentState)^, result], html);
      for i := 0 to result - 1 do
        with fService[i] do
          html := FormatUtf8('%<tr><td>%</td><td>%</td><td>%</td></tr>',
            [html, Name, ToText(State)^, StateMessage]);
      html := html + '</tbody></table></body></html>';
      FileFromString(html, sas.StateFile + '.html');
    end;
  end;
end;

function TSynAngelize.Expand(aService: TSynAngelizeService;
  const aAction: TSynAngelizeAction): TSynAngelizeAction;
begin
  fExpandLevel := 0;
  DoExpand(aService, aAction, result); // internal recursive method
end;

procedure TSynAngelize.DoExpand(aService: TSynAngelizeService;
  const aInput: TSynAngelizeAction; out aOutput: TSynAngelizeAction);
var
  o, i, j: PtrInt;
  id, v: RawUtf8;
begin
  aOutput := aInput;
  o := 1;
  repeat
    i := PosEx('%', aOutput, o);
    if i = 0 then
      exit;
    j := PosEx('%', aOutput, i + 1);
    if j = 0 then
      exit;
    dec(j, i + 1); // j = length abc
    if j = 0 then
    begin
      delete(aOutput, i, 1); // %% -> %
      o := i + 1;
      continue;
    end;
    id := copy(aOutput, i + 1, j);
    delete(aOutput, i, j + 2);
    o := i;
    if IdemPChar(pointer(id), 'AGL.') then
    begin
      delete(id, 1, 3);
      case FindPropName(['base',
                         'settings',
                         'params'], id) of
        0: // %agl.base% is the location of the agl executable
          StringToUtf8(Executable.ProgramFilePath, v);
        1: // %agl.settings% is the location of the *.service files
          StringToUtf8(TSynAngelizeSettings(fSettings).Folder, v);
        2: // %agl.params% are the additional parameters supplied to command line
          StringToUtf8(fAdditionalParams, v);
      else
        begin
          // %agl.toto% is the "toto": property value in the .service settings
          if not DoExpandLookup(aService, id) then
            raise ESynAngelize.CreateUtf8(
              'Expand: unknown %agl.%%', ['%', id, '%']);
          if fExpandLevel = 50 then
            raise ESynAngelize.CreateUtf8(
              'Expand infinite recursion for agl.%', [id]);
          inc(fExpandLevel); // to detect and avoid stack overflow error
          DoExpand(aService, id, TSynAngelizeAction(v));
          dec(fExpandLevel);
        end;
      end;
    end
    else
    begin
      i := GetEnumNameValue(TypeInfo(TSystemPath), id, true);
      if i < 0 then
        continue;
      StringToUtf8(GetSystemPath(TSystemPath(i)), v);
    end;
    if v = '' then
      continue;
    insert(v, aOutput, o);
    inc(o, length(v));
    v := '';
  until false;
end;

function TSynAngelize.DoExpandLookup(aService: TSynAngelizeService;
  var aID: RawUtf8): boolean;
var
  p: PRttiCustomProp;
begin
  result := false;
  if aService = nil then
    exit;
  p := Rtti.RegisterClass(aService).Props.Find(aID);
  if p = nil then
    exit;
  aID := p.Prop.GetValueText(aService);
  result := true;
end;

type
  TAglContext = (
    doStart,
    doStop,
    doWatch
  );
  TAglAction = (
    aaExec,
    aaWait,
    aaStart,
    aaStop,
    aaHttp,
    aaSleep
    {$ifdef OSWINDOWS} ,
    aaService
    {$endif OSWINDOWS}
    );
  TAglActions = set of TAglAction;
  TAglActionDynArray = array of TAglAction;

function ToText(c: TAglContext): PShortString; overload;
begin
  result := GetEnumName(TypeInfo(TAglContext), ord(c));
end;

function ToText(a: TAglAction): RawUtf8; overload;
begin
  result := GetEnumNameTrimed(TypeInfo(TAglAction), ord(a));
end;

const
  ALLOWED_DEFAULT = [aaExec, aaWait, aaHttp, aaSleep]
    {$ifdef OSWINDOWS} + [aaService] {$endif};
  ALLOWED_ACTIONS: array[TAglContext] of TAglActions = (
    ALLOWED_DEFAULT  + [aaStart], // doStart
    ALLOWED_DEFAULT  + [aaStop],  // doStop
    ALLOWED_DEFAULT               // doWatch
  );

function Parse(const a: TSynAngelizeAction; ctxt: TAglContext;
  out param, text: RawUtf8): TAglActionDynArray;
var
  cmd, one: RawUtf8;
  p: PUtf8Char;
  i, n: PtrInt;
begin
  result := nil;
  Split(a, ':', cmd, param); // may leave param='' e.g. for "start" -> %run%
  n := 0;
  p := pointer(cmd);
  while p <> nil do
  begin
    GetNextItem(p, ',', one);
    i := GetEnumNameValueTrimmed(TypeInfo(TAglAction), pointer(one), length(one));
    if (i < 0) or
       not (TAglAction(i) in ALLOWED_ACTIONS[ctxt]) then
      continue; // just ignore unknown or OS-unsupported 'action:'
    if n <> 0 then
      text := text{%H-} + ',';
    text := text + ToText(TAglAction(i));
    SetLength(result, n + 1);
    result[n] := TAglAction(i);
    inc(n);
  end;
end;

function Exec(Sender: TSynAngelize; Log: TSynLog; Service: TSynAngelizeService;
  Action: TAglAction; Ctxt: TAglContext; const Param: RawUtf8): boolean;
var
  ms: integer;
  p, st: RawUtf8;
  fn: TFileName;
  status, expectedstatus: integer;
  sas: TSynAngelizeSettings;
  {$ifdef OSWINDOWS}
  sc: TServiceController;
  {$endif OSWINDOWS}

  procedure CheckStatus;
  begin
    case Ctxt of
      doStart:
        if status <> expectedstatus then
          raise ESynAngelize.CreateUtf8('DoStart % % returned % but expected %',
            [ToText(Action), p, status, expectedstatus]);
      doWatch:
        if status <> expectedstatus then
        begin
          Service.fState := ssFailed;
          if Service.StateMessage <> '' then
            Service.fStateMessage := Service.StateMessage + ', ';
          Service.fStateMessage := FormatUtf8('%% returned % but expected %',
            [Service.StateMessage, ToText(Action), status, expectedstatus]);
        end;
    end;
  end;

begin
  expectedstatus := 0; // e.g. executable file exitcode = 0 as success
  if Split(Param, '=', p, st) then
    ToInteger(st, expectedstatus);
  case Action of
    aaExec,
    aaWait,
    aaStart,
    aaStop:
      fn := NormalizeFileName(Utf8ToString(p));
    aaHttp:
      if expectedstatus = 0 then // not overriden by ToInteger()
        expectedstatus := HTTP_SUCCESS;
  end;
  if p = '' then
    p := Service.Run; // "exec" = "exec:%run%" (exename or servicename)
  sas := Sender.Settings as TSynAngelizeSettings;
  result := false;
  Status := 0;
  case Action of
    aaExec,
    aaWait:
      begin
        status := RunCommand(fn, Action = aaWait);
        CheckStatus;
      end;
    aaStart:
      begin

      end;
    aaStop:
      begin

      end;
    aaHttp:
      begin
        p := 'http:' + p; // was trimmed by Parse()=aaHttp
        HttpGet(p, '', nil, false, @status, sas.HttpTimeoutMS);
        CheckStatus;
      end;
    aaSleep:
      if ToInteger(Param, ms) then
        Sleep(ms)
      else
        exit;
    {$ifdef OSWINDOWS}
    aaService:
      begin
        if p = '' then
          p := Service.Service;
        sc := TServiceController.CreateOpenService('', '', p);
        try
          case Ctxt of
            doStart:
              sc.Start([]);
            doStop:
              sc.Stop;
            doWatch:
              Service.fState := sc.State;
          end;
        finally
          sc.Free;
        end;
      end;
    {$endif OSWINDOWS}
  else
    raise ESynAngelize.CreateUtf8('Unexpected %', [ord(Action)]); // paranoid
  end;
  result := true;
end;

procedure DoOne(Sender: TSynAngelize; Log: TSynLog; Service: TSynAngelizeService;
  Ctxt: TAglContext; const Action: TSynAngelizeAction);
var
  a: PtrInt;
  aa: TAglActionDynArray;
  param, text: RawUtf8;
begin
  aa := Parse(Action, Ctxt, param, text);
  param := Sender.Expand(Service, param);
  Log.Log(sllDebug, '% %: % as [%] %',
    [ToText(Ctxt)^, Service.Name, Action, text, param], Sender);
  for a := 0 to high(aa) do
    if Exec(Sender, Log, Service, aa[a], Ctxt, param) then
      break;
end;

procedure TSynAngelize.DoWatch(aLog: TSynLog;
  aService: TSynAngelizeService; const aAction: TSynAngelizeAction);
begin
  aService.fState := ssErrorRetrievingState;
  aService.fStateMessage := '';
  DoOne(self, aLog, aService, TAglContext.doWatch, aAction);
  aLog.Log(sllTrace, 'DoWatch % % = % [%]', [aService.Name,
    aAction, ToText(aService.State)^, aService.StateMessage], self);
end;

function TSynAngelize.LoadServicesState(out state: TSynAngelizeState): boolean;
var
  bin: RawByteString;
begin
  result := false;
  bin := StringFromFile(TSynAngelizeSettings(fSettings).StateFile);
  if (bin = '') or
     (PCardinal(bin)^ <> _STATEMAGIC) then
    exit;
  delete(bin, 1, 4);
  result := RecordLoad(state, bin, TypeInfo(TSynAngelizeState));
end;

const
  _STATECOLOR: array[TServiceState] of TConsoleColor = (
    ccBlue,       // NotInstalled
    ccLightRed,   // Stopped
    ccGreen,      // Starting
    ccRed,        // Stopping
    ccLightGreen, // Running
    ccGreen,      // Resuming
    ccBrown,      // Pausing
    ccWhite,      // Paused
    ccMagenta,    // Failed
    ccYellow);    // ErrorRetrievingState

procedure TSynAngelize.ListServices;
var
  ss: TServiceState;
  state: TSynAngelizeState;
  i: PtrInt;
begin
  ss := CurrentState;
  if ss <> ssRunning then
    ConsoleWrite('Main service state is %', [ToText(ss)^], ccMagenta)
  else if LoadServicesState(state) and
          ({%H-}state.Service <> nil) then
    for i := 0 to high(state.Service) do
      with state.Service[i] do
      begin
        ConsoleWrite('% %', [Name, ToText(State)^], _STATECOLOR[State]);
        if Info <> '' then
          ConsoleWrite('  %', [Info], ccLightGray);
      end
  else
    ConsoleWrite('Unknown service state', ccMagenta);
  TextColor(ccLightGray);
end;

procedure TSynAngelize.StartServices;
var
  l, i, a: PtrInt;
  s: TSynAngelizeService;
  log: ISynLog;
begin
  log := TSynLog.Enter(self, 'StartServices');
  // start sub-services following their Level order
  for l := 0 to high(fLevels) do
    for i := 0 to high(fService) do
    begin
      s := fService[i];
      if s.Level = fLevels[l] then
      begin
        for a := 0 to high(s.fStart) do
          // any exception on DoOne() should break the starting
          DoOne(self, log.Instance, s, TAglContext.doStart, s.fStart[a]);
        if s.Watch <> nil then
          s.fNextWatch := GetTickCount64 + s.WatchDelaySec * 1000;
      end;
    end;
  ComputeServicesStateFiles; // save initial state before any watchdog
end;

procedure TSynAngelize.StopServices;
var
  l, i, a: PtrInt;
  s: TSynAngelizeService;
  sf: TFileName;
  log: ISynLog;
begin
  log := TSynLog.Enter(self, 'StopServices');
  // stop sub-services following their reverse Level order
  for l := high(fLevels) downto 0 do
    for i := 0 to high(fService) do
    begin
      s := fService[i];
      if s.Level = fLevels[l] then
        for a := 0 to high(s.fStop) do
        try
          DoOne(self, log.Instance, s, TAglContext.doStop, s.fStop[a]);
        except
          on E: Exception do
            // any exception should continue the stopping
            log.Log(sllError, 'StopServices: DoStop(%,%) failed as %',
              [s.Name, s.fStop[a], E.ClassType], self);
        end;
    end;
  // delete state files
  sf := TSynAngelizeSettings(fSettings).StateFile;
  if sf <> '' then
  begin
    log.Log(sllTrace, 'StopServices: Delete % and %.html', [sf, sf], self);
    DeleteFile(sf);
    DeleteFile(sf + '.html');
  end;
end;

procedure TSynAngelize.StartWatching;
begin
  fWatchThread := TSynBackgroundThreadProcess.Create('watchdog',
    WatchEverySecond, 1000, nil, TSynLog.Family.OnThreadEnded);
end;

procedure TSynAngelize.WatchEverySecond(Sender: TSynBackgroundThreadProcess);
var
  i, a: PtrInt;
  tix: Int64;
  s: TSynAngelizeService;
  log: ISynLog;
begin
  tix := GetTickCount64;
  for i := 0 to high(fService) do
  begin
    s := fService[i];
    if (s.fNextWatch = 0) or
       (tix < s.fNextWatch) then
      continue;
    if log = nil then
      log := TSynLog.Enter(self, 'WatchEverySecond');
    for a := 0 to high(s.fWatch) do
      try
        DoWatch(log.Instance, s, s.fWatch[a]);
      except
        on E: Exception do // any exception should continue the watching
          log.Log(sllWarning, 'WatchEverySecond: DoWatch(%,%) raised %',
            [s.Name, s.fWatch[a], E.ClassType], self);
      end;
    tix := GetTickCount64; // may have changed during DoWatch() progress
    s.fNextWatch := tix + s.WatchDelaySec * 1000;
  end;
  if log <> nil then
    ComputeServicesStateFiles;
end;

procedure TSynAngelize.StopWatching;
begin
  try
    with TSynLog.Enter(self, 'StopWatching') do
      FreeAndNil(fWatchThread);
  except // should always continue, even or weird issue
  end;
end;

procedure TSynAngelize.Start;
begin
  // should raise ESynAngelize on any issue, or let background work begin
  if fService = nil then
    LoadServicesFromSettingsFolder;
  if fService = nil then
    exit; // nothing to start
  StartServices;
  StartWatching;
end;

procedure TSynAngelize.Stop;
begin
  StopWatching;
  StopServices;
end;


end.
