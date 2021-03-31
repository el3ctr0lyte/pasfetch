program pasfetch;
{
####################
####--Pasfetch--####
##--el3ctr0lyte--###
####################
}
uses
    sysutils, linux, baseunix, Classes, StrUtils, DateUtils, linuxcrt;
var
  infos:UtsName;
  colors:char;
  sysinfos:PSysInfo;
  osinfo,osfile:TStringList;
  i:integer;
  shell,memtotal,memshared ,memavail,memcached, membuffers, memreclaimable:string;
begin
  //define colors
  colors:=mcCRed;
  if LowerCase(ParamStr(1)) = 'red' then
  begin
    colors:=mccred;
  end;

  if LowerCase(ParamStr(1)) = 'black' then
  begin
    colors:=mccblack;
  end;

  if LowerCase(ParamStr(1)) = 'blue' then
  begin
    colors:=mccblue;
  end;

  if LowerCase(ParamStr(1)) = 'green' then
  begin
    colors:=mccgreen;
  end;

  if LowerCase(ParamStr(1)) = 'cyan' then
  begin
    colors:=mcccyan;
  end;

  if LowerCase(ParamStr(1)) = 'magenta' then
  begin
    colors:=mcCMagenta;
  end;

  if LowerCase(ParamStr(1)) = 'yellow' then
  begin
    colors:=mccyellow;
  end;

  if LowerCase(ParamStr(1)) = 'white' then
  begin
    colors:=mccwhite;
  end;

  //this was when this still used the crt unit

  //if LowerCase(ParamStr(1)) = 'brown' then
  //begin
  //  colors:=brown;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'lightgray' then
  //begin
  //  colors:=lightgray;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'darkgray' then
  //begin
  //  colors:=darkgray;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'lightblue' then
  //begin
  //  colors:=lightblue;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'lightgreen' then
  //begin
  //  colors:=lightgreen;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'lightcyan' then
  //begin
  //  colors:=lightcyan;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'lightred' then
  //begin
  //  colors:=lightred;
  //end;
  //
  //if LowerCase(ParamStr(1)) = 'lightmagenta' then
  //begin
  //  colors:=lightmagenta;
  //end;

  //Print help prompt
  if (LowerCase(ParamStr(1)) = '-h') or (LowerCase(ParamStr(1)) = '--help') then
  begin
    writeln('Usage: pasfetch <color>');
    writeln('');
    writeln('The color parameter is optional. The default is red');
    writeln('Color parameter values include: ');
    writeln('white, yellow, magenta, cyan, green, blue, black, red');
    exit;
  end;

  writeln('');

  FpUname(infos);

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
      mcFgColor(colors);
      mcAttr(mcABold);
      write('OS: ');
      mcFgColor(mccwhite);
      mcAttr(mcAAttrOff);
      write(osinfo.Strings[i+1]);
      writeln(' ('+string(infos.Machine)+')');
      break;
    end;
  end;
  osfile.Free;
  osinfo.Free;

  //uptime
  mcFgColor(colors);
  mcAttr(mcABold);
  write('Uptime: ');
  mcFgColor(mccwhite);
  mcAttr(mcAAttrOff);
  new(sysinfos);
  Sysinfo(sysinfos);
  //TDateTime represents days. Sysinfo.uptime represents seconds. Therefore we have to devide sysinfo.uptime by
  //86400(number of seconds in a day) to convert it to a "days" representation suitable for the FormatDateTime function.
  writeln(FormatDateTime('dd:hh:mm',sysinfos^.uptime/86400)+' (dd:hh:mm)');

  //memory
  mcFgColor(colors);
  mcAttr(mcABold);
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
    if osinfo.Strings[i] = 'Shmem' then
    begin
      memshared:=osinfo.Strings[i+1];
    end;
    if osinfo.Strings[i] = 'SReclaimable' then
    begin
      memreclaimable:=osinfo.Strings[i+1];
    end;
    if (memtotal = '') and (memavail ='') then
    begin
      break;
    end;
  end;
  mcFgColor(mccwhite);
  mcAttr(mcAAttrOff);

  //memory usage calculation: MemTotal - MemAvail - MemCached - MemBuffers

  //memory calculation:
  //(memtotal + memshared) - memfree - memcached - membuffers - memreclaimable
  writeln(inttostr(round((strtoint(memtotal) + StrToInt(memshared) - strtoint(memavail) - StrToInt(memcached) - strtoint(membuffers) - StrToInt(memreclaimable)) /1024)) + 'MB / '+ inttostr(round(strtoint(memtotal)/1024))+'MB');

  //kernel version  and architecure
  mcFgColor(colors);
  mcAttr(mcABold);
  write('Kernel: ');
  mcFgColor(mccwhite);
  mcAttr(mcAAttrOff);
  writeln(infos.Release);

  mcFgColor(colors);
  mcAttr(mcABold);
  write('Shell: ');
  mcFgColor(mccwhite);
  mcAttr(mcAAttrOff);

  //shell
  shell:=GetEnvironmentVariable('SHELL');
  shell:=ReplaceStr(shell,'/usr/bin/','');
  shell:=ReplaceStr(shell,'/bin/','');
  shell:=ReplaceStr(shell,'/usr/sbin/','');
  writeln(shell);

  Dispose(sysinfos);
  writeln('');
end.

