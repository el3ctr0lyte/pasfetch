program pasfetch;
uses
    crt,sysutils,linux,baseunix, Classes,StrUtils;
var
  infos:UtsName;
  oldattr,colors:byte;
  sysinfos:PSysInfo;
  osinfo,osfile:TStringList;
  i:integer;
  shell,memtotal,memavail,memcached, membuffers:string;
begin
  colors:=red;
  if LowerCase(ParamStr(1)) = 'red' then
  begin
    colors:=red;
  end;

  if LowerCase(ParamStr(1)) = 'black' then
  begin
    colors:=black;
  end;

  if LowerCase(ParamStr(1)) = 'blue' then
  begin
    colors:=blue;
  end;

  if LowerCase(ParamStr(1)) = 'green' then
  begin
    colors:=green;
  end;

  if LowerCase(ParamStr(1)) = 'cyan' then
  begin
    colors:=cyan;
  end;

  if LowerCase(ParamStr(1)) = 'magenta' then
  begin
    colors:=magenta;
  end;

  if LowerCase(ParamStr(1)) = 'brown' then
  begin
    colors:=brown;
  end;

  if LowerCase(ParamStr(1)) = 'lightgray' then
  begin
    colors:=lightgray;
  end;

  if LowerCase(ParamStr(1)) = 'darkgray' then
  begin
    colors:=darkgray;
  end;

  if LowerCase(ParamStr(1)) = 'lightblue' then
  begin
    colors:=lightblue;
  end;

  if LowerCase(ParamStr(1)) = 'lightgreen' then
  begin
    colors:=lightgreen;
  end;

  if LowerCase(ParamStr(1)) = 'lightcyan' then
  begin
    colors:=lightcyan;
  end;

  if LowerCase(ParamStr(1)) = 'lightred' then
  begin
    colors:=lightred;
  end;

  if LowerCase(ParamStr(1)) = 'lightmagenta' then
  begin
    colors:=lightmagenta;
  end;

  if LowerCase(ParamStr(1)) = 'yellow' then
  begin
    colors:=yellow;
  end;

  if LowerCase(ParamStr(1)) = 'white' then
  begin
    colors:=white;
  end;

  if (LowerCase(ParamStr(1)) = '-h') or (LowerCase(ParamStr(1)) = '--help') then
  begin
    writeln('Usage: pasfetch <color>');
    writeln('');
    writeln('The color parameter is optional. The default is red');
    writeln('Color parameter values include: ');
    writeln('white, yellow, lightmagenta, lightred, lightcyan, lightgreen, lightblue, darkgray, lightgray, brown, magenta, cyan, green, blue, black, red');
    exit;
  end;

  writeln('');

  FpUname(infos);
  oldattr:=TextAttr;

  //os name
  osfile:=TStringList.Create;
  osfile.LoadFromFile('/etc/os-release');
  osinfo:=TStringList.Create;
  osinfo.Delimiter:='=';
  osinfo.DelimitedText:=osfile.Text;
  for i := 0 to osinfo.Count -1 do
  begin
    if osinfo.Strings[i] = 'PRETTY_NAME' then
    begin
      textcolor(colors);
      highvideo();
      write('OS: ');
      TextColor(oldattr);
      lowvideo();
      write(osinfo.Strings[i+1]);
      writeln(' ('+string(infos.Machine)+')');
      break;
    end;
  end;
  osfile.Free;
  osinfo.Free;

  //uptime
  TextColor(colors);
  highvideo();
  write('Uptime: ');
  TextColor(oldattr);
  lowvideo();
  new(sysinfos);
  Sysinfo(sysinfos);
  writeln(FormatDateTime('hh:mm:ss',sysinfos^.uptime/86400));

  //memory
  textcolor(colors);
  HighVideo;
  write('Memory: ');
  osfile:=TStringList.Create;
  osinfo:=TStringList.Create;
  osfile.LoadFromFile('/proc/meminfo');
  osinfo.Delimiter:=':';
  osinfo.DelimitedText:=osfile.Text;
  osfile.free;
  memavail:='';
  memtotal:='';
  for i := 0 to osinfo.Count -1 do
  begin
    if osinfo.Strings[i] = 'MemFree' then
    begin
      memavail:=osinfo.Strings[i+1];
    end;
    if osinfo.Strings[i] = 'MemTotal' then
    begin
      memtotal:=osinfo.Strings[i+1];
    end;
    if osinfo.Strings[i] = 'Cached' then
    begin
      memcached:=osinfo.Strings[i+1];
    end;
    if osinfo.Strings[i] = 'Buffers' then
    begin
      membuffers:=osinfo.Strings[i+1];
    end;
    if (memtotal = '') and (memavail ='') then
    begin
      break;
    end;
  end;
  textcolor(oldattr);
  LowVideo;
  writeln(inttostr(round((strtoint(memtotal) - strtoint(memavail) - StrToInt(memcached) -strtoint(membuffers)) /1024)) + 'MB / '+ inttostr(round(strtoint(memtotal)/1024))+'MB');

  //kernel version
  TextColor(colors);
  highvideo();
  write('Kernel: ');
  TextColor(oldattr);
  lowvideo();
  writeln(infos.Release);

  textcolor(colors);
  HighVideo();
  write('Shell: ');
  TextColor(oldattr);
  LowVideo();
  shell:=FpGetEnv('SHELL');
  shell:=ReplaceStr(shell,'/usr/bin/','');
  shell:=ReplaceStr(shell,'/bin/','');
  shell:=ReplaceStr(shell,'/usr/sbin/','');
  writeln(shell);

  Dispose(sysinfos);
  writeln('');
end.

