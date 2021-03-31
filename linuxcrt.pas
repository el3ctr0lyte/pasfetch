unit linuxcrt;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  mcColor = char;
  mcValue = string;

//attribute constants
const
  mcAAttrOff    = '0';
  mcABold       = '1';
  mcAUnderscore = '4';
  mcABlink      = '5';
  mcAReverse    = '7';
  mcAConcealed  = '8';

//color constants
const
  mcCBlack   = '0';
  mcCRed     = '1';
  mcCGreen   = '2';
  mcCYellow  = '3';
  mcCBlue    = '4';
  mcCMagenta = '5';
  mcCCyan    = '6';
  mcCWhite   = '7';

procedure mcFgColor(color:mcColor);
procedure mcBgColor(color:mcColor);
procedure mcAttr(attr:mcColor);
procedure mcClsLn();
procedure mcClsDisp();
procedure mcGotoXYH(x,y:mcValue);
procedure mcGotoXYf(x,y:mcValue);

implementation

//change foreground color
procedure mcFgColor(color: mcColor);
begin
  write(#27'[3'+color+'m');
end;

//change background color
procedure mcBgColor(color: mcColor);
begin
  write(#27'[4'+color+'m');
end;

//apply an attribute
procedure mcAttr(attr: mcColor);
begin
  write(#27'['+attr+'m');
end;

//clear line
procedure mcClsLn();
begin
  write(#27'[100000D');
  write(#27'[K');
end;

//clear screen
procedure mcClsDisp();
begin
  write(#27'[2J');
  write(#27'[0;0H');
end;

//goto a specified location on screen
procedure mcGotoXYH(x, y: mcValue);
begin
  write(#27'['+x+';'+y+'H');
end;

//goto a specified location on screen
procedure mcGotoXYf(x, y: mcValue);
begin
  write(#27'['+x+';'+y+'f');
end;

end.

